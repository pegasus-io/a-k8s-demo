/*
Copyright 2020 Jean-Baptiste-Lasselle

GNU GPL v3

Inspired by @sahityamaruvada
in his article https://medium.com/@sahityamaruvada/spinning-up-instances-with-terraform-in-azure-and-aws-38f251d462e8

But mostly debugged using https://www.terraform.io/docs/providers/aws/r/instance.html
*/

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "creshVM" {
  ami             = var.aws_instance_desired_ami #id of desired AMI
  instance_type   = var.aws_instance_type
  security_groups = ["${aws_security_group.allow_all.name}"]
  tags = {
    Env = "creshdemo"
  }
}
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Env = "creshdemo"
  }
}
resource "aws_eip_association" "eip_assoc" {
  allocation_id   = "${aws_eip.eip.id}"
  network_interface_id = "${aws_instance.creshVM.primary_network_interface_id}"
}
resource "aws_security_group" "allow_all" {
  name = "allow_ssh"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "var.my_ssh_pubkey"
}
