provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "s3-cloudfront" {
  source = "../../../modules/services/s3-cloudfront"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  bucket_name = "s3-portfolio-1421"
  domain_name = "minhaj.blog"
} 