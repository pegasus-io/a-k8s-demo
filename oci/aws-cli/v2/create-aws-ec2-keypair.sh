#!/bin/sh

# ------
#
# This script instals AWS CLI (major) version '2'
# on your Linux machine
#
# ------

# ------
#
# Creating the AWS EC2 Key pair before terraform apply
#
# ------

set +x

# ---
# first, delete the keypair, whether it exists or
# not, because if it does not exist, aws cli will
# remain silent.
aws ec2 delete-key-pair --key-name jblCreshPaireClef
# then create the keypair
aws ec2 create-key-pair --key-name jblCreshPaireClef --query 'KeyMaterial' --output text > /home/${BUMBLEBEE_USER}/creshAWSSSHkey.pem
chmod 600 ~/creshAWSSSHkey.pem
cp ~/creshAWSSSHkey.pem /aws/share

# aws ec2 create-key-pair --key-name jblCreshPaireClef | jq '.KeyMaterial' | awk -F '"' '{print $2}' > /home/${BUMBLEBEE_USER}/creshAWSSSHkey
echo "-------------------------------------------"
echo ''
echo "debug "
echo ''
echo "-------------------------------------------"

sleep infinity
#exec "$SHELL"
