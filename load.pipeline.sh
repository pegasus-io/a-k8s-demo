#!/bin/bash

export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)
export PROVISIONING_HOME=$(mktemp --tmpdir=/home/${USER}/.a-k8s-demo/k8s -d -t provisioning.${HORODATAGE}.XXX)

export KUBERNETES_VERSION=${KUBERNETES_VERSION:-'1.17.4'}
export K8S_PACKAGE_DWNLD_URI=https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz
export K8S_PACKAGE_FILENAME=$(echo $K8S_PACKAGE_DWNLD_URI|awk -F '/' '{print $NF}')

echo ""
echo "Downloading [$K8S_PACKAGE_FILENAME] version [$KUBERNETES_VERSION] ..."
echo ""

# [-c] option to continue / resume downloads on network hiccups
wget -c $K8S_PACKAGE_DWNLD_URI

echo ""
echo "Installing [$K8S_PACKAGE_FILENAME] version [$KUBERNETES_VERSION] to [$PROVISIONING_HOME] ..."
echo ""

tar -xvf $K8S_PACKAGE_FILENAME -C $PROVISIONING_HOME
