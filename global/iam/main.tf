terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  profile = "lipscomb"
  region  = "us-east-1"
}

# Policy documents are data source template which can be used to construct an IAM policy. It doesn't
# create anything directly on AWS. 
data "aws_iam_policy_document" "cloudformation_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudformation:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudformation_full_access" {
  name   = "cloudformation-full-access"
  policy = "${data.aws_iam_policy_document.cloudformation_full_access.json}"
}

# IAM policy which allows read-only access to CloudWatch
resource "aws_iam_user_policy_attachment" "dave_cloudformation_full_access" {
  user       = "dave.daniels"
  policy_arn = "${aws_iam_policy.cloudformation_full_access.arn}"
}
