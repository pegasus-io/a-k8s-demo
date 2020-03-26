#/bin/bash


echo "Remember : Kubectl must be installed where you wnat to install Helm"
# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/hashicorp/terraform
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terraform/terraform.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
export HELM_VERSION=${HELM_VERSION:-'2.16.4'}
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
export HELM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI="https://releases.hashicorp.com/terraform/${HELM_VERSION}/terraform_${HELM_VERSION}_SHA256SUMS.sig"
# HASHICORP_PGP_SIGNING_KEY => to verify [HELM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI]
# see https://www.hashicorp.com/security.html#secure-communications to find again the key its fingerprint and doc on how to automate retreiving key.
export HASHICORP_PGP_SIGNING_KEY=hashicorp.pgp.key
curl https://keybase.io/hashicorp/pgp_keys.asc -o ${HASHICORP_PGP_SIGNING_KEY}


echo '---------------------------------------------------------------'
echo ' Commandes GPG dans le conteneur kubeone#./install-terraform.sh'
echo "----------------------- [$(pwd)] "
echo '---------------------------------------------------------------'
ls -allh .
ls -allh ./${HASHICORP_PGP_SIGNING_KEY}
echo '---------------------------------------------------------------'

# TODO : générer une clef ?
echo '---------------------------------------------------------------'
echo '--- GPG FULL GENERATE KEY :  '
echo '---------------------------------------------------------------'
# gpg --full-generate-key
gpg --list-keys
echo '---------------------------------------------------------------'

# curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import
gpg --batch --import ./${HASHICORP_PGP_SIGNING_KEY}
cat ./${HASHICORP_PGP_SIGNING_KEY}
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
for fpr in $(gpg --list-keys --with-colons  | awk -F: '/fpr:/ {print $10}' | sort -u); do  echo -e "5\ny\n" |  gpg --batch --command-fd 0 --expert --edit-key $fpr trust; done

gpg --list-keys
# exit 99
# Non, il faut générer une seule et unique fois une seule clef GPG





checkIntegrityUsingTerraformChecksums () {
  echo '--------------------------------------------------------'
  echo '---- VERIF CLEF TRUST ULTIMATE HASHICORP : '
  echo '--------------------------------------------------------'
  gpg --list-keys
  echo '--------------------------------------------------------'
  curl -LO "${HELM_CHECKSUMS_FILE_DWLD_URI}"
  curl -LO "${HELM_CHECKSUMS_FILE_SIGNATURE_DWLD_URI}"
  gpg --verify ./terraform_${HELM_VERSION}_SHA256SUMS.sig ./terraform_${HELM_VERSION}_SHA256SUMS
  if [ "$?" == "0" ]; then
    echo "Successfully checked trusted HashiCorp signature of the downloaded checksum file [./terraform_${HELM_VERSION}_SHA256SUMS]"
    echo "Proceeding installation"
  else
    echo "HashiCorp signature check  of the downloaded checksum file [./terraform_${HELM_VERSION}_SHA256SUMS] failed."
    echo "check yourself the Hashicorp signature running the following command : "
    echo "   gpg --verify $(pwd)/terraform_${HELM_VERSION}_SHA256SUMS.sig $(pwd)/terraform_${HELM_VERSION}_SHA256SUMS"
    exit 3
  fi;
  cat terraform_${HELM_VERSION}_SHA256SUMS | grep ${HELM_OS} | grep ${HELM_CPU_ARCH} | tee ./terraform.integrity.checksum
  echo "------------------------------------------------------------------------"
  echo " [$0#checkIntegrityUsingTerraformChecksums ()] Contenu de [./terraform_${HELM_VERSION}_SHA256SUMS]   "
  echo "------------------------------------------------------------------------"
  cat ./terraform_${HELM_VERSION}_SHA256SUMS
  echo "------------------------------------------------------------------------"
  sha256sum -c ./terraform.integrity.checksum
  if [ "$?" == "0" ]; then
    echo "Successfully checked integrity of the downloaded terraform version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
    echo "Proceeding installation"
  else
    echo "Integrity check failed for the downloaded terraform version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
    echo "check yourself the integrity breach running the following command : "
    echo "   zip -T $(pwd)/terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip"
    exit 5
  fi;
}

# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export HELM_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${HELM_VERSION}
echo " ENV CHECK - HELM_INTALLATION_HOME=[${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${HELM_VERSION}]"
# ---
# Downloading Terraform executable

curl -LO "${HELM_PKG_DWLD_URI}"

ls -allh

installTerraform () {
  # TODO create terraform user group, and give ownership
  groupadd terraform
  # Adding
  usermod -aG terraform ${BUMBLEBEE_LX_USERNAME}
  mkdir -p ${HELM_INSTALLATION_HOME}/
  unzip ./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip -d ${HELM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  echo "Le contenu de [HELM_INSTALLATION_HOME=[${HELM_INSTALLATION_HOME}]]"
  echo " juste après le dezippe : "
  echo '-----------------------------------------------------------------------'
  ls -allh ${HELM_INSTALLATION_HOME}/
  echo '-----------------------------------------------------------------------'
  ln -s ${HELM_INSTALLATION_HOME}/terraform /usr/local/bin/terraform
}

# installTerraform
# terraform --version

# chmod a+rwx ./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip
echo ''
echo " Je suis ici [$(pwd)] et les fichiers présents sont : "
echo '------------------------------------------------------------'
ls -allh .
echo '------------------------------------------------------------'
echo " y a til [./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip] ?"
echo '------------------------------------------------------------'
echo " test d'existence de [./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip] : "
echo '------------------------------------------------------------'
ls -allh ./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip
echo '------------------------------------------------------------'
echo " execution de [zip -T ./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip] : "
echo '------------------------------------------------------------'
echo ''
# zip -T /go/terraform_0.12.24_linux_amd64.zip
# zip -T ./terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip


if [ "$?" == "0" ]; then
  # echo "Successfully checked integrity of the downloaded terraform version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "Skipped checking integrity of the downloaded terraform version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "Proceeding installation"
  checkIntegrityUsingTerraformChecksums
  installTerraform
else
  echo "Integrity check failed for the downloaded terraform version ${HELM_VERSION} package for ${HELM_OS} OS on ${HELM_CPU_ARCH} cpu"
  echo "check yourself the integrity breach running the following command : "
  echo "   zip -T $(pwd)/terraform_${HELM_VERSION}_${HELM_OS}_${HELM_CPU_ARCH}.zip"
  exit 3
fi;

terraform --version
