#/bin/bash

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/kubermatic/kubeone
# I privately mirror it on git@gitlab.com/second-bureau:bellerophon/k8s-aws/kubeone/kubeone.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export KUBEONE_VERSION=0.11.0
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Kubeone does not support Windows
#
export KUBEONE_OS=linux
# ---
# can be :
# => 'amd64' (mac os)
# Kubeone does not support any other CPU ARCH to my knowledge
#
export KUBEONE_CPUARCH=amd64

export KUBEONE_PKG_DWLD_URI="https://github.com/kubermatic/kubeone/releases/download/v${KUBEONE_VERSION}/kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPUARCH}.zip"

# ---
# That's where we 'll install Kubeone on the nix system' filesystem
export KUBEONE_INTALLATION_HOME=
# ---
# Downloading KubeOne executable

curl -LO "$KUBEONE_PKG_DWLD_URI"

unzip ./kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPUARCH}.zip -d $KUBEONE_INSTALLATION_HOME
