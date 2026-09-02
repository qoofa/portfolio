resource "aws_s3_bucket" "tf_state" {
  bucket = "portfolio_tf_states_1421"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "ENABLED"
  }
}