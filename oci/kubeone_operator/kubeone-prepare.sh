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
rm -f ./variables.tf
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraformation/variables.tf .
rm -f ./output.tf
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraformation/output.tf .
rm -f ./terraform.tfvars
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraformation/terraform.tfvars .


# -----------------------------------
# ssh-keygen -P "" -t rsa -b 4096 -m pem -f aws.creshkey # ne fonctionenra pas
# Ce qu'il faut faire :
# ---
#   utiliser la AWS CLI pour générer une paire de clefs,
#   AWS CLI garde la clef publique et ne nous retourne que la clef privée
# ---
# il faut donc réparer l'installation de AWS dans le conteneur.
# ---
# En attendant, j'ai créé une parie de clef, l'ai
# enregistrée sous AWS avec le nom 'creshKeyPair'
# et donc on retrouve la réf 'creshKeyPair' dans le main.tf
# ---
# https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html
# ---
# Le code de génération d'une nouvelle clef est inutilisé, il
# est laissé simplement pour des travaux ultérieurs.
# ---
aws ec2 create-key-pair --key-name creshKeyPair --query 'KeyMaterial' --output text > ./aws.creshkey.pem

echo "$(ssh-keygen -y -f ./aws.creshkey.pem) bumblebee@pegasusio.io" > ./aws.creshkey.pub
cp ./aws.creshkey.pem ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/
cp ./aws.creshkey.pub ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/
chmod 600 ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/aws.creshkey.pem
chmod 644 ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/aws.creshkey.pub

# export FUSA_PUBKEY=$(cat ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.ssh/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}.pub)
export FUSA_PUBKEY=$(cat ./aws.creshkey.pub)
echo ''
echo ''
echo "DEBUG FUSA_PUBKEY=[${FUSA_PUBKEY}]"
echo ''
sed -i "s#EC2_FUSA_SSH_AUTH_PUBKEY_JINJA2_VAR#${FUSA_PUBKEY}#g" ./terraform.tfvars
rm -f ./versions.tfvars
cp ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraformation/versions.tfvars .

echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo " Content of [$(pwd)] and [$(pwd)/terraform.tfvars] : "
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
ls -allh $(pwd)/
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
ls -allh $(pwd)/terraform.tfvars
cat $(pwd)/terraform.tfvars
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'
echo '+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+'



# echo " # --- running init in [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace] " | tee -a ./kubeone.prepare.terraform.init.logs
echo " # --- running init in [$(pwd)] " | tee -a ./kubeone.prepare.terraform.init.logs

terraform init | tee -a ./kubeone.prepare.terraform.init.logs
# and to test them in the dry run :
echo '------------------------------------------------------------------------'
echo '---  Now checking bashrc env before terraform plan '
echo '------------------------------------------------------------------------'
echo "AWS_ACCESS_KEY_ID=[${AWS_ACCESS_KEY_ID}]"
echo "AWS_SECRET_ACCESS_KEY=[${AWS_SECRET_ACCESS_KEY}]"
echo "AWS_DEFAULT_REGION=[${AWS_DEFAULT_REGION}]"
echo '------------------------------------------------------------------------'
terraform-clean-syntax .
echo " # --- running plan in [${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace] " | tee -a ./kubeone.prepare.terraform.plan.logs
terraform plan -out=k8s.cresh.provision.plan.terraplan | tee -a ./kubeone.prepare.terraform.plan.logs


# ---- FINALLY GENERATING THE KUBEONE CONFIG TO RUN KUEBONE AFTER THAT

kubeone config print > kubeone-config.yaml
kubeone config print --full > kubeone-config.full.yaml

echo '------------------------------------------------------------------------'
echo '---  Now terraforming '
echo '------------------------------------------------------------------------'
terraform apply -auto-approve || exit 33

export PUBLIC_EIP_OF_AWS_INSTANCE="$(terraform output public_elastic_ip)"
echo '------------------------------------------------------------------------'
echo "---  You can now SSH into your VM using ip address [${PUBLIC_EIP_OF_AWS_INSTANCE}] "
echo "---  Using the following commands : "
echo "---  "
echo "---  # [inside container] : "
echo "---  "
echo "---  ssh -i ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/aws.creshkey.pem ec2-user@${PUBLIC_EIP_OF_AWS_INSTANCE}"
echo "---  "
echo "---  # [outside container] : "
echo "---  "
echo "---  ssh -i ${BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS}/.aws/aws.creshkey.pem ec2-user@${PUBLIC_EIP_OF_AWS_INSTANCE}"
echo "---  "
sudo ping -c 4 ${PUBLIC_EIP_OF_AWS_INSTANCE}
sudo ping4 -c 4 ${PUBLIC_EIP_OF_AWS_INSTANCE}
echo '------------------------------------------------------------------------'
# ssh -Tvai ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets/.aws/aws.creshkey.pem ec2-user@${PUBLIC_EIP_OF_AWS_INSTANCE}
