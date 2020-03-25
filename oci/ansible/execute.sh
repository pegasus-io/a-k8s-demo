#!/bin/bash

export GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND
# export DEPLOYMENT_TARGET_SERVICE_ID=website_local_deploy
export DEPLOYMENT_TARGET_SERVICE_ID=$DEPLOYMENT_TARGET_SERVICE_ID

chmod +x ./init-iaac.sh
./init-iaac.sh


echo "avant git clone ansible playbook : BUMBLEBEE_GIT_SSH_COMMAND=[$BUMBLEBEE_GIT_SSH_COMMAND]"
echo "avant git clone ansible playbook : GIT_SSH_COMMAND=[$GIT_SSH_COMMAND]"
echo "avant git clone ansible playbook : DEPLOYMENT_TARGET_SERVICE_ID=[$DEPLOYMENT_TARGET_SERVICE_ID]"

mkdir -p $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER

echo " Vérification commande executee : "
echo " [[  git clone "$SSH_URI_TO_ANSIBLE_PLAYBOOK" $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER/]] "
echo ""

echo ""
echo " Vérification [avant git clone GIT_SSH_COMMAND=[$GIT_SSH_COMMAND]]  "
echo ""

echo " Vérification chemin clé privée [$(echo $GIT_SSH_COMMAND | awk '{print $4}')] "
chown -R root:root $BUMBLEBEE_HOME_INSIDE_CONTAINER
ls -allh $(echo $GIT_SSH_COMMAND | awk '{print $4}')

echo ""
echo " Vérification encore [ssh -Tvvvai clefprivee git@gitlab.com] : "
echo ""
ssh -Tvvvai $(echo $GIT_SSH_COMMAND | awk '{print $4}') git@gitlab.com

echo ""
echo " Vérification valeur clé publique : "
echo ""
cat $(echo $GIT_SSH_COMMAND | awk '{print $4}').pub
echo ""

echo ""
echo " Vérification valeur clé privée : "
echo ""
cat $(echo $GIT_SSH_COMMAND | awk '{print $4}')
echo ""

git clone "$SSH_URI_TO_ANSIBLE_PLAYBOOK" $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER/

cd $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER

echo ""
echo " Vérification du contenu du workspace [$BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER] : "
echo ""

ls -allh $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER
git status

ansible --version

cd $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER


echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++ ANSIBLE / BUMBLEBEE TEST CONNECTIVITE SSH ++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "

ansible -i pipeline.inventory ciblesdeploiements -m ping


echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++             ANSIBLE PLAYBOOK ENV.      ++T++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "
echo " ++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++T++ "

export ANSIBLE_KEEP_REMOTE_FILES=1
export ANSIBLE_STDOUT_CALLBACK=debug
echo ""
echo " [Now we (don't) execute (yet) ansible playbook] "
echo ""
# ansible-playbook -vvv -C playbook.yml -i pipeline.inventory

ls -allh .
cat playbook.yml

echo ""
echo " [Now let's IAAC our Ansible Playbook!]"
echo ""
exit 0
