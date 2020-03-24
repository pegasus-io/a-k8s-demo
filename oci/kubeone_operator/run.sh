#!/bin/bash


# set -e
set -x

echo "Entrée dans [$0]"
cd $BUMBLEBEE_HOME_INSIDE_CONTAINER
./init-iaac.sh || exit 4
./init-aws.sh || exit 5
./kubeone-prepare.sh || exit 3
# installations are done at OCI image build time
# ./install-kubeone.sh || exit 6
# ./install-terraform.sh || exit 7
