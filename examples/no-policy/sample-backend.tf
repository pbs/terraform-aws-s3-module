# terraform {
#   backend "s3" {
#     bucket         = "my-bucket-tfstate"
#     key            = "example-terraform-aws-s3-no-policy"
#     profile        = "my-profile"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock"
#   }
# }
