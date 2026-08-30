output "ecr_repository_url" {
  value       = aws_ecr_repository.lambda_ecr.repository_url
  description = "ECR Repository URL"
}