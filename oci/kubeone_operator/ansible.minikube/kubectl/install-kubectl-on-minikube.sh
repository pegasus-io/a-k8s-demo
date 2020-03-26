#!/bin/bash

set -x

# ---
# True, we're supposed not to use virtualization, still, I
# wanna know where I am and I believe what I see : You will
# check that there is no need for virtualizaion to run
# minikube with the '--vm-driver=none' option
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



export KUBECTL_MINIKUBE_CA_CERT_PATH=$(sudo cat /root/.kube/config|grep certificate-authority| awk '{print $2}')
export KUBECTL_MINIKUBE_CA_CERT_FILENAME=$(echo ${KUBECTL_MINIKUBE_CA_CERT_PATH}|awk -F '/' '{print $NF}')
export KUBECTL_CLIENT_CERT_PATH=$(sudo cat /root/.kube/config|grep client-certificate| awk '{print $2}')
export KUBECTL_CLIENT_CERT_FILENAME=$(echo ${KUBECTL_CLIENT_CERT_PATH}|awk -F '/' '{print $NF}')
export KUBECTL_CLIENT_KEY_PATH=$(sudo cat /root/.kube/config|grep client-key| awk '{print $2}')
export KUBECTL_CLIENT_KEY_FILENAME=$(echo ${KUBECTL_CLIENT_KEY_PATH}|awk -F '/' '{print $NF}')

mkdir -p ~/.kube

sudo cp /root/.kube/config ~/.kube
sudo cp ${KUBECTL_MINIKUBE_CA_CERT_PATH} ~/.kube
sudo cp ${KUBECTL_CLIENT_CERT_PATH} ~/.kube
sudo cp ${KUBECTL_CLIENT_KEY_PATH} ~/.kube

export CURRENTUSER=$USER
sudo chown -R ${CURRENTUSER}:${CURRENTUSER} /home/${CURRENTUSER}/.kube
unset CURRENTUSER

sed -i "s#certificate-authority:.*#certificate-authority: ${KUBECTL_MINIKUBE_CA_CERT_FILENAME}#g" ~/.kube/config
sed -i "s#client-certificate:.*#client-certificate: ${KUBECTL_CLIENT_CERT_FILENAME}#g" ~/.kube/config
sed -i "s#client-key:.*#client-key: ${KUBECTL_CLIENT_KEY_FILENAME}#g" ~/.kube/config


sed -i "s#server:.*#client-key: https://${MINIKUBE_HOST}:8443#g" ~/.kube/config


kubectl version




# sudo kubectl version
