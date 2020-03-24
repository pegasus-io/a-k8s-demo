#!/bin/bash



#
# Le but de ce script, est de remplacer la logique des robots qui sera implémentée plus tard.
#
# Après ce script, on aura la paire de clefs disponible dans le répertoire spécicifié en entréé
#



export WHERE_TO_CREATE_RSA_KEY_PAIR=$1
export ROBOTS_ID=$2

function Usage () {
  echo " "
  echo "The [$0] script should be used with two mandatory arguments : "
  echo " [$0] \$FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR \$ROBOTS_ID"
  echo " "
  echo " Where : "
  echo "    FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR    is an existing folder path "
  echo "    ROBOTS_ID is the bumblebee id of an existing Robot"
  echo " "
  echo " Arguments You provided to [$0]: "
  echo " "
  echo "    FOLDER_WHERE_TO_CREATE_RSA_KEY_PAIR    WHERE_TO_CREATE_RSA_KEY_PAIR=[$WHERE_TO_CREATE_RSA_KEY_PAIR] "
  echo "    ROBOTS_ID                              ROBOTS_ID=[$ROBOTS_ID] "
  echo " "
}

if ! [ -d "$WHERE_TO_CREATE_RSA_KEY_PAIR" ]; then
  Usage && exit 1
fi;

if [ "x$WHERE_TO_CREATE_RSA_KEY_PAIR" == "x" ]; then
  Usage && exit 1
fi;

if [ "x$ROBOTS_ID" == "x" ]; then
  Usage && exit 1
fi;

export PRIVATE_KEY_FULLPATH=$WHERE_TO_CREATE_RSA_KEY_PAIR/cresh-bot-${ROBOTS_ID}-id_rsa

export PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
# Une [passphrase] non-vide fait échouer l'auth. [gitlab.com]
# parce que l'ajout d'unbe passphrase , implique que le fichier clef "id_rsa" est crypté
# Il faudrait donc :
# -> décrypter la clef SSH publique
# -> l'ajouter ddecryptée au compte gitlab.
#
export LE_COMMENTAIRE_DE_CLEF="[$ROBOTS_ID]-bumblebee@[workstation]-$(hostname)"
export LE_COMMENTAIRE_DE_CLEF="[$ROBOTS_ID]-bumblebee@[$PIPELINE_EXECUTION_ID]"

ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $PRIVATE_KEY_FULLPATH -q -P "$PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

ls -allh $WHERE_TO_CREATE_RSA_KEY_PAIR

sleep 3s




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


# --- #
# export PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=gitlab.com
# TODO security : access to ${BUMBLEBEE_GITLAB_SECRET_FILE}  is restricted to aws linux user group, to which belongs beeio
# --- #
export GITLAB_ACCESS_TOKEN=$(cat ${BUMBLEBEE_GITLAB_SECRET_FILE})

export ACCESS_TOKEN=$GITLAB_ACCESS_TOKEN

# export ACCESS_TOKEN=qPb4xYwfiExRu-uGk9Bv

echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH avant ajout de la clef pegasus : "
ls -allh $WHERE_TO_CREATE_RSA_KEY_PAIR

curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .


# -- Now Adding Pegasus SSH Key to the User, using the TOKEN
# export THAS_THE_PUB_KEY=$(cat ~/.ssh/id_rsa.pub)
export THAS_THE_PUB_KEY=$(cat "$PRIVATE_KEY_FULLPATH".pub )

echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Ajout de la clef SSH avant ajout de la clef pegasus : "
export PAYLOAD="{ \"title\": \"clef_SSH_PEGASUS${RANDOM}\", \"key\": \"$THAS_THE_PUB_KEY\" }"
curl -H "Content-Type: application/json" -H "PRIVATE-TOKEN: $ACCESS_TOKEN" -X POST --data "$PAYLOAD" "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .






echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH APRES ajout de la clef pegasus : "
curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .


# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$  AJOUT DE LA CLEF SSH AUX CLEFS SSH
# $$$$$$$$$$  DU COMPTE UTILISATEUR ROBOT SUR GITHUB.COM
# $$$$$$$$$$  SE FAIT AVEC L'USAGE DE
# $$$$$$$$$$  l'ACCESS TOKEN [GITHUB API v3]
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#
# https://developer.github.com/v3/users/keys/#list-your-public-keys
# https://stackoverflow.com/questions/16672507/how-to-add-ssh-keys-via-githubs-v3-api
# https://developer.github.com/v3/#authentication
# https://developer.github.com/apps/building-oauth-apps/
# --------------------------------------------------
# cf. documentation/github/README.md#authentication
# --------------------------------------------------
# --------------------------------------------------
# -- Auth to Github API using TOKENS
# --
# curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com
# --
export GITHUB_PERSONAL_ACCESS_TOKEN=38b906742101991cdbf1e61f7b59df670230b772
export GITHUB_PERSONAL_ACCESS_TOKEN=38b906742101991cdbf1e61f7b59df670230b772
export GITHUB_PERSONAL_ACCESS_TOKEN=38b906742101991cdbf1e61f7b59df670230b772

# - Just checks if Github recognizes me :
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" https://api.github.com/user
# - Now listing current public SSH Keys :
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" https://api.github.com/user/keys  | jq '.[] .title'


# - Now adding desired public key to my Github user account for my bumblebee robot

export PUBLIC_SSH_KEY_VALUE_TO_ADD=$(cat $BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH)

echo " "
echo " ------------------------------------------------------------------------------------ "
echo "    vérification , avant appel [Github API v3] de PUBLIC_SSH_KEY_VALUE_TO_ADD :  "
echo " ------------------------------------------------------------------------------------ "
echo "       [$PUBLIC_SSH_KEY_VALUE_TO_ADD] "
echo " ------------------------------------------------------------------------------------ "
echo " "



touch github.api-payload.json
rm github.api-payload.json
echo "{" >> github.api-payload.json
echo "  \"title\": \"bumblebee@jblass3ll3.world.pipeline\"," >> github.api-payload.json
echo "  \"key\": \"$(cat $BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH)\"" >> github.api-payload.json
echo "}" >> github.api-payload.json

touch ./returned-json.json
rm ./returned-json.json
curl -X POST -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" --data @github.api-payload.json https://api.github.com/user/keys >> returned-json.json


# export ADDED_SSH_KEY_GITHUB_API_V3_KEY_ID=39871898
export ADDED_SSH_KEY_GITHUB_API_V3_KEY_ID=$(cat returned-json.json | jq '.id')

# - Now listing back the newly added public SSH Key :
echo "Successfulluy Added SSH key : "
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" https://api.github.com/user/keys/${ADDED_SSH_KEY_GITHUB_API_V3_KEY_ID}

# - Finally listing again all current public SSH Keys :
curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" https://api.github.com/user/keys  | jq '.[] .title'
