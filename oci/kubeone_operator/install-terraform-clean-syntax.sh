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

export HASHICORP_PGP_SIGNING_KEY=hashicorp.pgp.key
# curl https://keybase.io/hashicorp/pgp_keys.asc -o ${HASHICORP_PGP_SIGNING_KEY}


echo '---------------------------------------------------------------'
echo "Installation [$0]"
echo '---------------------------------------------------------------'

# ---
# That's where we 'll install Terraform on the nix system' filesystem
# export TERRAFORM_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/installation/${TERRAFORM_VERSION}
echo " ENV CHECK - TERRAFORM_LIBS_HOME devrait avoir la valeur [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform/libs/${TERRAFORM_VERSION}]"
echo " ENV CHECK - TERRAFORM_LIBS_HOME=[${TERRAFORM_LIBS_HOME}]"
# ---
# Downloading Terraform executable

# git clone https://github.com/apparentlymart/terraform-clean-syntax ${TERRAFORM_LIBS_HOME}/
mkdir -p ${TERRAFORM_LIBS_HOME}/
git clone git@gitlab.com:second-bureau/bellerophon/terraform/external/terraform-clean-syntax.git ${TERRAFORM_LIBS_HOME}/

cd ${TERRAFORM_LIBS_HOME}/
git checkout 0.0.1
go install || exit 7
go build || exit 7

terraform-clean-syntax --help
echo "--------------------------------------"
echo '[terraform-clean-syntax] is now installed. - In any '
echo 'directory SOME_DIRECTORY where you run "terraform plan", you '
echo 'can clean up you iac source files out of executing : '
echo ' terraform-clean-syntax SOME_DIRECTORY'
echo "--------------------------------------"
