resource "aws_s3_bucket" "portfoliobucket" {
  bucket = var.bucket_name
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

resource "aws_s3_bucket_public_access_block" "portfoliobucket_public_access_config" {
  bucket = aws_s3_bucket.portfoliobucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.portfoliobucket.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.portfoliobucket.id}/*"
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_control" {
  bucket = aws_s3_bucket.portfoliobucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_control]

  bucket = aws_s3_bucket.portfoliobucket.id
  acl    = "log-delivery-write"
}

resource "aws_cloudfront_origin_access_identity" "distribution_identity" {
  comment = aws_s3_bucket.portfoliobucket.id
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = false
  comment             = aws_s3_bucket.portfoliobucket.id
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.portfoliobucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.portfoliobucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.distribution_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.portfoliobucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.portfoliobucket.bucket_domain_name
    prefix          = "logs/"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}