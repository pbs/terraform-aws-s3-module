output "name" {
  description = "Name of the bucket"
  value       = module.s3.name
}

output "arn" {
  description = "ARN of the bucket"
  value       = module.s3.arn
}
