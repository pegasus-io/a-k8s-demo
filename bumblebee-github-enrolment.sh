#!/bin/bash



#
# Le but de ce script, est de remplacer la logique des robots qui sera implémentée plus tard.
#
# Après ce script, on aura la paire de clefs disponible dans le répertoire spécicifié en entréé
#


export ROBOTS_ID=$1

function Usage () {
  echo " "
  echo "The [$0] script should be used with two mandatory arguments : "
  echo " [$0] \$ROBOTS_ID"
  echo " "
  echo " Where : "
  echo "    ROBOTS_ID is the bumblebee id of an existing Robot"
  echo " "
  echo " Arguments You provided to [$0]: "
  echo " "
  echo "    ROBOTS_ID                              ROBOTS_ID=[$ROBOTS_ID] "
  echo " "
}

if [ "x$ROBOTS_ID" == "x" ]; then
  Usage && exit 1
fi;

export BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH="${BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS}/.ssh/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}"
export BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH="${BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH}.pub"

# export GITLAB_ACCESS_TOKEN=$(cat ${BUMBLEBEE_GITLAB_SECRET_FILE})

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

export PUBLIC_SSH_KEY_VALUE_TO_ADD=$(cat ${BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH})

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
