#!/bin/bash


# --------------
export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)

source .little.pipeline.env

./create-bumblebee.sh

exit 0
source .little.pipeline.env
# clean
docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes
# build
docker-compose -f docker-compose.build.yml build kubeone_operator
# run
docker-compose up -d --force-recreate kubeone_gitops_operator && docker-compose logs -f kubeone_gitops_operator
