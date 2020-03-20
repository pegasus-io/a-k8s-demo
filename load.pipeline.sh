#!/bin/bash

export HORODATAGE=`date +%m-%d-%Y_%Hh-%Mmin-%Ssec`
export OPS_HOME=$(pwd)
export PROVISIONING_HOME=$(mktemp -d -t a-k8s-demo.${HORODATAGE}.provisioning-XXXXXXXXXX)


export KUBERNETES_VERSION=${KUBERNETES_VERSION:-'1.17.4'}

export K8S_PACKAGE_DWNLD_URI=https://github.com/kubernetes/kubernetes/releases/download/v${KUBERNETES_VERSION}/kubernetes.tar.gz
export K8S_PACKAGE_FILENAME=$(echo $K8S_PACKAGE_DWNLD_URI|awk -F '/' '{print $NF}')

echo ""
echo "Downloading [$K8S_PACKAGE_FILENAME] version [$KUBERNETES_VERSION] ..."
echo ""

wget $K8S_PACKAGE_DWNLD_URI

echo ""
echo "Installing [$K8S_PACKAGE_FILENAME] version [$KUBERNETES_VERSION] to [$PROVISIONING_HOME] ..."
echo ""

tar -xvf $K8S_PACKAGE_FILENAME -C $PROVISIONING_HOME
