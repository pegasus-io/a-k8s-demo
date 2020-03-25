#!/bin/sh

# ------
#
# This script instals AWS CLI (major) version '2'
# on your Linux machine
#
# ------

# ------
#
# Following official instructions at https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
#
# ------

set +x
export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)

# ------
# Ensuring that the paths you install to contain no
# volume or folder names that contain any spaces otherwise
# the installation would fail.
mkdir -p ~/.a-k8s-demo/aws_cli
export PROVISIONING_HOME=$(mktemp  --tmpdir=/home/${USER}/.a-k8s-demo/aws_cli -d -t provisioning.${HORODATAGE}.XXX)
# unused yet, AWS releases only major versions
export AWS_CLI_VERSION=${AWS_CLI_VERSION:-'0.0.0'}
export AWS_CLI_MAJOR_VERSION=${AWS_CLI_MAJOR_VERSION:-'2'}
export AWS_CLI_PACKAGE_DWNLD_URI=${AWS_CLI_PACKAGE_DWNLD_URI:-'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip'}
export AWS_CLI_PACKAGE_FILENAME=awscliv2.zip

echo ""
echo "Downloading [$AWS_CLI_PACKAGE_FILENAME] ..."
echo ""


curl "$AWS_CLI_PACKAGE_DWNLD_URI" -o "$AWS_CLI_PACKAGE_FILENAME"


echo ""
echo "Installing [$AWS_CLI_PACKAGE_FILENAME] major version [$AWS_CLI_MAJOR_VERSION] from [$PROVISIONING_HOME] ..."
echo ""
unzip $AWS_CLI_PACKAGE_FILENAME -d $PROVISIONING_HOME
ls -allh $PROVISIONING_HOME/aws

$PROVISIONING_HOME/aws/install

if [ $? == 0 ]; then
  aws --version
  aws iam list-users
else
  echo "Installing AWS CLI v2 failed, mzybe because you are not executing this as root"
  exit 1
fi;
