#/bin/bash


echo "Remember : Kubectl must be installed where you want to install Helm"
# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/helm/helm
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/helm/helm.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export HELM_VERSION=${HELM_VERSION:-'2.16.5'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Terraform does not support Windows
#
export HELM_OS=${HELM_OS:-'linux'}
# ---
# can be :
# => 'amd64' (mac os)
# Terraform does not support any other CPU ARCH to my knowledge
#
export HELM_CPU_ARCH=${HELM_CPU_ARCH:-'amd64'}



export HELM_PKG_DWLD_URI="https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz"


export HELM_CHECKSUMS_FILE_DWLD_URI="https://get.helm.sh/helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256"
# Signature of the HELM_CHECKSUMS_FILE_DWLD_URI, to verify the signature of the checksum file.
# export HELM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI="https://releases.helm.com/helm/${HELM_VERSION}/helm_${HELM_VERSION}_SHA256SUMS.sig"
# HELM_PGP_SIGNING_KEY => to verify [HELM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI]
# see https://www.helm.com/security.html#secure-communications to find again the key its fingerprint and doc on how to automate retreiving key.
# export HELM_PGP_SIGNING_KEY=helm.pgp.key
# curl https://keybase.io/helm/pgp_keys.asc -o ${HELM_PGP_SIGNING_KEY}

# echo '---------------------------------------------------------------'
# echo '---------------------------------------------------------------'
# echo ' Commandes GPG dans le conteneur kubeone#./install-helm.sh'
# echo "----------------------- [$(pwd)] "
# echo '---------------------------------------------------------------'
# echo '---------------------------------------------------------------'
# ls -allh .
# ls -allh ./${HELM_PGP_SIGNING_KEY}
# echo '---------------------------------------------------------------'

# TODO : générer une clef ?
# echo '---------------------------------------------------------------'
# echo '--- GPG FULL GENERATE KEY :  '
# echo '---------------------------------------------------------------'
# gpg --full-generate-key
# gpg --list-keys
# echo '---------------------------------------------------------------'

# curl https://keybase.io/helm/pgp_keys.asc | gpg --import
# gpg --batch --import ./${HELM_PGP_SIGNING_KEY}
# cat ./${HELM_PGP_SIGNING_KEY}
# I need a PGP Key for this container, to
# sign HashiCorp's Key and make it a "trusted" key in
# the eyes of [gpg]
# ---
# To Sign an imported key with an utltimately
# trusted key :
#
# https://raymii.org/s/articles/GPG_noninteractive_batch_sign_trust_and_send_gnupg_keys.html
# ---
# Now silently ultimately trusting the newly added HashiCorp PGP Keys
# https://www.rzegocki.pl/blog/how-to-make-gnupg2-to-fall-in-love-with-docker/
# for fpr in $(gpg --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u); do  echo -e "5\ny\n" |  gpg --batch --command-fd 0 --expert --edit-key $fpr trust; done

# gpg --list-keys
# exit 99
# Non, il faut générer une seule et unique fois une seule clef GPG





checkIntegrityUsingHelmChecksums () {

  # cat helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256 | grep ${HELM_OS} | grep ${HELM_CPU_ARCH} | tee ./helm.integrity.checksum
  echo "helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256 $(cat helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256)" | tee ./helm.integrity.checksum
  echo "------------------------------------------------------------------------"
  echo " [$0#checkIntegrityUsingHelmChecksums ()] Contenu de [./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256]   "
  echo "------------------------------------------------------------------------"
  cat ./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz.sha256
  echo "------------------------------------------------------------------------"
  sha256sum -c ./helm.integrity.checksum
  if [ "$?" == "0" ]; then
    echo "Successfully checked integrity of the downloaded helm version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
    echo "Proceeding installation"
  else
    echo "Integrity check failed for the downloaded helm version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
    echo "check yourself the integrity breach running the following command : "
    echo "   sha256sum -c $(pwd)/helm.integrity.checksum"
    exit 5
  fi;
}

echo '-----------------------------------------------------------------------'
# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export HELM_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/helm/installation/${HELM_VERSION}
echo " ENV CHECK - HELM_INTALLATION_HOME=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}/helm/installation/${HELM_VERSION}]"
# ---
# Downloading Terraform executable
echo '-----------------------------------------------------------------------'

curl -LO "${HELM_PKG_DWLD_URI}"

curl -LO "${HELM_CHECKSUMS_FILE_DWLD_URI}"

ls -allh

installHelm () {
  # TODO create helm user group, and give ownership
  groupadd helm
  # Adding
  usermod -aG helm ${BUMBLEBEE_LX_USERNAME}
  mkdir -p ${HELM_INSTALLATION_HOME}/
  tar -zxvf ./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz -d ${HELM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  echo "Le contenu de [HELM_INSTALLATION_HOME=[${HELM_INSTALLATION_HOME}]]"
  echo " juste après le dezippe : "
  echo '-----------------------------------------------------------------------'
  ls -allh ${HELM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  sudo mv ${HELM_INSTALLATION_HOME}/helm /usr/bin/
  ln -s /usr/bin/helm /usr/local/bin/helm
}

# ----------------------------------------------------------------------------
# installHelm
# helm --version
# ----------------------------------------------------------------------------

# chmod a+rwx ./helm_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip
echo ''
echo " Je suis ici [$(pwd)] et les fichiers présents sont : "
echo '------------------------------------------------------------'
ls -allh .
echo '------------------------------------------------------------'
echo " y a til [./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz] ?"
echo '------------------------------------------------------------'
echo " test d'existence de [./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz] : "
echo '------------------------------------------------------------'
ls -allh ./helm-v${HELM_VERSION}-${HELM_OS}-${HELM_CPU_ARCH}.tar.gz
echo '------------------------------------------------------------'

# zip -T /go/helm_0.12.24_linux_amd64.zip
# zip -T ./helm_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip


if [ "$?" == "0" ]; then
  # echo "Successfully checked integrity of the downloaded helm version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "Skipped checking integrity of the downloaded helm version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "Proceeding installation"
  checkIntegrityUsingHelmChecksums
  installHelm
else
  echo "Integrity check failed for the downloaded helm version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   zip -T $(pwd)/helm_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip"
  exit 3
fi;

helm --version
