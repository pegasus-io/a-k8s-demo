#/bin/bash

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/hashicorp/terraform
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terraform/terraform.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export TERRAFORM_VERSION=0.11.0
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Terraform does not support Windows
#
export TERRAFORM_OS=linux
# ---
# can be :
# => 'amd64' (mac os)
# Terraform does not support any other CPU ARCH to my knowledge
#
export TERRAFORM_CPUARCH=amd64


export TERRAFORM_PKG_DWLD_URI="https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip"
# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export TERRAFORM_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${TERRAFORM_VERSION}
echo " ENV CHECK - TERRAFORM_INTALLATION_HOME=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${TERRAFORM_VERSION}]"
# ---
# Downloading Terraform executable

curl -LO "$TERRAFORM_PKG_DWLD_URI"

ls -allh

installTerraform () {
  # TODO create terraform user group, and give ownership
  groupadd terraform
  # Adding
  userdmod -aG terraform ${BUMBLEBEE_LX_USERNAME}
  mkdir -p ${TERRAFORM_INSTALLATION_HOME}/
  unzip ./v${TERRAFORM_VERSION}.zip -d ${TERRAFORM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  echo "Le contenu de [TERRAFORM_INSTALLATION_HOME] juste après le dezippe : "
  echo '-----------------------------------------------------------------------'
  ls -allh ${TERRAFORM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  ln -s ${TERRAFORM_INSTALLATION_HOME}/terraform /usr/local/bin/terraform
}

installTerraform
terraform --version

chmod a+rwx ./v${TERRAFORM_VERSION}.zip
echo ''
echo " Je suis ici [$(pwd)] et les fichiers présents sont : "
echo '------------------------------------------------------------'
ls -allh .
echo '------------------------------------------------------------'
echo " y a til [./v${TERRAFORM_VERSION}.zip] ?"
echo '------------------------------------------------------------'
echo " test d'existence de [./v${TERRAFORM_VERSION}.zip] : "
echo '------------------------------------------------------------'
ls -allh ./v${TERRAFORM_VERSION}.zip
echo '------------------------------------------------------------'
echo " execution de [zip -T ./v${TERRAFORM_VERSION}.zip] : "
echo '------------------------------------------------------------'
echo ''
zip -T ./v${TERRAFORM_VERSION}.zip

if [ "$?" == "0" ]; then
  echo "Successfully checked integrity of the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
  echo "Proceeding installation"
  installTerraform
else
  echo "Integrity check failed for the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   zip -T $(pwd)/v${TERRAFORM_VERSION}.zip"
  exit 3
fi;

terraform --version

echo "implémentation non terminée" && exit 1
