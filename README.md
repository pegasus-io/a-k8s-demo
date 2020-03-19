# Purpose

In this little exeriment, we will : 
* Quickly develop a simple Express based REST API, The REST API feeds from a mongodb DataBase
* An deploy this REST API in a Kubernetes Cluster, hosted on AWS, using only AWS Free Tier subscribe plan.


## The Kubernetes Cluster

### Provision

* To provision the k8s cluster, and set up your local work environment, execute this : 

```bash
# export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'
export SSH_URI_TO_THIS_REPO=git@github.com:pegasus-io/a-k8s-demo.git
export URI_DE_CE_REPO=https://github.com/pegasus-io/a-k8s-demo.git
export OPS_HOME=$(mktemp -d -t a-k8s-demo.provisioning-XXXXXXXXXX)
export THIS_RECIPES_RELEASE=0.0.1
git clone "$URI_DE_CE_REPO" $OPS_HOME
cd $OPS_HOME
git checkout $THIS_RECIPES_RELEASE
chmod +x ./load.pipeline.sh
./load.pipeline.sh
```

## The NodeJS / TypeScript App Source Code

The source code is under the `./source.code/` folder in this git repository.

## The IAAC

* To work on this recipe, you need to fulfil its requirements and dependencies : 
  * it requires you to "_git-work_" within a `/bin/bash` shell session
  * it requires [this bash utilility I designed](https://github.com/pegasus-io/ever-better-iaac/releases/0.0.1) for personal use, to make available the `initializeIAAC` command below.

* Once meeting requirements, you can use the following cyle, to contirbute to this recipe : 

```bash
export WORK_HOME=~/ever-iaac-atom-w
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
export COMMIT_MESSAGE="$COMMIT_MESSAGE Resuming work on [$URI_TO_GIT_REPO_I_CHOSE]"
export FEATURE_ALIAS="git-flowing-the-iaac"
git flow feature start $FEATURE_ALIAS
# git add --all && git commit -m "$COMMIT_MESSAGE" && git push -u origin HEAD

# git flow feature finish $FEATURE_ALIAS && git push -u origin HEAD

# REALEASE START - git flow release start $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - with signature # git flow release finish -s $FEATURE_ALIAS && git push -u origin HEAD
# REALEASE FINISH - without signature # git flow release finish $FEATURE_ALIAS && git push -u origin HEAD

```
