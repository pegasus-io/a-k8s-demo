#!/bin/bash


# set -e

echo '----------------------------------------------------------------'
echo "Initializing AWS secrets for Terraform to use them"
echo '----------------------------------------------------------------'
ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/credentials
echo '----------------------------------------------------------------'
cat ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/credentials
echo '----------------------------------------------------------------'
mkdir -p ~/.aws/

cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/credentials ~/.aws/credentials

echo '----------------------------------------------------------------'
echo "Completed Initializing AWS secrets for Terraform to use them"
echo "Checking : "
echo '----------------------------------------------------------------'
ls -allh ~/.aws/credentials
echo '----------------------------------------------------------------'
cat ~/.aws/credentials
echo '----------------------------------------------------------------'
