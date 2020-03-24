#/bin/bash
#
# https://dzone.com/articles/running-ha-kubernetes-clusters-on-aws-using-kubeon
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
# -----
# Now we'll retrieve from KubeOne github repo the
# aws example terraform: fully operational, and how
# any kubeone run should start
mkdir -p ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source
git clone https://github.com/kubermatic/kubeone ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source
cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source
echo "  KUBEONE_VERSION=[$KUBEONE_VERSION]"

git checkout v${KUBEONE_VERSION}

echo '------------------------------------------------------------------------------------------------------------------------'
echo "  contenu du répertoire [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/]"
echo '------------------------------------------------------------------------------------------------------------------------'
ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/
echo '------------------------------------------------------------------------------------------------------------------------'
mkdir -p ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace
cp -fR ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/* ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/
echo ""
echo " execution de : "
echo ""
echo " cp -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/*.* ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/ "
echo ""
cp -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/*.* ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/*.* ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/

echo '------------------------------------------------------------------------------------------------------------------------'
echo "  contenu du répertoire [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace]"
echo '------------------------------------------------------------------------------------------------------------------------'
ls -allh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace
echo '------------------------------------------------------------------------------------------------------------------------'

# customizing atlantis behavior for the [SSH_URI_TO_ATLANTIS_WATCHED_GIT] repo
if [ -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/atlantis.yml ]; then rm -f ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace/atlantis.yml; fi;
cp $BUMBLEBEE_HOME_INSIDE_CONTAINER/atlantis.yml ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace

cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workpsace/
cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/
# --- #
# go get all dependencies inside the atlantis.yaml
# Not to actually use them, but to test dependency
# resolution works both reliably and as expected :
echo " test pwd=$(pwd)"
export export GOPATH=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/source/examples/terraform/aws/
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo "I have a left TODO here : [TODO : package the \${SSH_URI_TO_ATLANTIS_WATCHED_GIT} and \${SSH_URI_TO_ANSIBLE_HELM_OPERATOR} as terraform modules.]"
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
# TODO : package the ${SSH_URI_TO_ATLANTIS_WATCHED_GIT} and ${SSH_URI_TO_ANSIBLE_HELM_OPERATOR} as terraform modules.
# go get ${SSH_URI_TO_ATLANTIS_WATCHED_GIT}
# go get ${SSH_URI_TO_ANSIBLE_HELM_OPERATOR}

ls -allh .


rm -f ./main.tf
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraformation/main.tf .
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo " Content of [$(pwd)] and [$(pwd)/main.tf] : "
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
ls -allh $(pwd)/
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
cat $(pwd)/main.tf
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
ls -allh $(pwd)/main.tf
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'



echo " # --- running init in [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace] " | tee -a ./kubeone.prepare.terraform.init.logs
terraform init | tee -a ./kubeone.prepare.terraform.init.logs
# and to test them in the dry run :
echo " # --- running plan in [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace] " | tee -a ./kubeone.prepare.terraform.plan.logs
terraform plan | tee -a ./kubeone.prepare.terraform.plan.logs
