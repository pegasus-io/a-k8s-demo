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

echo "[${HORODATAGE}] - Liste des clefs SSH avant ajout de la clef ssh : "
ls -allh ${BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH}

curl --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .

# -----------------------------------------------------------------------------------------
# -- Now Adding public SSH Key to the Gitlab User Account, using the Gitlab API TOKEN

export THATS_THE_PUB_KEY=$(cat $BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH)

echo "[${HORODATAGE}] - Ajout de la clef SSH au compte GITLAB de  : "
export PAYLOAD="{ \"title\": \"clef_SSH_bot_${ROBOTS_ID}_${RANDOM}\", \"key\": \"${THATS_THE_PUB_KEY}\" }"
curl -H "Content-Type: application/json" -H "PRIVATE-TOKEN: ${ACCESS_TOKEN}" -X POST --data "$PAYLOAD" "https://${PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME}/api/v4/user/keys" | jq .



echo "[${HORODATAGE}] - Liste des clefs SSH APRES ajout de la clef ssh : "
curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .
