#!/bin/bash

# -----------------------------------------------------#
# [ - This script uses error codes range - [10/19] - ]
# -----------------------------------------------------#
# set -e
set -x

echo "Entrée dans [$0]"
cd $BUMBLEBEE_HOME_INSIDE_CONTAINER
./init-iaac.sh || exit 11
./init-aws.sh || exit 12
# ---------------------------------------------------------
# Now installing TERRAFORM clean syntax module utility
# ---------------------------------------------------------
# creates a terraform linux user group
./install-terraform-clean-syntax.sh || exit 13
./kubeone-prepare.sh || exit 14
# installations are done at OCI image build time
# ./install-kubeone.sh || exit 15
# ./install-terraform.sh || exit 16
