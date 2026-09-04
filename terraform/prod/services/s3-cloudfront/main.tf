module "s3-cloudfront" {
  source = "../../../modules/services/s3-cloudfront"

  bucket_name = "s3-portfolio-1421"
} 