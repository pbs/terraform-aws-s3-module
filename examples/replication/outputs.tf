output "source_bucket_name" {
  description = "Name of the source bucket"
  value       = module.source_bucket.name
}

output "source_bucket_arn" {
  description = "ARN of the source bucket"
  value       = module.source_bucket.arn
}

output "target_bucket_name" {
  description = "Name of the target bucket"
  value       = module.target_bucket.name
}

output "target_bucket_arn" {
  description = "ARN of the target bucket"
  value       = module.target_bucket.arn
}
