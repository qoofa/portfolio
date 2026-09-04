resource "aws_s3_bucket" "portfoliobucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "portfoliobucket_public_access_config" {
  bucket = aws_s3_bucket.portfoliobucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = false
  comment             = aws_s3_bucket.portfoliobucket.id
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.portfoliobucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.portfoliobucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront_only" {
  bucket = aws_s3_bucket.portfoliobucket.id
  policy = data.aws_iam_policy_document.allow_cloudfront_only.json

  depends_on = [aws_s3_bucket_public_access_block.portfoliobucket_public_access_config]
}

data "aws_iam_policy_document" "allow_cloudfront_only" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.portfoliobucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.distribution.arn]
    }
  }
}