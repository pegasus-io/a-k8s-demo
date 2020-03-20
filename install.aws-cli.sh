#!/bin/bash

#
# Following official instructions at https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
#

export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)
export PROVISIONING_HOME=$(mktemp -d -t aws_cli.${HORODATAGE}.provisioning-XXXXXXXXXX)

export AWS_CLI_VERSION=${AWS_CLI_VERSION:-'1.17.4'}
export AWS_CLI_PACKAGE_DWNLD_URI=https://github.com/kubernetes/kubernetes/releases/download/v${AWS_CLI_VERSION}/kubernetes.tar.gz
export AWS_CLI_PACKAGE_FILENAME=$(echo $AWS_CLI_PACKAGE_DWNLD_URI|awk -F '/' '{print $NF}')

echo ""
echo "Downloading [$AWS_CLI_PACKAGE_FILENAME] version [$AWS_CLI_VERSION] ..."
echo ""

# [-c] option to continue / resume downloads on network hiccups
wget -c $AWS_CLI_PACKAGE_DWNLD_URI

echo ""
echo "Installing [$AWS_CLI_PACKAGE_FILENAME] version [$AWS_CLI_VERSION] to [$PROVISIONING_HOME] ..."
echo ""

tar -xvf $AWS_CLI_PACKAGE_FILENAME -C $PROVISIONING_HOME
