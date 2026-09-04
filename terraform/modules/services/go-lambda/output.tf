output "ecr_repository_url" {
  value       = aws_ecr_repository.lambda_ecr.repository_url
  description = "ECR Repository URL"
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}
