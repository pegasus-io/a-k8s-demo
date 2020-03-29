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
# sudo mv ./kubectl /usr/local/bin
sudo mv ./kubectl /usr/bin




# CONFIG


mkdir -p ~/.kube


echo 'apiVersion: v1' >> ~/.kube/config
echo 'clusters:' >> ~/.kube/config
echo '- cluster:' >> ~/.kube/config
echo '    certificate-authority: ca.crt' >> ~/.kube/config
echo "    server: https://${MINIKUBE_HOST}:8443" >> ~/.kube/config
echo '  name: minikube' >> ~/.kube/config
echo 'contexts:' >> ~/.kube/config
echo '- context:' >> ~/.kube/config
echo '    cluster: minikube' >> ~/.kube/config
echo '    user: minikube' >> ~/.kube/config
echo '  name: minikube' >> ~/.kube/config
echo 'current-context: minikube' >> ~/.kube/config
echo 'kind: Config' >> ~/.kube/config
echo 'preferences: {}' >> ~/.kube/config
echo 'users:' >> ~/.kube/config
echo '- name: minikube' >> ~/.kube/config
echo '  user:' >> ~/.kube/config
echo "    client-certificate: ${HOME}/.kube/client.crt" >> ~/.kube/config
echo "    client-key: ${HOME}/.kube/client.key" >> ~/.kube/config

clear
echo ''
echo '---------------------------------------------------------------------------------'
echo "Kubectl is now installed"
kubectl version --client
echo '---------------------------------------------------------------------------------'
echo 'Now you must provide '
echo "the following files which your provider must"
echo " have given you, at the below-specified path on your machine : "
echo '---------------------------------------------------------------------------------'
echo "    certificate-authority: ${HOME}/.kube/ca.crt"
echo "    client-certificate: ${HOME}/.kube/client.crt"
echo "    client-key: ${HOME}/.kube/client.key"
echo '---------------------------------------------------------------------------------'
echo "Once those files are installed at the specified paths, execute : "
echo ""
echo "  sudo chown -R ${USER}:${USER} ~/.kube/"
echo ""
echo '---------------------------------------------------------------------------------'
echo " Then only, you will be able to use [kubectl] "
echo '---------------------------------------------------------------------------------'
echo ''
echo '       CLUSTER DASHBOARD '
echo ''
echo '---------------------------------------------------------------------------------'
echo " Now, to access your K8S cluster Dashboard, just execute the command :"
echo "     kubectl proxy "
echo ""
echo " You can then immediately access your kubernetes cluster dashboard at : "
echo "http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/overview?namespace=default"
echo '---------------------------------------------------------------------------------'
# kubectl proxy
echo '---------------------------------------------------------------------------------'
