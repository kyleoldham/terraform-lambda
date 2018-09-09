provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "test" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "awsKey"
  vpc_security_group_ids = ["${var.vpcSec}"]
  subnet_id = "${var.vpcSub}"

  tags {
    Name = "Terraform deploy with EC2"
  }
}
