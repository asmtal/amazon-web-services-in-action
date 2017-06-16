terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_instance" "webserver" {
  ami           = "ami-80861296"
  instance_type = "t2.micro"

  key_name="dave-lipscomb-key"
  
  tags {
    Name = "HelloWorld"
  }
}

provider "aws" {
  profile = "lipscomb"
  region = "${var.region}"
}