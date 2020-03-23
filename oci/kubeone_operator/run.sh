#!/bin/bash


# set -e
set -x

echo "Entrée dans [$0]"
cd $BUMBLEBEE_HOME_INSIDE_CONTAINER
./init-iaac.sh || exit 2
# installations are done at OCI image build time
# ./install-kubeone.sh || exit 3
# ./install-terraform.sh || exit 4
./kubeone-prepare.sh || exit 5
