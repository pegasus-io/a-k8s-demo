# Purpose

In this little exeriment, we will :
* Quickly develop a simple Express based REST API, The REST API feeds from a mongodb DataBase
* An deploy this REST API in a Kubernetes Cluster, hosted on AWS, using only AWS Free Tier subscribe plan.


## The Kubernetes Cluster



### Provision

To provision the k8s cluster, and set up your local work environment, execute this in an empty directory :

```bash
# You choose your method, SSH or HTTPS
export SSH_URI_TO_THIS_REPO=git@github.com:pegasus-io/a-k8s-demo.git
export URI_DE_CE_REPO=https://github.com/pegasus-io/a-k8s-demo.git
export THIS_RECIPES_RELEASE=0.0.1
git clone "$URI_DE_CE_REPO" .
git checkout $THIS_RECIPES_RELEASE
chmod +x ./load.pipeline.sh
./load.pipeline.sh

```

Why have I named my shell script `load.pipeline.sh`, instead of `setup-k8s.sh` ?

Because after k8s is fully operational on AWS, we will have to :
* deploy the `NodeJS` / `TypeScript` application to Kubernetes
* perform a couple of example operations on one of the pods of our Kubernetes deployment :
  * tail -f the logs of the `NodeJS` / `TypeScript` application running live
  * reconfigure one of the configuration parameters of the `NodeJS` / `TypeScript` application, and restart it, ultimately
  * change the source code of the `NodeJS` / `TypeScript` application, like change the background color of the API landing page, and re-deploy it live, ultimately using a blue green deployment. `Commit ID` will be visible on landing page of the APi, in every release of the `NodeJS` / `TypeScript` app.


### K8S cluster provision Tests

```bash
git clone https://github.com/pegasus-io/a-k8s-demo.git ~/a-k8s-demo
cd ~/a-k8s-demo
git checkout feature/k8s-provisioning
chmod +x ./load.pipeline.sh
./load.pipeline.sh

# -------------
# - tear down :
# -------------
# docker-compose down --rmi all && docker system prune -f --all && docker system prune -f --volumes && cd && rm -fr ~/a-k8s-demo && clear

```

## The `NodeJS` / `TypeScript` App Source Code

The source code is under the `./source.code/` folder in this git repository.

## The IAAC

* To work on this recipe, you need to fulfil its requirements and dependencies :
  * it requires you to "_git-work_" within a `/bin/bash` shell session
  * it requires [this bash utilility I designed](https://github.com/pegasus-io/ever-better-iaac/releases/0.0.1) for personal use, to make available the `initializeIAAC` command below.

* Once meeting requirements, you can use the following cyle, to contirbute to this recipe :

```bash
export WORK_HOME=~/a-k8s-demo-atom-w
# -- IAAC ENV when I work on the present repo
export SSH_URI_TO_THIS_REPO=git@github.com:pegasus-io/a-k8s-demo.git

initializeIAAC $SSH_URI_TO_THIS_REPO $WORK_HOME

git flow init --defaults
git push -u origin --all


atom .

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'
# If I want to make a release today ...
export REALEASE_VERSION=0.0.2

export COMMIT_MESSAGE=""
export COMMIT_MESSAGE="$COMMIT_MESSAGE Resuming work on [$SSH_URI_TO_THIS_REPO]"
export FEATURE_ALIAS="git-flowing-the-iaac"
git flow feature start $FEATURE_ALIAS
# git add --all && git commit -m "$COMMIT_MESSAGE" && git push -u origin HEAD

# git flow feature finish $FEATURE_ALIAS && git push -u origin HEAD

# REALEASE START - git flow release start $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - with signature # git flow release finish -s $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - without signature # git flow release finish $FEATURE_ALIAS && git push -u origin HEAD

```
