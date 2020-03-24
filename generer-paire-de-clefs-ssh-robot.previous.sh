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


export BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH="$WHERE_TO_CREATE_RSA_KEY_PAIR/${BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME}"
export BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH="${BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH}.pub"

# BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH=BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH_JINJA2_VAR
# BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH=BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH_JINJA2_VAR

export PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE=""
# Une [passphrase] non-vide fait échouer l'auth. [gitlab.com]
# parce que l'ajout d'unbe passphrase , implique que le fichier clef "id_rsa" est crypté
# Il faudrait donc :
# -> décrypter la clef SSH publique
# -> l'ajouter ddecryptée au compte gitlab.
#

export LE_COMMENTAIRE_DE_CLEF="[$ROBOTS_ID]-bot@[workstation]-$(hostname)"

ssh-keygen -C $LE_COMMENTAIRE_DE_CLEF -t rsa -b 4096 -f $BUMBLEBEE_SSH_PRIVATE_KEY_FULLPATH -q -P "$PEGASUS_DEFAULT_PRIVATE_KEY_PASSPHRASE"

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

echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH avant ajout de la clef ssh : "
ls -allh $WHERE_TO_CREATE_RSA_KEY_PAIR

curl --header "PRIVATE-TOKEN: ${ACCESS_TOKEN}" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .

# -----------------------------------------------------------------------------------------
# -- Now Adding public SSH Key to the Gitlab User Account, using the Gitlab API TOKEN

export THATS_THE_PUB_KEY=$(cat $BUMBLEBEE_SSH_PUBLIC_KEY_FULLPATH)

echo "[${HORODATAGE}] - Ajout de la clef SSH au compte GITLAB de  : "
export PAYLOAD="{ \"title\": \"clef_SSH_bot_${ROBOTS_ID}_${RANDOM}\", \"key\": \"${THATS_THE_PUB_KEY}\" }"
curl -H "Content-Type: application/json" -H "PRIVATE-TOKEN: ${ACCESS_TOKEN}" -X POST --data "$PAYLOAD" "https://${PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME}/api/v4/user/keys" | jq .



echo "$PEGASUS_PSONE $PEGASUS_OPS_ALIAS Liste des clefs SSH APRES ajout de la clef ssh : "
curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" -X GET "https://$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME/api/v4/user/keys" | jq .
