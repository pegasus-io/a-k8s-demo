#!/bin/bash


# set -e
set -x

cd $BUMBLEBEE_HOME_INSIDE_CONTAINER
./init-iaac.sh || exit 2
./install-kubeone.sh || exit 3
./install-terraform.sh || exit 4
./kubeone-prepare.sh || exit 5
