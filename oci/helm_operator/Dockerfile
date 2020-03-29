FROM golang:1.14.1-alpine3.11
# -----------------------------------------------
# FROM alpine:3.11.3
# We need the golang env to gracefully work with terraform modules.
#

LABEL maintainer="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL author="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL build="0.0.0.0.0.0.0.0"
LABEL commitid="0.0.0.0.0.0.0.0"
LABEL daymood="firefox https://www.youtube.com/watch?v=fBM3nb-3iFs"

# AUTHOR Jean-Baptiste-lasselle


# ---------------------------------------------------
# ---------- PIPELINE ENV.
# ---------------------------------------------------

# ---
# IAAC cycle Parameters
# ---

ARG PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME
ENV PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME


# The use to create, and to use at runtime for this container
ARG BUMBLEBEE_LX_USERNAME=beeio
ENV BUMBLEBEE_LX_USERNAME=$BUMBLEBEE_LX_USERNAME

ARG BUMBLEBEE_LX_GROUPNAME=bumblebee
ENV BUMBLEBEE_LX_GROUPNAME=$BUMBLEBEE_LX_GROUPNAME

ARG OPERATOR_UID=${OPERATOR_UID}

ARG OPERATOR_GID=${OPERATOR_GID}


# ARG GIT_SSH_COMMAND=
ENV BUMBLEBEE_GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND
ENV GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND


# ARG BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME=$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME
ENV BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME=$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME

# ARG TAG_MESSAGE="default BUMBLEBEE Tag message - Pegasus [$(whoami)] at [$(date)]."
ENV TAG_MESSAGE=$TAG_MESSAGE
ENV COMMIT_MESSAGE=$TAG_MESSAGE


# ---------------------------------------------------
# ---------- PIPELINE STEP ENV.
# ---------------------------------------------------
#

ARG BUMBLEBEE_HOME_INSIDE_CONTAINER=/helmbee
ENV BUMBLEBEE_HOME_INSIDE_CONTAINER=/helmbee


# ---
# Where my robot works for you
ARG BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace
ENV BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace


# ---------------------------------------------------
# full path to a file that will be
# created (touched) iff the pipeline step
# execution completes successfully
# ---------------------------------------------------
#
ARG HEALTH_CHECK_FILE=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/bee.complete.health
ARG HEALTH_CHECK_FILE=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/bee.complete.health
# ---------------------------------------------------
# This file must not exist, and
# will be created once this workers
# has checked the step completed
# successfully
RUN if [ -f ${HEALTH_CHECK_FILE} ]; then rm -f ${HEALTH_CHECK_FILE}; fi;
# -------------------------------------------------------------------------------------------------------------
# ---
# --- Le repo git surveillé par Atlantis, dans lequel on commit les releases
#     de la recette terraform provenant du repo git KubeOne, pour aws.
#
ENV SSH_URI_TO_ATLANTIS_WATCHED_GIT=$SSH_URI_TO_ATLANTIS_WATCHED_GIT

# -------------------------------------------------------------------------------------------------------------
# ---
# --- Le repo git dans lequel on versionne le playbook ansible :
#     => Qui sera invoqué par le terraform ansible provider, suite au Terraform Apply Atlantis
#     => Qui exécutera la commande kubeone pour provisionner le cluster Kubernetes
#     => Qui exécutera le Helm Chart pour déployer l'application dans le cluster Kubernetes
#
# Le playbook sera probablement versionné sous forme de
# module terraform, afin de définir ses
# interfaces input / output, et ajouter des
# tests robot framework et ansible molecule
#
# Il sera référencé dans le 'version.go' que
# j'ajoute au repo versionnant le terraform
# kubeone, $SSH_URI_TO_ATLANTIS_WATCHED_GIT
#
# il faudra donc faire un 'go install', avant tout 'terraform init' :
# => Comment configurer Atlantis pour qu'il exécute ce go install ?  Intéressant, masi trop complexe pour arriver à l'objectif
# => À la pace, avant de faire le git commit and push de mon terraform dans le repo [$SSH_URI_TO_ATLANTIS_WATCHED_GIT], je vais exécuter le go install qui va faire le git clone du module terrraform qu'est devenu mon playbook ansible.
#
#
ENV SSH_URI_TO_ANSIBLE_HELM_OPERATOR=$SSH_URI_TO_ANSIBLE_HELM_OPERATOR
# --- --------------------------
#  -- KUBEONE HELM_VERSION
# --- --------------------------

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/kubermatic/kubeone
# I privately mirror it on git@gitlab.com/second-bureau:bellerophon/k8s-aws/kubeone/kubeone.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from
# your CI/CD factory, your pipelines run faster, with more reliability.
ARG HELM_VERSION=${HELM_VERSION:-'2.16.5'}
ENV HELM_VERSION=${HELM_VERSION:-'2.16.5'}

# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Kubeone does not support Windows
#
ARG HELM_OS=${HELM_OS:-'linux'}
ARG HELM_CPU_ARCH=${HELM_CPU_ARCH:-'amd64'}

# ---
# Where KUBEONE Is isntalled on the system, for
# all users in the kubeone group, the beeio user
# that executes the terraform init/plan/apply
#
ARG HELM_INSTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone/installation/${HELM_VERSION}

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/hashicorp/terraform
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terraform/terraform.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
ARG HELM_VERSION=${HELM_VERSION:-'0.12.24'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Terraform does not support Windows
#
ARG HELM_OS=${HELM_OS:-'linux'}
# ---
# can be :
# => 'amd64' (mac os)
# Terraform does not support any other CPU ARCH to my knowledge
#
ARG HELM_CPU_ARCH=${HELM_CPU_ARCH:-'amd64'}

ARG HELM_INSTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/helm/installation/${HELM_VERSION}


ARG GITFLOW_VERSION=000
ARG GITFLOW_INTALLATION_HOME=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/git-flow/installation/${GITFLOW_VERSION}

# TODO : create BEEIO NON-ROOT USER IN DOCKER IMAGE
# KUBEONE Installation is done byu the root user.
# KUBEONE, terraform and git commands are executed by
# beeio non root user, at runtime.
USER root

# --------------------------------------
# Installing :
#
# => [git/git flow] : to be able to git flow over the SSH_URI_TO_ATLANTIS_WATCHED_GIT and git clone from the other git repos.
# => [openssh-server openssh-client] : utilities to connect to deployments targets, and execute operations on them, using SSH.
# => [curl wget] : utilities to download dependencies as raw files,without any [git clone]
RUN apk update && apk add gnupg bash curl git wget curl wget openssh-server openssh-client
RUN mkdir -p ${BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER}

# RUN mkdir -p ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/.secrets


# ----------------------------------------------------------------------------
# Built-in Pipeline Step operations
# ----------------------------------------------------------------------------

COPY create-bee-user.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
COPY init-iaac.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}
COPY install-git-flow.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/
COPY install-helm.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/
COPY install-kubectl.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/

COPY run.sh ${BUMBLEBEE_HOME_INSIDE_CONTAINER}


RUN chmod +x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/*.sh

# ----------------------------------------------------------------------------
# TODO : create BEEIO NON-ROOT USER IN DOCKER IMAGE
# Installation is done by the root user.
# KUBEONE, terraform and git commands are executed by
# beeio non root user, at runtime.
# ----------------------------------------------------------------------------
RUN ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/create-bee-user.sh


# ---------------------------------------------------------
# Now installing the git-flow
# ---------------------------------------------------------
RUN echo "Je suis [$(whoami)]" && cd ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/ && ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/install-git-flow.sh


# ---------------------------------------------------------
# Now installing the git-flow AVH Ed.
# ---------------------------------------------------------
#
RUN ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/install-git-flow.sh

# ---------------------------------------------------------
# Now installing HELM
# ---------------------------------------------------------
# creates a kubeone linux user group
RUN ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/install-kubectl.sh
RUN ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/install-helm.sh


# [create-bee-user.sh] creates a user 'beeio' and its group, 'bumblebee' group
# So we create :
# --> the kubeone group : only those in this group will be allowed to execute the kubeone executable.
# --> the terraform group : only those in this group will be allowed to execute the kubeone executable.
# And we add 'beeio' robot user to both groups.
RUN usermod -aG helm ${BUMBLEBEE_LX_USERNAME}
RUN usermod -aG kube ${BUMBLEBEE_LX_USERNAME}

# RUN # NON DANS LE SCRIPT INSTALL KUBEONE # chown :kubeone -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/kubeone
# RUN # NON DANS LE SCRIPT INSTALL TERRAFORM # chown :terraform -R ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/terraform

# ----------------------------------------------------------------------------
VOLUME /helmbee/.secrets
# ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/beesecrets/public_elastic_ip
WORKDIR /helmbee
# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/helmbee/pipeline-step.healthcheck.sh" ]

RUN chmod a+x ${BUMBLEBEE_HOME_INSIDE_CONTAINER}/run.sh
RUN chmod a+rwx -R /helmbee/
USER ${BUMBLEBEE_LX_USERNAME}

ENTRYPOINT ["/helmbee/run.sh"]

#
# I want bash inside, not just /bin/sh, because
# this container is an interactive workspace
#
# CMD ["/bin/bash"]
