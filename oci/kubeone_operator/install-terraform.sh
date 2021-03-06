#/bin/bash

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/hashicorp/terraform
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terraform/terraform.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export TERRAFORM_VERSION=${TERRAFORM_VERSION:-'0.12.24'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Terraform does not support Windows
#
export TERRAFORM_OS=${TERRAFORM_OS:-'linux'}
# ---
# can be :
# => 'amd64' (mac os)
# Terraform does not support any other CPU ARCH to my knowledge
#
export TERRAFORM_CPU_ARCH=${TERRAFORM_CPU_ARCH:-'amd64'}


export TERRAFORM_PKG_DWLD_URI="https://github.com/hashicorp/terraform/archive/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip"
export TERRAFORM_PKG_DWLD_URI="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip"

export TERRAFORM_CHECKSUMS_FILE_DWLD_URI="https://releases.hashicorp.com/terraform/0.12.24/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
# Signature of the TERRAFORM_CHECKSUMS_FILE_DWLD_URI, to verify the signature of the checksum file.
export TERRAFORM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS.sig"
# ---
# HASHICORP_PGP_SIGNING_KEY => to verify [TERRAFORM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI]
# see https://www.hashicorp.com/security.html#secure-communications to find again the key its fingerprint and doc on how to automate retreiving key.
# ---
# Note : This is an insecure alternative install of teraform, Because
# sometimes, hashicorp's signature is not available online, I experienced that
# with https://keybase.io/hashicorp/ :
# In which case, you get an error, and see in the logs : 'SELF-SIGNED PUBLIC KEY NOT FOUND'
# ---





checkIntegrityUsingTerraformChecksums () {
  echo '--------------------------------------------------------'
  echo "---- CHECKING HASHICORP's CHECKSUMS : "
  echo '--------------------------------------------------------'
  curl -LO "${TERRAFORM_CHECKSUMS_FILE_DWLD_URI}"
  cat terraform_${TERRAFORM_VERSION}_SHA256SUMS | grep ${TERRAFORM_OS} | grep ${TERRAFORM_CPU_ARCH} | tee ./terraform.integrity.checksum
  echo "------------------------------------------------------------------------"
  echo " [$0#checkIntegrityUsingTerraformChecksums ()] Contenu de [./terraform_${TERRAFORM_VERSION}_SHA256SUMS]   "
  echo "------------------------------------------------------------------------"
  cat ./terraform_${TERRAFORM_VERSION}_SHA256SUMS
  echo "------------------------------------------------------------------------"
  sha256sum -c ./terraform.integrity.checksum
  if [ "$?" == "0" ]; then
    echo "Successfully checked integrity of the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
    echo "Proceeding installation"
  else
    echo "Integrity check failed for the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
    echo "check yourself the integrity breach running the following command : "
    echo "   zip -T $(pwd)/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip"
    exit 5
  fi;
}

# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export TERRAFORM_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${TERRAFORM_VERSION}
echo " ENV CHECK - TERRAFORM_INTALLATION_HOME=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${TERRAFORM_VERSION}]"
# ---
# Downloading Terraform executable

curl -LO "${TERRAFORM_PKG_DWLD_URI}"

ls -allh

installTerraform () {
  # TODO create terraform user group, and give ownership
  groupadd terraform
  # Adding
  usermod -aG terraform ${BUMBLEBEE_LX_USERNAME}
  mkdir -p ${TERRAFORM_INSTALLATION_HOME}/
  unzip ./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip -d ${TERRAFORM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  echo "Le contenu de [TERRAFORM_INSTALLATION_HOME=[${TERRAFORM_INSTALLATION_HOME}]]"
  echo " juste après le dezippe : "
  echo '-----------------------------------------------------------------------'
  ls -allh ${TERRAFORM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  ln -s ${TERRAFORM_INSTALLATION_HOME}/terraform /usr/local/bin/terraform
}

# installTerraform
# terraform --version

# chmod a+rwx ./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip
echo ''
echo " Je suis ici [$(pwd)] et les fichiers présents sont : "
echo '------------------------------------------------------------'
ls -allh .
echo '------------------------------------------------------------'
echo " y a til [./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip] ?"
echo '------------------------------------------------------------'
echo " test d'existence de [./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip] : "
echo '------------------------------------------------------------'
ls -allh ./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip
echo '------------------------------------------------------------'
echo " execution de [zip -T ./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip] : "
echo '------------------------------------------------------------'
echo ''
# zip -T /go/terraform_0.12.24_linux_amd64.zip
# zip -T ./terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip


if [ "$?" == "0" ]; then
  # echo "Successfully checked integrity of the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
  echo "Skipped checking integrity of the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
  echo "Proceeding installation"
  checkIntegrityUsingTerraformChecksums
  installTerraform
else
  echo "Integrity check failed for the downloaded terraform version ${TERRAFORM_VERSION} package for ${TERRAFORM_OS} OS on ${TERRAFORM_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   zip -T $(pwd)/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPU_ARCH}.zip"
  exit 3
fi;

terraform --version
