#/bin/bash

#
# Following official AVH instructions at
# https://github.com/petervanderdoes/gitflow-avh/wiki/Installing-on-Linux,-Unix,-etc.
# [For the stable release]
# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/hashicorp/terraform
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terraform/terraform.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.

# https://github.com/petervanderdoes/gitflow-avh/releases/tag/1.12.3
export GITFLOW_VERSION=${GITFLOW_VERSION:-'1.12.3'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Git-flow AVH does not support Windows
#
# export GITFLOW_OS=linux
# ---
# can be :
# => 'amd64' (mac os)
# Git-flow AVH does not support any other CPU ARCH to my knowledge
#
# export GITFLOW_CPUARCH=amd64

export HTTP_URI_TO_GITFLOW_AVH_GIT_REPO=https://github.com/petervanderdoes/gitflow-avh.git
export SSH_URI_TO_GITFLOW_AVH_GIT_REPO=git@github.com:petervanderdoes/gitflow-avh.git

# -- The official AVH documentation at [https://github.com/petervanderdoes/gitflow-avh/wiki/Installing-on-Linux,-Unix,-etc.]
# -- recommends to execute this single one command to install the git-flow AVH Edition :
# wget -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh && sudo bash gitflow-installer.sh install stable; rm gitflow-installer.sh
# -- But my problem here, is that using this recipe, I cannot force a fixed specific version of the git-flow AVH Edition.
# -- So Instead, I do this :
installGitFlow () {
  export GITFLOW_INTALLATION_HOME="${BUMBLEBEE_HOME_INSIDE_CONTAINER}/git-flow/installation/${GITFLOW_VERSION}"
  mkdir -p ${GITFLOW_INTALLATION_HOME}
  unzip ./${GITFLOW_VERSION}.zip -d ${GITFLOW_INTALLATION_HOME}
  # cd ${GITFLOW_INTALLATION_HOME}/contrib
  # bash gitflow-installer.sh
  ${GITFLOW_INTALLATION_HOME}/contrib/gitflow-installer.sh
  cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
  # And I don't remove any script
}

echo "implémentation non terminée" && exit 0

export GITFLOW_PKG_DWLD_URI="https://github.com/petervanderdoes/gitflow-avh/archive/${GITFLOW_VERSION}.zip"

# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export GITFLOW_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/git-flow/installation/${GITFLOW_VERSION}
echo " ENV CHECK - GITFLOW_INTALLATION_HOME=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}/git-flow/installation/${GITFLOW_VERSION}]"
# ---
# Downloading git flow executable

curl -LO "$GITFLOW_PKG_DWLD_URI"

zip -T ./${GITFLOW_VERSION}.zip

if [ "$?" == "0" ]; then
  echo "Successfully checked integrity of the downloaded git-flow package version ${GITFLOW_VERSION} package for ${GITFLOW_OS} OS on ${GITFLOW_CPU_ARCH} cpu"
  echo "Proceeding installation"
  installGitFlow
else
  echo "Integrity check failed for the downloaded git-flow package version ${GITFLOW_VERSION} package for ${GITFLOW_OS} OS on ${GITFLOW_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   zip -T $(pwd)/${GITFLOW_VERSION}.zip"
  exit 3
fi;
