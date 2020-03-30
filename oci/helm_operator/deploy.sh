#!/bin/bash

set -x

export MINIKUBE_HOST=${MINIKUBE_HOST:-'minikube.pegasusio.io'}
# export MINIKUBE_PUBLIC_IP='127.0.0.1'
export MINIKUBE_PUBLIC_IP=$(cat ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/public_elastic_ip)

echo "---------------------------------------------------------------------------------"
echo '---   Env sum up : '
echo "---------------------------------------------------------------------------------"
echo "--- MINIKUBE_HOST=[${MINIKUBE_HOST}]"
echo "--- MINIKUBE_PUBLIC_IP=[${MINIKUBE_PUBLIC_IP}]"
echo "---------------------------------------------------------------------------------"

# ---
#
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'
echo '---   Now deploying app'
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'
# 
# -------------------------------------------------------
# Helm and kubeCTL are configured for hitting and
# authenticating the desired k8s cluster on AWS
# like with a kubeconfig file for kubectl
#
helm install --name creshtest ./helmcresh
