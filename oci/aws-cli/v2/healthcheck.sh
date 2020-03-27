#!/bin/sh

# ------
#
# This script instals AWS CLI (major) version '2'
# on your Linux machine
#
# ------


export FILE_TO_CHECK=/home/${BUMBLEBEE_USER}/creshAWSSSHkey


checkWitnessFile () {

}

if [ -f ${FILE_TO_CHECK} ]; then
  echo "The file [${FILE_TO_CHECK}] was found, health changes to healthy:  EC2 KeyPair is ready"
  exit 0
else
  sleep 1
  checkWitnessFile
fi;
