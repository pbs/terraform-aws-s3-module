module "s3" {
  source = "../.."

  create_bucket_policy = false

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
