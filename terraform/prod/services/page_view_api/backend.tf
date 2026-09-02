terraform {
  backend "s3" {
    bucket = "portfolio-tf-states-1421"
    key    = "prod/services/page_view_api/terraform.tfstate"
    region = "ap-south-1"

    encrypt = true
    use_lockfile = true
    }
}