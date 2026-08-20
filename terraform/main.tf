terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "portfoliobucket" {
  bucket = "testing-portforlio-south-1"
}

resource "aws_s3_bucket_website_configuration" "portfoliobucket_web_config" {
  bucket = aws_s3_bucket.portfoliobucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

output "website_endpoint" {
  description = "website endpoint of s3 web hosting"
  value       = aws_s3_bucket_website_configuration.portfoliobucket_web_config.website_endpoint
}
