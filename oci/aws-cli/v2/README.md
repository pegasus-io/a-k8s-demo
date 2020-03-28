# AWS CLI Operator


### How to (re)create the AWS Key Pair

(for the single instance)

* like this :

```bash
docker-compose up -d --force-recreate awscli_op1 && ./wait-for-ec2-keypair.sh
```

* example output :

```bash

jbl@poste-devops-typique:~/a-k8s-demo$ docker-compose up -d --force-recreate awscli_op1 && ./wait-for-ec2-keypair.sh
WARNING: The SSH_URI_TO_GIT_REPO variable is not set. Defaulting to a blank string.
WARNING: The SSH_URI_TO_HELM_CHART variable is not set. Defaulting to a blank string.
WARNING: The SSH_URI_TO_ATLANTIS_WATCHED_GIT variable is not set. Defaulting to a blank string.
WARNING: The BUMBLEBEE_GIT_SSH_COMMAND variable is not set. Defaulting to a blank string.
WARNING: The BUMBLEBEE_HOME_INSIDE_CONTAINER variable is not set. Defaulting to a blank string.
WARNING: The AWS_ACCESS_KEY_ID variable is not set. Defaulting to a blank string.
WARNING: The AWS_SECRET_ACCESS_KEY variable is not set. Defaulting to a blank string.
Recreating awscli_bee ... done
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [starting]
 OUI VERIF [HEALTHCHECK_ANSWER=[starting]] retour UN
checking health of the [awscli_bee] container ...
Checking name of container (not empty name) [CONTAINER_TO_CHECK_NAME=awscli_bee] ...
Health of container [awscli_bee] is [healthy]
 OUI VERIF [HEALTHCHECK_ANSWER=[healthy]] retour ZERO
jbl@poste-devops-typique:~/a-k8s-demo$
```
