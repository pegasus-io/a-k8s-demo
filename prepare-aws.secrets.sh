#!/bin/bash



#
# Le but de ce script, est de remplacer la logique des robots qui sera implémentée plus tard.
#
# Après ce script, on aura la paire de clefs disponible dans le répertoire spécicifié en entréé
#



export WHERE_TO_CREATE_AWS_CREDENTIALS_FILE=$1
export ROBOTS_ID=$2

function Usage () {
  echo " "
  echo "The [$0] script should be used with two mandatory arguments : "
  echo " [$0] \$FOLDER_WHERE_TO_CREATE_AWS_CREDENTIALS_FILE \$ROBOTS_ID"
  echo " "
  echo " Where : "
  echo "    FOLDER_WHERE_TO_CREATE_AWS_CREDENTIALS_FILE    is an existing folder path "
  echo "    ROBOTS_ID is the bumblebee id of an existing Robot"
  echo " "
  echo " Arguments You provided to [$0]: "
  echo " "
  echo "    FOLDER_WHERE_TO_CREATE_AWS_CREDENTIALS_FILE    WHERE_TO_CREATE_AWS_CREDENTIALS_FILE=[$WHERE_TO_CREATE_AWS_CREDENTIALS_FILE] "
  echo "    ROBOTS_ID                              ROBOTS_ID=[$ROBOTS_ID] "
  echo " "
}

if ! [ -d "$WHERE_TO_CREATE_AWS_CREDENTIALS_FILE" ]; then
  Usage && exit 1
fi;

if [ "x$WHERE_TO_CREATE_AWS_CREDENTIALS_FILE" == "x" ]; then
  Usage && exit 1
fi;

if [ "x$ROBOTS_ID" == "x" ]; then
  Usage && exit 1
fi;

# mapped in container to [~/.aws/credentials]
export AWS_CREDENTIALS_FILE=$WHERE_TO_CREATE_AWS_CREDENTIALS_FILE/credentials






# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  Préparation du [~/.aws/credentials]
# $$$$$$$$$$  qui sera uitilisé dans le conteneur par
# $$$$$$$$$$  TERRAFORM
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

sudo apt-get install -y dialog jq

# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  AWS_ACCESS_KEY_ID
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

export QUESTION="If you haven't done so already, create an IAM user in your AWS Account : What is his AWS ACCESS KEY ID ? \n (Copy / paste the token value and press Enter Key) "

#
# Pas de valeur par défaut,le [2>] estlà pour faire la redirection de canal de sortie du processs (synchrone) de la commande [dialog]
#
dialog --inputbox "$QUESTION" 15 50 2> ./aws_access_key_id.${BUMBLEBEE_ID}.reponses


# export PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=gitlab.com
export AWS_ACCESS_KEY_ID_ANSWER=$(cat ./aws_access_key_id.${BUMBLEBEE_ID}.reponses)
# Security (don't leave any secret on the file system, ne it in a container or a VM):
rm ./aws_access_key_id.${BUMBLEBEE_ID}.reponses

# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  AWS_SECRET_ACCESS_KEY
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


export QUESTION=" What is his AWS SECRET ACCESS KEY   ? \n (Copy / paste the token value and press Enter Key) "

#
# Pas de valeur par défaut,le [2>] estlà pour faire la redirection de canal de sortie du processs (synchrone) de la commande [dialog]
#
dialog --inputbox "$QUESTION" 15 50 2> ./aws_secret_access_key.${BUMBLEBEE_ID}.reponses


# export PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=gitlab.com
export AWS_SECRET_ACCESS_KEY_ANSWER=$(cat ./aws_secret_access_key.${BUMBLEBEE_ID}.reponses)
# Security (don't leave any secret on the file system, ne it in a container or a VM):
rm ./aws_secret_access_key.${BUMBLEBEE_ID}.reponses


# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  Now generating ${AWS_CREDENTIALS_FILE}
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo '------------------------------------------------'
echo '------------------------------------------------'
echo "Now generating ${AWS_CREDENTIALS_FILE}"
echo "Inside ${WHERE_TO_CREATE_AWS_CREDENTIALS_FILE}"
echo "Which should be inside ${BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS}"
echo '------------------------------------------------'
echo '------------------------------------------------'
# In template [oci/kubeone_operator/aws/template.credentials] :
# aws_access_key_id=AWS_ACCESS_KEY_ID_JINJA2_VAR
# aws_secret_access_key=AWS_SECRET_ACCESS_KEY_JINJA2_VAR

if [ -f ${AWS_CREDENTIALS_FILE} ]; then
  rm -f ${AWS_CREDENTIALS_FILE}
fi;
cp ./oci/kubeone_operator/aws/template.credentials ${AWS_CREDENTIALS_FILE}
echo '------------------------------------------------'
echo "copied template to [${AWS_CREDENTIALS_FILE}] : "
echo '------------------------------------------------'
ls -allh ${AWS_CREDENTIALS_FILE}
cat ${AWS_CREDENTIALS_FILE}
echo '------------------------------------------------'
sed -i "s#AWS_ACCESS_KEY_ID_JINJA2_VAR#$AWS_ACCESS_KEY_ID_ANSWER#g" ${AWS_CREDENTIALS_FILE}
sed -i "s#AWS_SECRET_ACCESS_KEY_JINJA2_VAR#$AWS_SECRET_ACCESS_KEY_ANSWER#g" ${AWS_CREDENTIALS_FILE}

echo "--------------------------------------------------- aws checking creds of [${BUMBLEBEE_ID}] robot : "
echo '------------------------------------------------'
echo "interpolated template to [${AWS_CREDENTIALS_FILE}] : "
echo '------------------------------------------------'
ls -allh ${AWS_CREDENTIALS_FILE}
cat ${AWS_CREDENTIALS_FILE}
echo '------------------------------------------------'

sleep 2s
