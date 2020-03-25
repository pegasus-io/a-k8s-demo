variable "aws_region" {}
variable "cluster_name" {}
variable "aws_instance_type" {}
# ------------------------------------------------------
# This recipe provisions a single VM on AWS Free Tier
# ------------------------------------------------------
# aws_instance_desired_ami is the os image ID at AWS that
# is going to be installed inside the VM in AWS
# To find out which AMI id to use, go here :
# https://aws.amazon.com/amazon-linux-ami/
# ---
# 
variable "aws_instance_desired_ami" {}
