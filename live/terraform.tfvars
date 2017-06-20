# This is a template for Terraform state.
#
# Must add
#   terraform {
#     backend "s3" {}
#   }
# to main.tf of subdirectories, which Terragrunt
# will replace with this configuration.
#
# Can't be overridden in subdirectories.
#
terragrunt = {
  
  // NOTE: Lock blocks are not supported by Terragrunt anymore.

  # This is the remote_state template. terraform.tfvarsblah files in subdirectories should include
  # an "include" with a parent folders path. This will go up the directory path and use the
  # first terraform.tfvarsblah it finds, which should be this one.
  #
  #   include {
  #     path = "${find_in_parent_folders()}"
  #   }
  #
  # The modules should have a backend configuration, which will be replaced by Terragrunt with 
  # this template.
  #
  #   terraform {
  #     backend "s3" {}
  #   }
  #
  remote_state {
    backend = "s3"
    config {
      profile = "lipscomb"
      
      # unfortunately, this cannot be interpolated, so must be hard-coded. The same value will be hard-coded in this
      # file and the sibling common.tfvars file.
      # even though this is in the "global" directory, S3 buckets have regions. Rather than giving each region its
      # own state bucket, create one state bucket in us-east-1 for all regions to share. Will end up with a bucket
      # structure in us-east-1 like this:
      #
      #  S3/state-bucket/ap-southeast-2
      #  S3/state-bucket/us-east-1
      #  S3/state-bucket/s3
      #
      region = "us-east-1"
      
      # Terraform stores all variables in its state files in plain text, including
      # passwords, so make sure to encrypt.
      encrypt = true

      # Must be globally unique in AWS. Unfortunately, there's no way to
      # interpolate, so it must be duplicated wherever it's needed.
      bucket = "dave-amazon-web-services-in-action5-state"

      # Will provide a one-to-one mapping of the directory structure to key.
      # Note, Terragrunt interpolates the relative path to scope the key, but
      # the state file names will all be the same.
      key = "${path_relative_to_include()}/terraform.tfstate"

      # Terragrunt creates lock table automatically in DynamoDB. I think
      # it's best to let Terragrunt handle this.
      lock_table = "dave-amazon-web-services-in-action5-lock"
    }
  }

  terraform {
    # Force Terraform to keep trying to acquire a lock for up to 20 minutes
    # if someone else already has the lock. This might be useful as part of
    # an automated script, such as a CI build.
    extra_arguments "retry_lock" {
      commands = [
        "init",
        "apply",
        "refresh",
        "import",
        "plan",
        "taint",
        "untaint"
      ]

      arguments = [
        "-lock-timeout=20m"
      ]
    }
  }
}