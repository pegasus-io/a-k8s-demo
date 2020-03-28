#!/bin/bash

set -x

# The Amazon Linux 2 is just a RHEL / CentOS derivative.
# So I need Git, and docker in my AWS image, before running minikube install

echo '------------------------------------------------------------'
echo ''
cat /etc/os-release
echo ''
echo '------------------------------------------------------------'

sudo yum update -y

# ---
# - git : to operate as a gitops
# - docker installation : this install is VERY bad, it does not install a specific verson of docker, just latest, so time dependent
sudo yum install -y git docker
