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

export TERRAGRUNT_PKG_DWLD_URI="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH}"



# ---
# That's where we 'll install Kubeone on the nix system' filesystem
export TERRAGRUNT_INTALLATION_HOME=${TERRAGRUNT_INTALLATION_HOME:-"$BUMBLEBEE_HOME_INSIDE_CONTAINER/"}
# ---
# Downloading KubeOne executable

curl -LO "$TERRAGRUNT_PKG_DWLD_URI"

unzip ./kubeone_${TERRAGRUNT_VERSION}_${TERRAGRUNT_OS}_${TERRAGRUNT_CPUARCH}.zip -d $TERRAGRUNT_INSTALLATION_HOME
