output "domain_name" {
  value       = module.s3-cloudfront.domain_name
  description = "The domain name of cloudfront"
}