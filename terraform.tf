terraform {
  required_version = ">= 1.9.0"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      version = ">= 5.0.0"
    }
  }
}
