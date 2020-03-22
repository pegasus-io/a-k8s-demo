# Architecture de la solution

TODO : schema SVG du fonctionnement de l'automatisation


## Création du Helm Chart + Code source App NodeJS Mongo

transposition de https://www.digitalocean.com/community/tutorials/how-to-scale-a-node-js-application-with-mongodb-on-kubernetes-using-helm de digital ocean, à aws

### Code Source App

Pour avoir une exemple d'app nodejs avec mongo db branché derrière


* j'ai une app nodejs avec base de données mongodb qui marche, https://gitlab.com/second-bureau/pegasus/pokus/exterieur/infra/example-node-mongo-app.git, je peux le vérifier en exécutant :

```bash
export DEMO_HOME=$(mktemp -d -t demo-node-mongo-XXXXXXXXXX)
export URI_TO_GIT_REPO=git@gitlab.com:second-bureau/pegasus/pokus/exterieur/infra/example-node-mongo-app

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
```
Je n'ai plus qu'à aligner les noms d'images docker des deux conteneurs, le conteneur nodejs (contient client et serveur en un bloc), et le conteneur bdd


#### Orchestration

* Le Atlantis lance le terraform généré par kubeone/
* J'ai mis en oeuvre le Terraform Ansible Provider, pour déclencher un Ansible Playbook après le terraform apply.
* Le playbook ansible va exécuter localement :
  * si le cluster Kubernetes n'est pas déjà existant, la commande `kubeone install config.yaml -t .` (provision du cluster k8s)
  * la commande `helm install --name creshtest ./helmcresh` (déploiement application)
  * Voici mon Playbook KubeOne / Helm cresh Local exec, Il faudra séparer en ansible roles les deux tâches suivantes, si ce n'est en deux playbook ansible distincts :
    * `kubeone` K8S Cluster provisioning :
```yaml
---

- name: Create the K8S cluster on AWS, using KubeOne
  hosts: 127.0.0.1
  connection: local
  gather_facts: false
  become: yes
  tasks:
    # installing KubeOne is done in the base container, now
    # we need to terraform init and then :
    # push to SSH_URI_TO_ATLANTIS_WATCHED_GIT
    # make the first [0.0.0] release in the SSH_URI_TO_ATLANTIS_WATCHED_GIT
    # so that Atlantis get the webhook for the master branch event on the release
    # - name: installing KubeOne is done in the base container,
    - name: Create K8S Cluster using KubeOne
      command: kubeone install config.yaml -t .
      debug:
        msg: " [Create K8S Cluster using KubeOne] - The hostname is {{ ansible_net_hostname }} and the OS is {{ ansible_net_version }}"


```
    * `Helm Chart` pour le déploiement de la Cresh App dans le K8S Cluster sur AWS :
```yaml
---
- name: Deploy the Express TypeScript Cresh App to the K8S Cluster on AWS
  hosts: 127.0.0.1
  connection: local
  gather_facts: false
  become: yes
  tasks:
    - name: Deploy App To K8S Cluster on AWS, using Helm
      command: helm install --name creshtest ./helmcresh
      debug:
        msg: " [Deploy App To K8S Cluster on AWS, using Helm] - The hostname is {{ ansible_net_hostname }} and the OS is {{ ansible_net_version }}"

```
* Je mettrai en oeuvre le plugin https://github.com/adammck/terraform-inventory  pour avoir l'inventaire ansible des nodes du cluster Kubernetes, par inventaire dynamique ansible, après le terraform apply :

