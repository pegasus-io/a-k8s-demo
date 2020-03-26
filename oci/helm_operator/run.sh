#!/bin/bash

# -----------------------------------------------------#
# [ - This script uses error codes range - [10/19] - ]
# -----------------------------------------------------#
# set -e
set -x

echo "Entrée dans [$0]"
cd $BUMBLEBEE_HOME_INSIDE_CONTAINER
./init-iaac.sh || exit 11
./install-kubectl.sh || exit 12
./install-helm.sh || exit 12

exec "${SHELL}"
