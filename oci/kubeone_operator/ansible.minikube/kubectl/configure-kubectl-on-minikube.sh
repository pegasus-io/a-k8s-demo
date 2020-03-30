#!/bin/bash

set -x

export MINIKUBE_HOST=${MINIKUBE_HOST:-'minikube.pegasusio.io'}

export KUBECTL_MINIKUBE_CA_CERT_PATH=$(sudo cat /root/.kube/config|grep certificate-authority| awk '{print $2}')
export KUBECTL_MINIKUBE_CA_CERT_FILENAME=$(echo ${KUBECTL_MINIKUBE_CA_CERT_PATH}|awk -F '/' '{print $NF}')
export KUBECTL_CLIENT_CERT_PATH=$(sudo cat /root/.kube/config|grep client-certificate| awk '{print $2}')
export KUBECTL_CLIENT_CERT_FILENAME=$(echo ${KUBECTL_CLIENT_CERT_PATH}|awk -F '/' '{print $NF}')
export KUBECTL_CLIENT_KEY_PATH=$(sudo cat /root/.kube/config|grep client-key| awk '{print $2}')
export KUBECTL_CLIENT_KEY_FILENAME=$(echo ${KUBECTL_CLIENT_KEY_PATH}|awk -F '/' '{print $NF}')


sudo cp -fR /root/.kube/ ~/
# ---
# Adding the minikube profile to the non root operator
sudo cp -fR /root/.minikube ~/


export CURRENTUSER=$USER
sudo chown -R ${CURRENTUSER}:${CURRENTUSER} /home/${CURRENTUSER}/.kube
sudo chown -R ${CURRENTUSER}:${CURRENTUSER} /home/${CURRENTUSER}/.minikube
sudo chmod -R o+rw /home/${CURRENTUSER}/.kube
sudo chmod -R o+rw /home/${CURRENTUSER}/.minikube
unset CURRENTUSER


sed -i "s#/root#/home/${USER}#g" ~/.kube/config
# sed -i "s#certificate-authority:.*#certificate-authority: ${KUBECTL_MINIKUBE_CA_CERT_FILENAME}#g" ~/.kube/config
# sed -i "s#client-certificate:.*#client-certificate: ${KUBECTL_CLIENT_CERT_FILENAME}#g" ~/.kube/config
# sed -i "s#client-key:.*#client-key: ${KUBECTL_CLIENT_KEY_FILENAME}#g" ~/.kube/config


sed -i "s#server:.*#server: https://${MINIKUBE_HOST}:8443#g" ~/.kube/config


kubectl version

echo ''
echo " now execute you can execute : "
echo ''
echo "     minikube dashboard "
echo ''
