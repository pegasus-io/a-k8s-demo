#!/bin/bash


#
# GENERATION DE LA PAIRE DE CLEFS SSH UTILISEE PAR BUMBLEBEE dans les conteneurs :
#
# => pour faire des git clone commit and push vers le repo SSH_URI_REPO_GIT_CODE_HUGO
#
# => pour se conecter à la cible de déploiement locale : la clef publique générée est donc installée corectement dans la ible de déploiement.
#
# Il faut donc générer cette paire de clefs, puis utiliser une clef (pas celle de BUMBLEBEE, la mienne en tant qu'administrateur de ma propre machine, pour installer cette clef )
#
echo " --------------------------------------- "
echo " POINT DEBUG - contenu de [BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS=[${BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS}]] : "
echo " --------------------------------------- "
ls -allh $BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS
echo " --------------------------------------- "

mkdir -p $BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS/.ssh
# sudo chown -R $LOCAL_DEPLOYMENT_TARGET_BUMBLEBEE_USERNAME:$LOCAL_DEPLOYMENT_TARGET_BUMBLEBEE_USERNAME $LOCAL_DEPLOYMENT_TARGET_DOCKER_COMPOSE_HOME 2>&1 |tee -a bee.pipeline.load.logs

echo " --------------------------------------- "
echo " POINT DEBUG - valeur de [BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS=[$BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS]] "
echo " POINT DEBUG - valeur de [BUMBLEBEE_ID=[${BUMBLEBEE_ID}]] "
echo " POINT DEBUG - valeur de [BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS=[$BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS]] "
echo " --------------------------------------- "
echo " POINT DEBUG - contenu de [pwd=[$(pwd)]] : "
echo " --------------------------------------- "
ls -allh .
echo " --------------------------------------- "

./generer-paire-de-clefs-robot.sh $BUMBLEBEE_SECRETS_VAULT_OUTSIDE_CONTAINERS/.ssh $BUMBLEBEE_ID
