#!/bin/bash


# --------------
export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)


source .little.pipeline.env

# run
docker-compose up -d --force-recreate kubeone_gitops_operator && docker-compose logs -f kubeone_gitops_operator
