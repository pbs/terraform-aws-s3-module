module "s3" {
  source = "../.."

  cors_rules = [{
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }]

  organization = var.organization
  environment  = var.environment
  product      = var.product
  repo         = var.repo
}
