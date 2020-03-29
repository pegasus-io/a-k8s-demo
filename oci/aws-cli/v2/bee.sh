#!/bin/sh

# ------
#
# This script executes all the bee tasks, sequentially
#
# ------

set +x

./create-aws-ec2-keypair.sh

./retrieve-ami-id.sh
