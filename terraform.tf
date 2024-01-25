terraform {
  required_version = ">= 1.7.0"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      version = ">= 5.30.0"
    }
  }
}
