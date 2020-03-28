#!/bin/bash

set -x

# So I need Git, before running minikube install

sudo yum update -y
#
sudo yum install git

echo '------------------------------------------------------------'
echo ''
cat /etc/os-release
echo ''
echo '------------------------------------------------------------'
