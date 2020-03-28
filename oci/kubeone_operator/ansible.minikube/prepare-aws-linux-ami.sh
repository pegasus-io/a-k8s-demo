#!/bin/bash

set -x

# So I need Git and docker installed, before running minikube install

sudo yum update -y
#
sudo yum install git

echo '------------------------------------------------------------'
echo ''
cat /etc/os-release
echo ''
echo '------------------------------------------------------------'

# - docker installation
curl -fsSL https://get.docker.com/ | sh
