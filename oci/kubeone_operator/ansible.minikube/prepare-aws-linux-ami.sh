#!/bin/bash

set -x
sudo yum update -y
sudo yum install git systemctl

echo '------------------------------------------------------------'
echo ''
cat /etc/os-release
echo ''
echo '------------------------------------------------------------'
