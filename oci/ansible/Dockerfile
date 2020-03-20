FROM willhallonline/ansible:2.8-centos


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

# ARG TAG_MESSAGE="default BUMBLEBEE Tag mesage - Pegasus [$(whoami)] at [$(date)]."
ENV TAG_MESSAGE=$TAG_MESSAGE
ENV COMMIT_MESSAGE=$TAG_MESSAGE


# --------------------------------
# ---------- PIPELINE STEP ENV.
# --------------------------------
#

ARG BUMBLEBEE_HOME_INSIDE_CONTAINER=/ansiblebee
ENV BUMBLEBEE_HOME_INSIDE_CONTAINER=/ansiblebee

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
# --- les variables liées à ansible : le rôle / le playbook,
#     et l'inventaire ansible :
#
#         --> inventaire de la cible de déploiement sur laquelle on opère,
#         --> ou l'inventaire (réduit à une seule machine) du Docker Service Provider
# ---
# ------------------------------------------------------------------------------------------
# ARG SSH_URI_TO_ANSIBLE_PLAYBOOK
ENV SSH_URI_TO_ANSIBLE_PLAYBOOK=$SSH_URI_TO_ANSIBLE_PLAYBOOK


USER root

# -------------------
# Installing :
#
# => [git] : to be able to git clone the git repo versioning the ansible playbook.
# => [openssh-server openssh-client] : utilities to connect to deployments targets, and execute operations on them, using SSH.
# => [curl wget] : utilities to download dependencies as raw files,without any [git clone]
RUN yum update -y && yum install -y git curl wget openssh-server openssh-client


# RUN mkdir -p $BUMBLEBEE_HOME_INSIDE_CONTAINER/.secrets
RUN mkdir -p $BUMBLEBEE_WORKSPACE_INSIDE_CONTAINER

# Built-in Pipeline Step operations
COPY init-iaac.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER
COPY execute.sh $BUMBLEBEE_HOME_INSIDE_CONTAINER

RUN chmod +x $BUMBLEBEE_HOME_INSIDE_CONTAINER/*.sh

VOLUME /ansiblebee/.secrets

WORKDIR /ansiblebee

# HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/ansiblebee/pipeline-step.healthcheck.sh" ]

ENTRYPOINT ["/ansiblebee/execute.sh"]

#
# I want bash inside, not just /bin/sh, because
# this container is an interactive workspace
#
CMD ["/bin/bash"]
