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
  # key_name = "creshKeyPair"
  key_name = "jblCreshPaireClef"
  # key_name = "${module.aws_key_pair.deployercreds.key_name}"
  security_groups = ["${aws_security_group.allow_all.name}"]
  # iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
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
resource "aws_security_group" "allow_all_in" {
  name = "allow_ssh"
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ---
# outbound traffic to at least, be able to
# use package manager inside the
# linux amazon AMI distro
# ---
resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  prefix_list_ids   = ["${aws_vpc_endpoint.my_endpoint.prefix_list_id}"]
  from_port         = 0
  security_group_id = "sg-123456"
}
# ---
# Test it : [terraform import aws_key_pair.deployercreds creshkey]
# ---
# resource "aws_key_pair" "deployercreds" {
#   key_name   = "creshkey"
#   public_key = "var.my_ssh_pubkey"
# }
#
