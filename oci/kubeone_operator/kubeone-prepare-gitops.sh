#/bin/bash

# ------------------------------------------------
# this script does not execute :
# => the terraform and
# => provisioning of the k8s Cluster on AWS
#
# intead it just git clone the terraform recipe
# released with the kubeone release, and :
# => it runs terraform init and terraform plan to show you what is
# going to be terraformed on your AWS tenant
# => it initializes the git flow on the git repo watched by Atlantis
# => it ends with sending a pull request on the repo, which will trigger Atlantis to run the Terraform init plan and apply

# -----
# Now we'll retrieve from KubeOne github repo the
# aws example terraform: fully operational, and how
# any kubeone run should start

git clone https://github.com/kubermatic/kubeone ./kubeone/source
cd ./kubeone/source
git checkout v${KUBEONE_VERSION}
cp -Rf examples/terraform/aws/ ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace

cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace

# --- #
# go get all dependencies inside the atlantis.yaml
# Not to actually use them, but to test dependency
# resolution works both reliably and as expected :
go get ${SSH_URI_TO_ATLANTIS_WATCHED_GIT}
go get ${SSH_URI_TO_ANSIBLE_HELM_OPERATOR}
terraform init | tee ./kubeone.terraform.init.logs
# and to test them in the dry run :
terraform plan | tee ./kubeone.terraform.plan.logs
