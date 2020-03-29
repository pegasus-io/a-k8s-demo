#!/bin/sh

# ------
#
# This script executes all the bee tasks, sequentially
#
# ------

set +x

${AWSCLI_HOME}/create-aws-ec2-keypair.sh

${AWSCLI_HOME}/retrieve-ami-id.sh
