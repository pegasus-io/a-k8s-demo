#/bin/bash

# this script boots up the Atlantis Workflow :
# => it initializes the git flow on the git repo watched by Atlantis
# => it ends with sending a pull request on the repo, which will trigger Atlantis to run the Terraform init plan and apply
# The git flow automatically trigered the pull request creation, no need to call the Github API
# go
goBootAtlantis () {

  git clone https://github.com/kubermatic/kubeone ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source
  cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source
  git checkout v${KUBEONE_VERSION}
  cp -fR ./examples/terraform/aws/* ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/
  # customizing atlantis behavior for the [SSH_URI_TO_ATLANTIS_WATCHED_GIT] repo
  if [ -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/atlantis.yml ]; then rm -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/atlantis.yml; fi;
  cp $BUMBLEBEE_HOME_INSIDE_CONTAINER/atlantis.yml ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace

  cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace

  # ---
  # and we initialize the git flow on the ATLANTIC GIT REPO
  git init
  git add remote origin ${SSH_URI_TO_ATLANTIS_WATCHED_GIT}
  git flow init --defaults
  export FEATURE_ALIAS="gitboot-atlantis"
  export COMMIT_MESSAGE="booting Atlantis from $(hostname) using [${SSH_URI_TO_ATLANTIS_WATCHED_GIT}]"

  git push -u origin --all
  git flow feature start $FEATURE_ALIAS
  git add --all & git commit -m "$COMMIT_MESSAGE" && git push -u origin HEAD
  git flow feature finish $FEATURE_ALIAS && git push -u origin HEAD
  git flow release start 0.0.0
  # Warning: It's okay not to sign my release for a demo env. It is not on any prod. env..
  git flow release finish 0.0.0 && git push -u origin --all && git push -u origin --tags
  # (I really need it signed, so i'll also need to generate a GPG Key and add to my github user settings)
  # git flow release finish -s 0.0.0 && git push -u origin --all

}
goBootAtlantis
