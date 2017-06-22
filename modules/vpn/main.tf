terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  profile = "lipscomb"
  region  = "${var.region}"
}

data "aws_vpc" "default-vpc" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnet" "default-subnet" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.default-vpc.id}"]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

data "template_file" "vpn-cloudformation" {
  template = "${file("${path.module}/vpn-cloudformation.json")}"
}

resource "aws_cloudformation_stack" "vpn" {
  name = "vpn"

  parameters {
    KeyName           = "mykey"
    VPC               = "${data.aws_vpc.default-vpc.id}"
    Subnet            = "${data.aws_subnet.default-subnet.id}"
    IPSecSharedSecret = "blahsharedsecret"
    VPNUser           = "vpn"
    VPNPassword       = "blahpassword"
  }

  template_body = "${data.template_file.vpn-cloudformation.rendered}"
}
