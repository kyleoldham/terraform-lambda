variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-west-2"
}

variable "AMIS" {
  type = "map"
  default = {
    us-west-2 = "ami-12345"
    us-west-1 = "ami-67890"
  }
}
