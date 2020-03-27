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

aws ec2 create-key-pair --key-name jblCreshPaireClef | jq '.KeyMaterial' | awk -F '"' '{print $2}' > ./creshAWSSSHkey
echo "-------------------------------------------"
echo ''
echo "debug "
echo ''
echo "-------------------------------------------"
# Now making the ssh key available for terraform opn the shared volume :
cp ./creshAWSSSHkey /aws/.secrets
