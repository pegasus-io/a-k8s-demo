#!/bin/bash

set -x

# The Amazon Linux 2 is just a RHEL / CentOS derivative. 
# So I need Git, and docker in my AWS image, before running minikube install

sudo yum update -y
#
sudo yum install -y git

echo '------------------------------------------------------------'
echo ''
cat /etc/os-release
echo ''
echo '------------------------------------------------------------'

# - docker installation : this install is VERY bad, it does not install a specific verson of docker, just latest, so time dependent
# curl -fsSL https://get.docker.com/ | sh # => Amazon Linux is not supported by Docker
sudo yum install -y docker
