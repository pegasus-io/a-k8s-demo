FROM runatlantis/atlantis:v0.11.1

FROM alpine:3.11.3


LABEL maintainer="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL author="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL build="0.0.0.0.0.0.0.0"
LABEL commitid="0.0.0.0.0.0.0.0"
LABEL daymood="firefox https://www.youtube.com/watch?v=fBM3nb-3iFs"

# AUTHOR Jean-Baptiste-lasselle


# --------------------------------
# ---------- PIPELINE ENV.
# --------------------------------

# ---
# IAAC cycle Parameters
# ---

ARG PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME
ENV PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME=$PIPELINE_GIT_SERVICE_PROVIDER_HOSTNAME


# ARG GIT_SSH_COMMAND=
ENV BUMBLEBEE_GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND
ENV GIT_SSH_COMMAND=$BUMBLEBEE_GIT_SSH_COMMAND


# ARG BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME=$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME
ENV BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME=$BUMBLEBEE_SSH_PRIVATE_KEY_FILENAME

# ARG TAG_MESSAGE="default BUMBLEBEE Tag message - Pegasus [$(whoami)] at [$(date)]."
ENV TAG_MESSAGE=$TAG_MESSAGE
ENV COMMIT_MESSAGE=$TAG_MESSAGE


# --------------------------------
# ---------- PIPELINE STEP ENV.
# --------------------------------
#

ARG BUMBLEBEE_HOME_INSIDE_CONTAINER=/kubeonebee
ENV BUMBLEBEE_HOME_INSIDE_CONTAINER=/kubeonebee


# ---
# Where my robot works for you
ARG BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace
ENV BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/workspace


# --------------------------------
# full path to a file that will be
# created (touched) iff the pipeline step
# execution completes successfully
# --------------------------------
#
ARG HEALTH_CHECK_FILE=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/bee.complete.health
ARG HEALTH_CHECK_FILE=${BUMBLEBEE_HOME_INSIDE_CONTAINER}/bee.complete.health
# --------------------------------
# This file must not exist, and
# will be created once this workers
# has checked the step completed
# successfully
RUN if [ -f ${HEALTH_CHECK_FILE} ]; then rm -f ${HEALTH_CHECK_FILE}; fi;
# ------------------------------------------------------------------------------------------
# ---
# --- Le repo git surveillé par Atlantis, dans lequel on commit les releases
#     de la recette terraform provenant du repo git KubeOne, pour aws.
#
ENV SSH_URI_TO_ATLANTIS_WATCHED_GIT=$SSH_URI_TO_ATLANTIS_WATCHED_GIT

# --- --------------------------
#  -- ATLANTIS ATLANTIS_VERSION
# --- --------------------------

# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/kubermatic/kubeone
# I privately mirror it on git@gitlab.com/second-bureau:bellerophon/k8s-aws/kubeone/kubeone.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from
# your CI/CD factory, your pipelines run faster, with more reliability.
ARG ATLANTIS_VERSION=${ATLANTIS_VERSION:-'0.11.0'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# Kubeone does not support Windows
#
ARG ATLANTIS_OS=${ATLANTIS_OS:-'linux'}
ARG ATLANTIS_CPUARCH=${ATLANTIS_CPUARCH:-'amd64'}

# ---
# Where ATLANTIS Is isntalled on the system, for
# all users in the kubeone group, the beeio user
# that executes the terraform init/plan/apply
#
ARG ATLANTIS_INSTALLATION_HOME=$BUMBLEBEE_HOME_INSIDE_CONTAINER/atlantis/installations/$ATLANTIS_VERSION


# ---
# Can be a commit hash, a branch name, or a tag (be it a release or not).
# from this git repo : https://github.com/gruntwork-io/terragrunt
# I privately mirror it on git@gitlab.com:second-bureau/bellerophon/terragrunt/terragrunt.git
# You should also reference your own private mirror of this repo, in your automation recipes
# because then you will remove any external service build time and runtime dependency from your CI/CD factory, your pipelines run faster, with more reliability.
ARG TERRAGRUNT_VERSION=${TERRAGRUNT_VERSION:-'0.23.2'}
# ---
# can be :
# => 'darwin' (mac os)
# => 'linux' (for any GNU/Linux distrib.)
# => 'windows'
#
ARG TERRAGRUNT_OS=${TERRAGRUNT_OS:-'linux'}
# ---
# can be :
# => '386'
# => 'amd64'
#
ARG TERRAGRUNT_CPUARCH=${TERRAGRUNT_CPUARCH:-'amd64'}

ARG TERRAGRUNT_INSTALLATION_HOME=$BUMBLEBEE_HOME_INSIDE_CONTAINER/terragrunt/installations/$ATLANTIS_VERSION


# TODO : create BEEIO NON-ROOT USER IN DOCKER IMAGE
# ATLANTIS Installation is done byu the root user.
# ATLANTIS, terraform and git commands are executed by
# beeio non root user, at runtime.
USER root

# -------------------
# Installing :
#
# => [git/git flow] : to be able to git flow over the SSH_URI_TO_ATLANTIS_WATCHED_GIT and git clone from the other git repos.
# => [openssh-server openssh-client] : utilities to connect to deployments targets, and execute operations on them, using SSH.
# => [curl wget] : utilities to download dependencies as raw files,without any [git clone]
RUN apk update && apk add bash curl git git-flow curl wget openssh-server openssh-client


# RUN mkdir -p $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets
RUN mkdir -p $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER

# ---------------------------------------------------------
# Built-in Pipeline Step operations
# ---------------------------------------------------------

COPY create-bee-user.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER
COPY init-iaac.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER
COPY install-atlantis.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER
COPY install-terragrunt.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER

# COPY install-terraform.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER

RUN chmod +x $BUMBLEBEE_HOME_INSIDE_CONTAINER/*.sh

# Is there an atlantis linux user group ?
# # creates an atlantis linux user group
RUN $BUMBLEBEE_HOME_INSIDE_CONTAINER/install-atlantis.sh
# # creates a terraform linux user group
# RUN $BUMBLEBEE_HOME_INSIDE_CONTAINER/install-terraform.sh

# ---------------------------------------------------------
# TODO : create BEEIO NON-ROOT USER IN DOCKER IMAGE
# ATLANTIS Installation is done by the root user.
# ATLANTIS, terraform and git commands are executed by
# beeio non root user, at runtime.
# ---------------------------------------------------------
RUN $BUMBLEBEE_HOME_INSIDE_CONTAINER/create-bee-user.sh
# [create-bee-user.sh] creates a user 'beeio' and its group, 'bumblebee' group
# So we create :
# --> the 'terragrunt' group : only those in this group will be allowed to execute the kubeone executable.
# --> Not decided yet, the 'terraform' group : only those in this group will be allowed to execute the kubeone executable.
# --> Not decided yet, the 'atlantis' group : only those in this group will be allowed to execute the kubeone executable. (unless the FROM bases this image on an Atlantis base image)
#
# And we add 'beeio' robot user to all these groups.
RUN usermod -aG beeio atlantis terraform terragrunt

RUN chown :bumblebee -R $BUMBLEBEE_HOME_INSIDE_CONTAINER

RUN # NON DANS LE SCRIPT INSTALL ATLANTIS # chown :kubeone -R $BUMBLEBEE_HOME_INSIDE_CONTAINER/kubeone
RUN # NON DANS LE SCRIPT INSTALL TERRAFORM # chown :terraform -R $BUMBLEBEE_HOME_INSIDE_CONTAINER/terraform

# ---------------------------------------------------------
VOLUME /kubeonebee/.secrets

WORKDIR /kubeonebee
# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/kubeonebee/pipeline-step.healthcheck.sh" ]

ENTRYPOINT ["/kubeonebee/install-atlantis.sh"]

#
# I want bash inside, not just /bin/sh, because
# this container is an interactive workspace
#
CMD ["/bin/bash"]
