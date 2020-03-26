#!/bin/bash

set -x


#!/bin/bash

set -x

export MINIKUBE_HOST=${MINIKUBE_HOST:-'minikube.pegasusio.io'}

# ---
#
echo '---------------------------------------------------------------------------------'
echo '---   Install kubectl on host [$(hostname)] :'
echo '---------------------------------------------------------------------------------'

export KUBECTL_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export KUBECTL_VERSION=${KUBECTL_VERSION:-'1.18.0'}
export KUBECTL_OS=${KUBECTL_OS:-'linux'}
export KUBECTL_CPU_ARCH=${KUBECTL_CPU_ARCH:-'amd64'}

export KUBECTL_VERSION_TAG="v${KUBECTL_VERSION}"

curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION_TAG}/bin/${KUBECTL_OS}/${KUBECTL_CPU_ARCH}/kubectl \
  && chmod +x kubectl

# alsofor the minikube binary to be there :
sudo mv ./kubectl /usr/local/bin
kubectl version --client

mkdir -p ~/.kube && sudo cp /root/.kube/config ~/.kube

export CURRENTUSER=$USER

sudo kubectl version
