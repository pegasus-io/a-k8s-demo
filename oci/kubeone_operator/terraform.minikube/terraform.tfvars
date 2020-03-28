cluster_name = "creshk8s"
aws_region="eu-west-3"
aws_instance_type="t3.micro"
# ---
# To find out which AMI id to use, go here :
# https://aws.amazon.com/amazon-linux-ami/
# ---
# aws_instance_desired_ami="ami-0ebc281c20e89ba4b"
# --- #
# I changed AMI because :
#
# "ami-0ebc281c20e89ba4b" => Amazon Linux version 1, does not have systemd
# "ami-0ebc281c20e89ba4b" => Amazon Linux version 2, does have systemd, required by minikube
#
aws_instance_desired_ami="ami-0716bb6ef91dc148c"

# my_ssh_pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
# FUSA = Fisrt User Super Admin
my_ssh_pubkey = "EC2_FUSA_SSH_AUTH_PUBKEY_JINJA2_VAR"
