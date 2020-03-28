#!/bin/bash

set -x
export MINIKUBE_HOST=${MINIKUBE_HOST:-'minikube.pegasusio.io'}
export MINIKUBE_PUBLIC_IP='127.0.0.1'

# --- 192.168.1.22 minikube.pegasusio.io pegasusio.io
#
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'
echo '---   GUI'
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'

clear
echo "What is the public IP Address through which your Kubernetes API server (your AWS VM) is reachable ? (type and press enter to validate)"
read MINIKUBE_PUBLIC_IP_ANSWER


if [ "x${MINIKUBE_PUBLIC_IP_ANSWER}" == "x" ]; then
  echo "You must provide the IP Address of your Kubernetes API server, or this script cannot configure kubectl for you"
  exit 2
fi;
export MINIKUBE_PUBLIC_IP=${MINIKUBE_PUBLIC_IP_ANSWER}


clear
echo "What hostname would you like to your Kubernetes API server ? "
echo "(type and press <E>nter to validate, defaults to [${MINIKUBE_HOST}] if you just press <E>nter)"
read MINIKUBE_HOST_ANSWER

if [ "x${MINIKUBE_HOST_ANSWER}" == "x" ]; then
  echo "defaulting [MINIKUBE_HOST] to [${MINIKUBE_HOST}] "
else
  export MINIKUBE_HOST=${MINIKUBE_HOST_ANSWER}
fi;


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
echo '---   net config'
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'

export CURRENTUSER=$USER
sudo cat /etc/hosts > ./etc.hosts.first
sudo chown ${CURRENTUSER}:${CURRENTUSER} ./etc.hosts.first
unset CURRENTUSER

echo '' >> ./etc.hosts.first
echo "# --------------------" >> ./etc.hosts.first
echo "# --- Kubectl Addon" >> ./etc.hosts.first
echo "${MINIKUBE_PUBLIC_IP} ${MINIKUBE_HOST}" >> ./etc.hosts.first
echo '' >> ./etc.hosts.first
sudo cp -f ./etc.hosts.first /etc/hosts
rm ./etc.hosts.first


echo '---------------------------------------------------------------------------------'
echo '---   Content of [/etc/hosts] : '
echo '---------------------------------------------------------------------------------'

sudo cat /etc/hosts
echo "Press <E>nter to proceed"
read

# ---
#
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'
echo '---   Installing kubectl on host [$(hostname)] ...'
echo '---------------------------------------------------------------------------------'
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

# ---
# Adding the minikube profile to the non root operator
sudo cp -fR /root/.minikube ~/

export CURRENTUSER=$USER
sudo chown -R ${CURRENTUSER}:${CURRENTUSER} /home/${CURRENTUSER}/.kube
sudo chown -R ${CURRENTUSER}:${CURRENTUSER} /home/${CURRENTUSER}/.minikube
unset CURRENTUSER

sed -i "s#certificate-authority:.*#certificate-authority: ${KUBECTL_MINIKUBE_CA_CERT_FILENAME}#g" ~/.kube/config
sed -i "s#client-certificate:.*#client-certificate: ${KUBECTL_CLIENT_CERT_FILENAME}#g" ~/.kube/config
sed -i "s#client-key:.*#client-key: ${KUBECTL_CLIENT_KEY_FILENAME}#g" ~/.kube/config


sed -i "s#server:.*#server: https://${MINIKUBE_HOST}:8443#g" ~/.kube/config


kubectl version

echo ''
echo " now execute : "
echo ''
echo "     minikube dashboard "
echo ''


sudo cp -fR /root/.minikube ~/
sudo cp -fR /root/.kube ~/
# sudo kubectl version
