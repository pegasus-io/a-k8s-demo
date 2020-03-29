#!/bin/bash


# --------------
export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)

source .little.pipeline.env
mkdir -p $PWD/beecli
./create-bumblebee.sh

source .little.pipeline.env
# clean
docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes
# build
docker-compose -f docker-compose.build.yml build awscli_v2
docker-compose up -d --force-recreate awscli_op1
# so we wait until execution has completed
# docker-compose logs -f awscli_op1
./wait-for-ec2-keypair.sh

docker-compose -f docker-compose.build.yml build kubeone_operator


echo ''
echo 'POINT DEBUG'
exit 0
# run
docker-compose up -d --force-recreate kubeone_gitops_operator && docker-compose logs -f kubeone_gitops_operator
