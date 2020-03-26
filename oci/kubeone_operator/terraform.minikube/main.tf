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
  # keypair is created using AWS CLI : aws ec2 create-key-pair --key-name creshKeyPair --query 'KeyMaterial' --output text > ./aws.creshkey.pem
  key_name = "creshKeyPair"
  # key_name = "${module.aws_key_pair.deployercreds.key_name}"
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
# --------------------
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html
# We are in the default security group, and we set a rule that
# allows all in ...I'm bold.
# Better security : https://www.kerkeni.net/initialisation-dune-instance-aws-ec2-with-terraform.htm
# ---
resource "aws_security_group" "allow_all" {
  name = "allow_ssh"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# resource "aws_key_pair" "deployercreds" {
#   key_name   = "creshkey"
#   public_key = "var.my_ssh_pubkey"
# }
