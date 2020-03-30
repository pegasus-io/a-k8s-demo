# KUBEONE DEFAULT TERRAFORM MINIFIED

* La recette minimale de provision proposée par `kubeone`, est conforme aux exigences officielles d'une configuration minimale Haute disponibilité de Kubernetes : 3 VM.
* Or, pour pouvoir afire une démo reposant à plsu de 75% sur le FRee Tier AWS, 3 VM, c'est trop.
* J'ai donc :
  * modifié le Terraform pour qu'il ne provisionne qu'une seule VM
  * ajouté un module utilitaire, fort utile : https://github.com/pegasus-io/flowed-terraform-clean-syntax

# Purpose of the experiment

In this little exeriment, we will :
* Quickly develop a simple Express based REST API, The REST API feeds from a mongodb DataBase
* An deploy this REST API in a Kubernetes Cluster, hosted on AWS, using only AWS Free Tier subscribe plan.


### How to see what's in this release

* To set up your local work environment, execute this in an empty directory :

```bash
# You choose your method, SSH or HTTPS
export SSH_URI_TO_THIS_REPO=git@github.com:pegasus-io/a-k8s-demo.git
export URI_DE_CE_REPO=https://github.com/pegasus-io/a-k8s-demo.git
export THIS_RECIPES_RELEASE=0.0.3
export THIS_RECIPES_RELEASE="feature/helm-operator"
git clone "$URI_DE_CE_REPO" .
git checkout $THIS_RECIPES_RELEASE
chmod +x ./load.pipeline.sh
./load.pipeline.sh

```

* To terraform the k8s cluster, execute, in the same shell session, and the same directory, the command :

```bash
./run.pipeline.sh
```
* Then, to install minikube on the freshly terraformed `AWS ec2` instance, proceed with the two following steps :
  * excute this on the AWS VM, to install `git` and `docker` :

```bash
# ---
# - git : to operate as a gitops
# - docker installation : this install is VERY bad, it does not install a specific verson of docker, just latest, so time dependent
sudo yum install -y git docker

export CURRENT_USER_ATREYOU=$(whoami)
sudo usermod -aG docker ${CURRENT_USER_ATREYOU}
unset CURRENT_USER_ATREYOU

sudo systemctl enable docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker.service

sudo yum update -y

```
  * then execute this, to install `minikube` :

```bash
# This will soon be an ansible playbook, which is going to be executed as Terraform provisioner, using the Terraform Ansible Provisioner.
export OPS_HOME="${HOME}/minikube"
export URI_DE_CE_REPO=https://github.com/pegasus-io/a-k8s-demo.git
export THIS_RECIPES_RELEASE=feature/helm-operator
git clone "$URI_DE_CE_REPO" ${OPS_HOME}
cd ${OPS_HOME}
git checkout $THIS_RECIPES_RELEASE
chmod +x ./oci/kubeone_operator/ansible.minikube/*.sh
./oci/kubeone_operator/ansible.minikube/install-minikube.sh

```

* Then you will install `kubectl` on your everyday laptop, of course a GNU/Linux, ar on worst case, a darwin :

```bash
export OPS_HOME="${HOME}/.kctl"
export URI_DE_CE_REPO=https://github.com/pegasus-io/a-k8s-demo.git
export THIS_RECIPES_RELEASE="feature/helm-operator"
git clone "$URI_DE_CE_REPO" ${OPS_HOME}
cd ${OPS_HOME}
git checkout $THIS_RECIPES_RELEASE
chmod +x ./oci/kubeone_operator/ansible.minikube/kubectl/*.sh
./oci/kubeone_operator/ansible.minikube/kubectl/install-kubectl.sh

```

* You can after that, if you feel like, pay a visit inside the factory :

```bash
docker exec -it kubeone_gitops_operator bash
# to test a few commands, like :
#
#   terraform init
#   terraform plan
#   terraform apply, (maybe terrafom import)
#   terraform output public_elastic_ip
#   terraform destroy,
#
# Top do so you will have  to :
# 'cd kubeone/source/examples/terraform/aws'
#
```

* After playing with terraform, maybe you want to deploy your NodeJS Express App , using `Helm` :

```bash

kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1

export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

kubectl logs $POD_NAME

kubectl exec $POD_NAME -- env
kubectl exec $POD_NAME -- echo "oh my, i am in kubernetes $(hostname)"
kubectl exec $POD_NAME -- ls -allh
kubectl exec $POD_NAME -- cat server.js

# ---
# Now exposing app to outside world

kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

kubectl get services
kubectl describe services/kubernetes-bootcamp
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=${NODE_PORT}
echo "Now you can visit your app at http://${YOUR_K8S_CLUSTER_IP}:${NODE_PORT}"
```

* And be my guest and see mine on AWS : http://15.236.98.183:31162/

* To deploy the other example app (Node + Mongo), docker login, and execute the following :

```bash
export OPS_HOME=~/.letsgo.k8S
# --- #
# Your username or organizationname on hub.docker.com / docker.io
# mine is pegasusio
# --- #
export YOUR_USERNAME_OR_ORG_NAME=pegasusio
git clone https://github.com/pegasus-io/example-nodeapp ${OPS_HOME}
cd ${OPS_HOME}
docker build -t pegasusio/nodeapp.js:0.0.3 .
# you docker logged
docker push pegasusio/nodeapp.js:0.0.3

kubectl apply -f kube/

export NODE_PORT=$(kubectl get services/nodeapp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=${NODE_PORT}

kubectl get services
kubectl describe services/nodeapp

echo "now your app is available on http://\${YOU_K8S_CLUSTER_IP}:${NODE_PORT}"

kubectl scale --replicas=2 deployment/nodeapp

kubectl get pods -l app=nodeapp --watch

```

* And to tear it all down, **first terraform destroy**, and then :

```bash

# -------------
# - tear down :
# -------------
docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes && cd && rm -fr ~/a-k8s-demo && clear

```

Why have I named my shell script `load.pipeline.sh`, instead of `setup-k8s.sh` ?

Because after k8s is fully operational on AWS, we will have to :
* deploy the `NodeJS` / `TypeScript` application to Kubernetes
* perform a couple of example operations on one of the pods of our Kubernetes deployment :
  * tail -f the logs of the `NodeJS` / `TypeScript` application running live
  * reconfigure one of the configuration parameters of the `NodeJS` / `TypeScript` application, and restart it, ultimately
  * change the source code of the `NodeJS` / `TypeScript` application, like change the background color of the API landing page, and re-deploy it live, ultimately using a blue green deployment. `Commit ID` will be visible on landing page of the APi, in every release of the `NodeJS` / `TypeScript` app.


## The `NodeJS` / `TypeScript` App Source Code

On The  App Side, onece the cluster is provided, what we need is  a `Helm Chart` to deploy our app to the Kuberentes Cluster.

The Helm Chart is not ready yet in this release, but you can already test the NodeJS Example App :


<pre>

export DEMO_HOME=$(mktemp -d -t demo-node-mongo-XXXXXXXXXX)
# export URI_TO_GIT_REPO=git@gitlab.com:second-bureau/pegasus/pokus/exterieur/infra/example-node-mongo-app
export URI_TO_GIT_REPO=git@github.com:pegasus-io/node-mongo-example-app.git

git clone $URI_TO_GIT_REPO $DEMO_HOME

cd $DEMO_HOME
docker-compose build && docker-compose up -d --force-recreate
echo ''
echo " Your app will be available at http://localhost:80/ and http://$(hostname):80/ "
echo ''
echo " To see the logs, execute this command : "
echo ''
echo " docker-compose logs -f ""
echo ''

</pre>
