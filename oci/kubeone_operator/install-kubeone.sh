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
export KUBEONE_CPU_ARCH=amd64

export KUBEONE_PKG_DWLD_URI="https://github.com/kubermatic/kubeone/releases/download/v${KUBEONE_VERSION}/kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPU_ARCH}.zip"

# ---
# That's where we 'll install Kubeone on the nix system' filesystem
export KUBEONE_INSTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/installation/${KUBEONE_VERSION}

# ---
# Downloading KubeOne officially distributed package : a zip
#
curl -LO ${KBONE_PKG_DWNLD_URI}

echo "------------------------------------------------------------"
echo "presence of [./kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPU_ARCH}.zip] : "
echo "------------------------------------------------------------"
ls -allh kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPU_ARCH}.zip
echo "------------------------------------------------------------"

export KUBEONE_CHKSUMS_DWNLD_URI="https://github.com/kubermatic/kubeone/releases/download/v${KUBEONE_VERSION}/kubeone_${KUBEONE_VERSION}_checksums.txt"

curl -LO ${KUBEONE_CHKSUMS_DWNLD_URI}

echo "------------------------------------------------------------"
echo "content of [cat ./kubeone_${KUBEONE_VERSION}_checksums.txt] : "
echo "------------------------------------------------------------"
cat kubeone_${KUBEONE_VERSION}_checksums.txt
echo "------------------------------------------------------------"

cat kubeone_${KUBEONE_VERSION}_checksums.txt | grep ${KUBEONE_OS} | grep ${KUBEONE_CPU_ARCH} | tee ./kubeone_checksums.txt

echo "------------------------------------------------------------"
echo "content of [cat ./kubeone_checksums.txt] : "
echo "------------------------------------------------------------"
cat ./kubeone_checksums.txt
echo "------------------------------------------------------------"


sha256sum -c ./kubeone_checksums.txt
if [ "$?" == "0" ]; then
  echo "Successfully checked integrity of the downloaded kubeone version ${KUBEONE_VERSION} package for ${KUBEONE_OS} OS on ${KUBEONE_CPU_ARCH} cpu"
  echo "Proceeding installation"
  unzip -d kubeone_${KUBEONE_VERSION}_${KUBEONE_OS}_${KUBEONE_CPU_ARCH}.zip ${KUBEONE_INSTALLATION_HOME}/
  ln -s ${KUBEONE_INSTALLATION_HOME}/kubeone /usr/local/bin/kubeone
else
  echo "Integrity check failed for the downloaded kubeone version ${KUBEONE_VERSION} package for ${KUBEONE_OS} OS on ${KUBEONE_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   cd ${WORKDIR} && sha256sum -c sha256sum -c ./kubeone_checksums.txt"
  exit 3
fi;
