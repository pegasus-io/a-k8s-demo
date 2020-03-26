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


export MINIKUBE_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export MINIKUBE_VERSION=${MINIKUBE_VERSION:-'1.8.2'}
export MINIKUBE_VERSION_TAG="v${MINIKUBE_VERSION}"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION_TAG}/minikube-linux-amd64 \
  && chmod +x minikube

# alsofor the minikube binary to be there :
sudo mv ./minikube /usr/local/bin
minikube version
# --- #
# sets the none driver as the default : we don't have to use the '--vm-driver' option again.
# --- #
# jbl@poste-devops-typique:~/minikube$ sudo minikube config set driver none
# ❗  These changes will take effect upon a minikube delete and then a minikube start
# jbl@poste-devops-typique:~/minikube$
# --- clear enough
sudo minikube config set driver none

# Launching minikube
export MINI_K8S_API_SERVER_IP=${MINI_K8S_API_SERVER_IP:-'172.217.22.131'}
export MINI_K8S_API_SERVER_IP=${MINI_K8S_API_SERVER_IP:-'192.168.1.22'}

export API_SERVER_IPSLICE='[192.0.2.16, 192.0.2.17, 192.0.2.18, 192.0.2.19]'
export API_SERVER_IPSLICE='[192.168.1.0/24]'
export API_SERVER_IPSLICE='[192.168.1.22]'
export API_SERVER_IPSLICE="192.168.1.22"
export API_SERVER_IPSLICE="${MINI_K8S_API_SERVER_IP}"



# sudo minikube start --apiserver-ips 127.0.0.1 --apiserver-name localhost
sudo minikube start --apiserver-ips ${API_SERVER_IPSLICE} --apiserver-name minikube.pegasusio.io
# ❗  The 'none' driver does not respect the --cpus flag
