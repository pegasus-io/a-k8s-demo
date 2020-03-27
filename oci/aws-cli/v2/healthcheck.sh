#!/bin/sh

# ------
#
# This script instals AWS CLI (major) version '2'
# on your Linux machine
#
# ------


export FILE_TO_CHECK=/home/${BUMBLEBEE_USER}/creshAWSSSHkey


checkWitnessFile () {
  if [ -f $1 ]; then
    echo "The file [$1] was found, health changes to healthy:  EC2 KeyPair is READY"
    return 0
  else
    echo "The file [$1] was NOT found, health changes to healthy:  EC2 KeyPair is NOT READY"
    return 1
  fi;
}

export IS_EC2_PAIR_READY=1
while [ "$IS_EC2_PAIR_READY" != "0" ]
do
  echo "checking health of the [AWSCLI_OPERATOR] container ..."
  export IS_EC2_PAIR_READY=$(checkWitnessFile $FILE_TO_CHECK)
  sleep 1s
done
