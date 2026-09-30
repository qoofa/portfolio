output "acm_validation" {
  value = module.s3-cloudfront.acm_certificate_validation_records
}

output "cloudfront_url" {
  value = module.s3-cloudfront.cloudfront_domain_name
}
