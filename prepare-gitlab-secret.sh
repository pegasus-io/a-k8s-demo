#!/bin/bash



#
# Le but de ce script, est de remplacer la logique des robots qui sera implémentée plus tard.
#
# Après ce script, on aura la paire de clefs disponible dans le répertoire spécicifié en entréé
#



export WHERE_TO_CREATE_GITLAB_SECRET_FILE=$1
export ROBOTS_ID=$2

function Usage () {
  echo " "
  echo "The [$0] script should be used with two mandatory arguments : "
  echo " [$0] \$FOLDER_WHERE_TO_CREATE_GITLAB_SECRET_FILE \$ROBOTS_ID"
  echo " "
  echo " Where : "
  echo "    FOLDER_WHERE_TO_CREATE_GITLAB_SECRET_FILE    is an existing folder path "
  echo "    ROBOTS_ID is the bumblebee id of an existing Robot"
  echo " "
  echo " Arguments You provided to [$0]: "
  echo " "
  echo "    FOLDER_WHERE_TO_CREATE_GITLAB_SECRET_FILE    WHERE_TO_CREATE_GITLAB_SECRET_FILE=[$WHERE_TO_CREATE_GITLAB_SECRET_FILE] "
  echo "    ROBOTS_ID                              ROBOTS_ID=[$ROBOTS_ID] "
  echo " "
}

if ! [ -d "$WHERE_TO_CREATE_GITLAB_SECRET_FILE" ]; then
  Usage && exit 1
fi;

if [ "x$WHERE_TO_CREATE_GITLAB_SECRET_FILE" == "x" ]; then
  Usage && exit 1
fi;

if [ "x$ROBOTS_ID" == "x" ]; then
  Usage && exit 1
fi;

export GITLAB_SECRET_FILE=$WHERE_TO_CREATE_GITLAB_SECRET_FILE/cresh-bot-${ROBOTS_ID}-gitlab.token

echo "------------------------------------------------------------------------"
echo " [BUMBLEBEE_GITLAB_SECRET_FILE=[${BUMBLEBEE_GITLAB_SECRET_FILE}]]"
echo " and "
echo " [BUMBLEBEE_GITLAB_SECRET_FILE=[${BUMBLEBEE_GITLAB_SECRET_FILE}]]"
echo " should be equal "
echo "------------------------------------------------------------------------"





# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  AJOUT DE LA CLEF SSH AUX CLEFS SSH
# $$$$$$$$$$  DU COMPTE UTILISATEUR ROBOT SUR GITLAB.COM
# $$$$$$$$$$  SE FAIT AVEC L'USAGE DE
# $$$$$$$$$$  l'ACCESS TOKEN [GITLAB API v4]
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

sudo apt-get install -y dialog jq

export QUESTION="Connect to your gitlab [$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME] account, \n In the Settings Menu for your gitlab [$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME] user, Search for the \"Personal Access Token\" Menu, \n from which you will be able to create a new token for your pegasus. What's the valueof yoru token? \n (Copy / paste the token value and press Enter Key) "

#
# Pas de valeur par défaut,le [2>] estlà pour faire la redirection de canal de sortie du processs (synchrone) de la commande [dialog]
#
dialog --inputbox "$QUESTION" 15 50 2> ./gitlab.access.token.reponses.pegasus


# export PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=gitlab.com
export GITLAB_ACCESS_TOKEN=$(cat ./gitlab.access.token.reponses.pegasus)
# Security (don't leave any secret on the file system, ne it in a container or a VM):
rm ./gitlab.access.token.reponses.pegasus

# export ACCESS_TOKEN=qPb4xYwfiExRu-uGk9Bv
echo "------------------------------------------------------------"
echo " [${HORODATAGE}] Test de votre token gitlab.com : "
echo "------------------------------------------------------------"
echo "Valeur du token GITLAB = [${GITLAB_ACCESS_TOKEN}]"
curl --header "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user" | jq .
echo ''
echo ''
echo ''
curl --header "PRIVATE-TOKEN: ${GITLAB_ACCESS_TOKEN}" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user" | jq '.username' > ./bot.${BUMBLEBEE_ID}.gitlab.username
echo ''
if [ "$?" == "0" ]; then
  export BUMBLEBEE_GITLAB_USERNAME=$(cat ./bot.${BUMBLEBEE_ID}.gitlab.username)
  rm ./bot.${BUMBLEBEE_ID}.gitlab.username
  echo "Hello \@{$BUMBLEBEE_GITLAB_USERNAME}"
else
  echo "The Gilab Token you provided is invalid"
fi;



# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  Now generating ${GITLAB_SECRET_FILE}
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
echo '------------------------------------------------'
echo '------------------------------------------------'
echo "Now generating ${GITLAB_SECRET_FILE}"
echo "Inside ${WHERE_TO_CREATE_GITLAB_SECRET_FILE}"
echo "Which should be inside ${BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS}"
echo '------------------------------------------------'
echo '------------------------------------------------'
# In template [oci/kubeone_operator/aws/template.credentials] :
# aws_access_key_id=AWS_ACCESS_KEY_ID_JINJA2_VAR
# aws_secret_access_key=AWS_SECRET_ACCESS_KEY_JINJA2_VAR

if [ -f ${AWS_CREDENTIALS_FILE} ]; then
  rm -f ${AWS_CREDENTIALS_FILE}
fi;

echo ${GITLAB_ACCESS_TOKEN} > ${GITLAB_SECRET_FILE}

echo '------------------------------------------------'
echo '------------------------------------------------'
echo "Now checking content of ${GITLAB_SECRET_FILE}"
echo '------------------------------------------------'
ls -allh ${GITLAB_SECRET_FILE}
cat ${GITLAB_SECRET_FILE}
echo '------------------------------------------------'

sleep 2s
