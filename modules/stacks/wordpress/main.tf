terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  profile = "lipscomb"
  region = "${var.region}"
}

resource "aws_cloudformation_stack" "wordpress_stack" {
  name = "wordpress-stack"

  tags {
    system = "wordpress"
  }

  template_url = "https://s3.amazonaws.com/awsinaction/chapter2/template.json"
}
