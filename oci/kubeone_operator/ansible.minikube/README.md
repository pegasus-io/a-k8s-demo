# Ansible Playbook to install minikube in a standard Linux VM


## From https://kubernetes.io/docs/tasks/tools/install-minikube/
* This iinstallation procedure is a problem in itself : I already provisioned a virtual machine, I don't want the recipe to handle IAAS on my behalf, or I want to be able to customize it easily.

## From articles I found

* First, install minikube as usual :

```bash
export MINIKUBE_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export MINIKUBE_VERSION=1.8.2
export MINIKUBE_VERSION_TAG="v${MINIKUBE_VERSION}"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION_TAG}/minikube-linux-amd64 \
  && chmod +x minikube

# alsofor the minikube binary to be there :
mv mnikube /usr/local/bin
```

* Launch minikube with the `--vm-driver` option set to `none` :

```bash
sudo minikube start --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost

```


* Complete provision and start test :

```bash
# ---
# True, we're supposed not to use virtualization, still, I
# wanna know where I am and I believe what I see.
echo '---------------------------------------------------------------------------------'
echo '---   VIRUTALIZATION CAPABILITIES OF CONTAINERIZATION HOST [$(hostname)] :'
echo '---------------------------------------------------------------------------------'
grep -E --color 'vmx|svm' /proc/cpuinfo
echo '---------------------------------------------------------------------------------'
echo '---------------------------------------------------------------------------------'


export MINIKUBE_VERSION_TAG=latest
# https://github.com/kubernetes/minikube/releases/tag/v1.8.2
export MINIKUBE_VERSION=1.8.2
export MINIKUBE_VERSION_TAG="v${MINIKUBE_VERSION}"

curl -Lo minikube https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION_TAG}/minikube-linux-amd64 \
  && chmod +x minikube

# alsofor the minikube binary to be there :
mv mnikube /usr/local/bin
minikube --version

sudo minikube start --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost

```







#### References

* https://medium.com/@nieldw/running-minikube-with-vm-driver-none-47de91eab84c
* Googling : https://www.google.com/search?client=firefox-b-e&ei=6uJ7XvwKyu-ABtDbqdgB&q=install+minikube+linux+without+vm&oq=install+minikube+linux+without+
