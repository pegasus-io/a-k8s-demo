#!/bin/bash


# set -e

echo '----------------------------------------------------------------'
echo "Initializing AWS secrets for Terraform to use them"
echo '----------------------------------------------------------------'
echo '----------------------------------------------------------------'
echo " Checking value of env. var. BUMBLEBEE_HOME_INSIDE_CONTAINER=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}]"
echo '----------------------------------------------------------------'
ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/
ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws
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


# -- Now modifying .bashrc so that we have terraform aws credentials builtin env
if [ -f ~/.bashrc ]; then
  rm ~/.bashrc
fi;
echo "export AWS_ACCESS_KEY_ID=\"$(cat ~/.aws/credentials | grep aws_access_key_id | awk -F '=' '{print $2}')\"" >> ~/.bashrc
echo "export AWS_SECRET_ACCESS_KEY=\"$(cat ~/.aws/credentials | grep aws_secret_access_key | awk -F '=' '{print $2}')\"" >> ~/.bashrc
echo "export AWS_DEFAULT_REGION=\"$(cat ~/.aws/credentials | grep region | awk -F '=' '{print $2}')\"" >> ~/.bashrc

# terraform plan
