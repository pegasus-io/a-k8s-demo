#/bin/bash

#
# --> This scripts downloads the terragrunt executable binary in the docker build context
#

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/gruntwork-io/terragrunt
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terragrunt/terragrunt.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-'0.23.2'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# => 'windows'
#
export TERRAGRUNT_OS=${TERRAGRUNT_OS:-'linux'}
# ---
# can be :
# => '386'
# => 'amd64'
#
export TERRAGRUNT_CPUARCH=${TERRAGRUNT_CPUARCH:-'amd64'}

export TERRAGRUNT_EXE_DWLD_URI="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH}"
export TERRAGRUNT_CHECKSUMS_DWLD_URI="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"



# ---
# That's where we 'll install Kubeone on the nix system' filesystem

export TERRAGRUNT_INSTALLATION_HOME=${TERRAGRUNT_INSTALLATION_HOME:-"$BUMBLEBEE_HOME_INSIDE_CONTAINER/terragrunt/installations/${TERRAGRUNT_VERSION}/"}

mkdir -p $TERRAGRUNT_INSTALLATION_HOME
# ---
# Downloading Terragrunt executable
# ./terragrunt_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH}
curl -LO "$TERRAGRUNT_EXE_DWLD_URI"


curl -LO "$TERRAGRUNT_CHECKSUMS_DWLD_URI"

# ----
# Now Checking integrity of all downloads Ah les sommes de contôle
cat ./SHA256SUMS | grep ${TERRAGRUNT_OS} | grep ${TERRAGRUNT_CPUARCH} | tee ./terragrunt.v.${TERRAGRUNT_VERSION}.${TERRAGRUNT_OS}.${TERRAGRUNT_CPUARCH}.integrity.checksums
terraformCheckSumsCompromisedDwnld () {
  echo "The integrity of the downloaded Terragrunt executable is compromised."
  echo "The checksums provided in the [$(pwd)/terragrunt.v.${TERRAGRUNT_VERSION}.${TERRAGRUNT_OS}.${TERRAGRUNT_CPUARCH}.integrity.checksums] file containing : "
  echo ''
  cat ./terragrunt.v.${TERRAGRUNT_VERSION}.${TERRAGRUNT_OS}.${TERRAGRUNT_CPUARCH}.integrity.checksums
  echo ''
  echo "Proved the download to be compromised."
  echo "You can yourself check this runjing the following command in the [$(pwd)] folder : "
  echo ''
  echo "   cat ./terragrunt.v.${TERRAGRUNT_VERSION}.${TERRAGRUNT_OS}.${TERRAGRUNT_CPUARCH}.integrity.checksums "
  echo ''
  # The docker build shoudl fail here so we exit with return code different from zero
  exit 2
}
sha256sum -c ./terragrunt.v.${TERRAGRUNT_VERSION}.${TERRAGRUNT_OS}.${TERRAGRUNT_CPUARCH}.integrity.checksums || terraformCheckSumsCompromisedDwnld

cp ./terragrunt_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH} ./terragrunt
cp ./terragrunt $TERRAGRUNT_INSTALLATION_HOME && rm -f ./terragrunt && rm -f ./terragrunt_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH}


ln -s $TERRAFORM_INTALLATION_HOME/terragrunt /usr/local/bin/terragrun
