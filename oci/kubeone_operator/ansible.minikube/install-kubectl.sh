#!/bin/bash

set -x

# ---
# True, we're supposed not to use virtualization, still, I
# wanna know where I am and I believe what I see : You will
# check that there is no need for virtualizaion to run
# minikube with the '--vm-driver=none' option
echo '---------------------------------------------------------------------------------'
echo '---   VIRUTALIZATION CAPABILITIES OF CONTAINERIZATION HOST [$(hostname)] :'
echo '---------------------------------------------------------------------------------'
grep -E --color 'vmx|svm' /proc/cpuinfo
echo '---------------------------------------------------------------------------------'
echo " Has [$(hostname)] virtuamlization capabilities ?"
egrep -q 'vmx|svm' /proc/cpuinfo && echo yes || echo no
echo '---------------------------------------------------------------------------------'


export KUBECTL_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export KUBECTL_VERSION=${KUBECTL_VERSION:-'1.18.0'}
export KUBECTL_VERSION_TAG="v${KUBECTL_VERSION}"

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl \
  && chmod +x kubectl

# alsofor the minikube binary to be there :
sudo mv ./minikube /usr/local/bin
minikube version
