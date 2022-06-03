resource "aws_s3_bucket_inventory" "inventory_prefix" {
  count = local.create_inventory_config ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  name   = var.inventory_bucket

  included_object_versions = var.inventory_included_object_versions

  schedule {
    frequency = var.inventory_frequency
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = "arn:aws:s3:::${var.inventory_bucket}"
      prefix     = local.inventory_bucket_prefix
    }
  }
}
