# Ansible Playbook to install minikube in a standard Linux VM


## From https://kubernetes.io/docs/tasks/tools/install-minikube/
* This installation procedure is a problem in itself : I already provisioned a virtual machine, I don't want the recipe to handle IAAS on my behalf, or I want to be able to customize it easily.
* minikube offers to adavanced users the possibility to do that using the `--vm-driver=none` option
* https://minikube.sigs.k8s.io/docs/reference/drivers/none/


## Using the `--vm-driver=none` option

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


# Security warning

### The `--vm-driver=none` option 's consequences

En utilsiant cette option, Pour le résumer :
* on a deux problèmes de sécurité :
  * des processus miinikube exposés au monde extérieur, comme l'API server, qui sont exécutés par l'utilsiateur root. Cela est un problème.
  * des credentials token etc... notamment les tokens de la configuration `kubectl`, qui sont démunis de toute protection
* on a des recommandations de l'équipe minkube officielle pour amener des mesures de porotection quant à ces deux axes de vulnérabilité :
  * utiliser un firewall

Source 1 : https://stackoverflow.com/questions/51708990/why-are-minikube-clusters-launched-with-vm-driver-none-vulnerable-to-csrf

* morceaux choisis :

>
> WARNING: IT IS RECOMMENDED NOT TO RUN THE NONE DRIVER ON PERSONAL WORKSTATIONS
> The ‘none’ driver will run an insecure kubernetes apiserver as root that may leave the host vulnerable to CSRF attacks
>
>
> This security warning about running minikube with the `--vm-driver=none` option, we have a security breach. I need to understand this breach  :
>
> https://stackoverflow.com/questions/51708990/why-are-minikube-clusters-launched-with-vm-driver-none-vulnerable-to-csrf
>
> The documentation on attacks inside the minikube is scarce. Basically when you use --vm-driver=none the kubectl config and credentials will be root owned and will be available in the home directory. You need to move them and set appropriate permissions. Also as the secret tokens that are usually used to protect from those kind of attacks would be easily accessible by the attacker. If you do not move the components and set the permissions they could become a potential vector in using the apiserver as a confused deputy when introducing the request as root.
>
> I think that the most dangerous part is: --vm-driver=none exposes the whole process as root. Your kubeapi is running as root. If an attacker could exploit that he would get control of a process operating inside the kernel that runs as a root - and that as we know makes the attacker the owner of the system and could become a gateway not only for the CSFR attack.
>
> Also it is worth mentioning that security is not a priority concern in minikube as it is mostly tool for learning if you would like something more security focused you could consider kubeadm which is:
>
>
> >
> > a toolkit for bootstrapping a best-practises Kubernetes cluster on existing infrastructure.
> >
>

>
> Decreased security minikube starts services that may be available on the Internet. Please ensure that you have a firewall to protect your host from unexpected access. For instance: apiserver listens on TCP *:8443 kubelet listens on TCP *:10250 and *:10255 kube-scheduler listens on TCP *:10259 kube-controller listens on TCP *:10257 Containers may have full access to your filesystem. Containers may be able to execute arbitrary code on your host, by using container escape vulnerabilities such as `CVE-2019-5736`. Please keep your release of minikube up to date.
>
> See https://minikube.sigs.k8s.io/docs/reference/drivers/none/
>


#### References

* https://medium.com/@nieldw/running-minikube-with-vm-driver-none-47de91eab84c
* Googling : https://www.google.com/search?client=firefox-b-e&ei=6uJ7XvwKyu-ABtDbqdgB&q=install+minikube+linux+without+vm&oq=install+minikube+linux+without+
