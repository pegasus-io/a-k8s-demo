#!/bin/bash


# --------------
export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)

source .little.pipeline.env

./install.aws-cli-v2.sh

exit 0

./provision-k8s-aws.sh
