output "acm_certificate_validation_records" {
  value = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  description = "DNS to add to Hostinger to validate SSL certificate."
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.distribution.domain_name
  description = "The Cloudfront URL. Point to Hostinger CNAME/ALIAS here"
}