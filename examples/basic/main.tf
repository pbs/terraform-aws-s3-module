module "s3" {
  source = "../.."

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
