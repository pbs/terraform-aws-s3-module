resource "aws_iam_role" "replication_role" {
  count              = local.create_replication_role ? 1 : 0
  name               = "${local.name}-replication"
  assume_role_policy = data.aws_iam_policy_document.s3_assume_role_policy[0].json
}

resource "aws_iam_role_policy" "replication_policy" {
  count = local.create_replication_role ? 1 : 0
  name  = "${local.name}-replication"
  role  = aws_iam_role.replication_role[0].id

  policy = jsonencode({
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [

          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"

        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Resource" : "arn:aws:s3:::${local.destination_bucket}/*"
      },
    ]
    Version = "2012-10-17"
  })
}

data "aws_iam_policy_document" "bucket_policy_doc" {
  count = local.generate_bucket_policy ? 1 : 0
  dynamic "statement" {
    for_each = var.allow_anonymous_vpce_access ? [var.allow_anonymous_vpce_access] : []
    content {
      actions = [
        "s3:GetObject",
      ]
      resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"]
      condition {
        test     = "StringEquals"
        variable = "aws:sourceVpce"
        values   = [var.vpce]
      }
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:ReplicateDelete",
        "s3:ReplicateObject",
      ]
      resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"]
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning"
      ]
      resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.id}"]
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:ObjectOwnerOverrideToBucketOwner"
      ]
      resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"]
    }
  }
  dynamic "statement" {
    for_each = var.force_tls ? [var.force_tls] : []
    content {
      effect = "Deny"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      actions = ["s3:*"]
      resources = [
        "arn:aws:s3:::${aws_s3_bucket.bucket.id}",
        "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*",
      ]
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = var.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  policy = local.bucket_policy
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