```bash
ansible -m ping all -i ./path/to/thisfile
# here [./path/to/thisfile] is any executable file, that ansible will execute, and
# that ansible expects to return on its standard output stream, a string made of
# a JSON with an expected grammar JSON Shema , specifying all
# hosts groups and hosts meta data. Ansible doc says it has to be python, or shell script, but
# it can be any executable, as long as it returns the well formed JSON object.
# So this can be programmed in golang, like the [terraform-inventory] ansible plugin
# Or this amateur one : https://github.com/marthjod/ansible-one-inventory
#

# terraform-inventory  executalbe file is in the current directory :
ls -allh ./terraform-inventory || exit 1

ansible -i ./terraform-inventory  -m ping all
ansible-playbook -c kubeone-helm-playbook.yml -i ./terraform-inventory

```
* J'utiliserai le `atlantis.yaml` "_Repo level_" pour customiser le comportenent d'Atlantis uniquement pour le repo git du terraform bootstrapé par `KubeOne`: [comme indiqué ici](https://www.runatlantis.io/docs/server-side-repo-config.html#example-server-side-repo) et pour faire une démonstration de cette feature capitale pour l'intégration aux workflow globaux.



https://www.runatlantis.io/docs/server-configuration.html#environment-variables




### Helm Chart

```bash
helm create helmcresh
cd helmcresh/
atom .
```
* contenu du fichier `helmcresh/values.yaml` :

```Yaml
# Default values for nodeapp.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 3

image:
  repository: your_dockerhub_username/node-replicas
  tag: latest
  pullPolicy: IfNotPresent

nameOverride: ""
fullnameOverride: ""

service:
  type: LoadBalancer
  port: 80
  targetPort: 8080
# ...
```
* contenu de `helmcresh/templates/secret.yaml` :
```Yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-auth
data:
  # base64-encoded values
  MONGO_USERNAME: your_encoded_username
  MONGO_PASSWORD: your_encoded_password
```
* contenu de `helmcresh/templates/configmap.yaml` :
```Yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  MONGO_HOSTNAME: "mongo-mongodb-replicaset-0.mongo-mongodb-replicaset.default.svc.cluster.local,mongo-mongodb-replicaset-1.mongo-mongodb-replicaset.default.svc.cluster.local,mongo-mongodb-replicaset-2.mongo-mongodb-replicaset.default.svc.cluster.local"
  MONGO_PORT: "27017"
  MONGO_DB: "sharkinfo"
  MONGO_REPLICASET: "db"
```
* contenu de `helmcresh/templates/deployment.yaml` :
```Yaml
apiVersion: apps/v1
kind: Deployment
metadata:
...
  spec:
    containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        env:
        - name: MONGO_USERNAME
          valueFrom:
            secretKeyRef:
              key: MONGO_USERNAME
              name: {{ .Release.Name }}-auth
        - name: MONGO_PASSWORD
          valueFrom:
            secretKeyRef:
              key: MONGO_PASSWORD
              name: {{ .Release.Name }}-auth
        - name: MONGO_HOSTNAME
          valueFrom:
            configMapKeyRef:
              key: MONGO_HOSTNAME
              name: {{ .Release.Name }}-config
        - name: MONGO_PORT
          valueFrom:
            configMapKeyRef:
              key: MONGO_PORT
              name: {{ .Release.Name }}-config
        - name: MONGO_DB
          valueFrom:
            configMapKeyRef:
              key: MONGO_DB
              name: {{ .Release.Name }}-config
        - name: MONGO_REPLICASET
          valueFrom:
            configMapKeyRef:
              key: MONGO_REPLICASET
              name: {{ .Release.Name }}-config
        ports:
          - name: http
            containerPort: 8080
            protocol: TCP
        # --- Liveness and Readiness Probes HEALTHCHECKING POD AND RUNNING APP.
        #      Those are identically defined here, but don't have to be.
        #
        livenessProbe:
          httpGet:
            path: /sharks
            port: http
        readinessProbe:
          httpGet:
            path: /sharks
            port: http

```
* Maintenant on peut déployer l'application dans le cluster :
```Yaml
# Helm and kubeCTL are configured for hitting and
# authenticating the desired k8s cluster on AWS
# like with a kubeconfig file for kubectl
#
helm install --name creshtest ./helmcresh
```
