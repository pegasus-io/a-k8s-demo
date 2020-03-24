/*
Copyright 2020 Jean-Baptiste-Lasselle

GNU GPL v3

*/

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "testingVM" {
  ami             = "ami-221ea342" #id of desired AMI
  instance_type   = "m3.medium"
  security_groups = ["${aws_security_group.allow_all.name}"]
  tags = {
    Env = "test"
  }
}
resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Env = "test"
  }
}
resource "aws_eip_association" "eip_assoc" {
  allocation_id   = "${aws_eip.eip.id}"
  network_interface_id = "${aws_instance.testingVM.primary_network_interface_id}"
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
