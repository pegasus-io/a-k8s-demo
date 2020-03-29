#!/bin/sh

# ------
#
# This script retieves from AWS the
#
# ------

set +x


aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text > ./amazon.linux.ami.id

cp amazon.linux.ami.id /aws/share
