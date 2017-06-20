variable "region" {
  description = "The region in which to run this module."
}

variable "instance_ami" {
  description = "The instance AMI. Each region's AMIs are different, so this must be set in the region."
}
