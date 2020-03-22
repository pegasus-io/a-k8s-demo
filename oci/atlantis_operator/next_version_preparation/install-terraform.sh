#/bin/bash

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/kubermatic/kubeone
# I privately mirror it on git@gitlab.com/second-bureau:bellerophon/k8s-aws/kubeone/kubeone.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export TERRAFORM_VERSION=0.11.0
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Kubeone does not support Windows
#
export TERRAFORM_OS=linux
# ---
# can be :
# => 'amd64' (mac os)
# Kubeone does not support any other CPU ARCH to my knowledge
#
export TERRAFORM_CPUARCH=amd64

export TERRAFORM_PKG_DWLD_URI="https://github.com/kubermatic/kubeone/releases/download/v${TERRAFORM_VERSION}/kubeone_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPUARCH}.zip"

# ---
# That's where we 'll install Kubeone on the nix system' filesystem
export TERRAFORM_INTALLATION_HOME=
# ---
# Downloading KubeOne executable

curl -LO "$TERRAFORM_PKG_DWLD_URI"

unzip ./kubeone_${TERRAFORM_VERSION}_${TERRAFORM_OS}_${TERRAFORM_CPUARCH}.zip -d $TERRAFORM_INSTALLATION_HOME
