module "source_bucket" {
  source = "../.."

  name = "${var.product}-source"

  replication_configuration_shortcut = {
    destination_account_id = data.aws_caller_identity.current.account_id
    destination_bucket     = module.target_bucket.name
  }

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}

locals {
  file = "${path.module}/index.html"
}

resource "aws_s3_object" "object" {
  bucket = module.source_bucket.name
  key    = "index.html"
  source = local.file

  etag = filemd5(local.file)
}

module "target_bucket" {
  source = "../.."

  name = "${var.product}-target"

  replication_source = {
    account_id = data.aws_caller_identity.current.account_id
    role       = module.source_bucket.replication_role
  }

  force_destroy = true

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
