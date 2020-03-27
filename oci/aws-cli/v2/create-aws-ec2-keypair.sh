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

aws ec2 create-key-pair --key-name jblCreshPaireClef | jq '.KeyMaterial' | awk -F '"' '{print $2}' > /home/${BUMBLEBEE_USER}/creshAWSSSHkey
echo "-------------------------------------------"
echo ''
echo "debug "
echo ''
echo "-------------------------------------------"

exec "$SHELL"
