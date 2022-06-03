resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket
  bucket_prefix = local.bucket_prefix

  force_destroy = var.force_destroy

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.is_versioned ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count  = var.acl != null ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  acl    = var.acl
}


resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = local.object_ownership
  }
}

resource "aws_s3_bucket_cors_configuration" "cors_configuration" {
  count = length(var.cors_rules) != 0 ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count = length(local.replication_configuration_set) > 0 ? 1 : 0
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = aws_iam_role.replication_role[0].arn
  bucket = aws_s3_bucket.bucket.id

  dynamic "rule" {
    for_each = tolist(local.replication_configuration_set)[0]["rules"]
    content {
      id       = rule.value.id
      priority = rule.value.priority
      status   = rule.value.status

      destination {
        account = rule.value.destination_account_id
        bucket  = "arn:aws:s3:::${rule.value.destination_bucket}"

        access_control_translation {
          owner = rule.value.destination_access_control_translation_owner
        }
      }
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  dynamic "rule" {
    for_each = var.lifecycle_rules
    iterator = rule

    content {
      id     = lookup(rule.value, "id", null)
      prefix = lookup(rule.value, "prefix", null)
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "abort_incomplete_multipart_upload" {
        for_each = lookup(rule.value, "abort_incomplete_multipart_upload_days", null) == null ? [] : [rule.value.abort_incomplete_multipart_upload_days]
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }

      dynamic "expiration" {
        for_each = length(keys(lookup(rule.value, "expiration", {}))) == 0 ? [] : [rule.value.expiration]

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transition", [])

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = length(keys(lookup(rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [rule.value.noncurrent_version_expiration]
        iterator = expiration

        content {
          noncurrent_days = lookup(expiration.value, "days", null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(rule.value, "noncurrent_version_transition", [])
        iterator = transition

        content {
          noncurrent_days = lookup(transition.value, "days", null)
          storage_class   = transition.value.storage_class
        }
      }
    }
  }
}
