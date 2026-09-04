output "domain_name" {
  value       = aws_cloudfront_distribution.distribution.domain_name
  description = "The domain name of cloudfront"
}