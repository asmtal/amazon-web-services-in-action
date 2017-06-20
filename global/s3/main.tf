terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  profile = "lipscomb"
  region  = "us-east-1"
}

# This manages the bucket, but the bucket is created by Terragrunt when initializing a resource.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.remote_state_bucket}"
  region = "us-east-1"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
