terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_instance" "webserver" {
  # these are dependent on region
  ami           = "${var.instance_ami}"
  instance_type = "t2.micro"

  #key_name="dave-lipscomb-key"

  tags {
    Name = "HelloWorld"
  }
}

provider "aws" {
  profile = "lipscomb"
  region  = "${var.region}"
}
