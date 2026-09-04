output "ecr_repository_url" {
  value       = module.go_lambda_api.ecr_repository_url
  description = "ECR Repository URL"
}

output "base_url" {
  value = module.go_lambda_api.base_url
  description = "Base URL for API Gateway."
}
