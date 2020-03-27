FROM 9.12-slim
# FROM ubuntu:20.04
# FROM alpine:3.11.3
# can't install aws cli v2 on alpine by now (march 2020) :
# https://github.com/aws/aws-cli/issues/4685#issuecomment-556436861
# basically reason is the aws cli binary distrobution for linux, is
# compiled for some linux target OS, but not others. It shoudl be ok on debian or ubuntu


MAINTAINER Jean-Baptiste Lasselle <jean.baptiste.lasselle@gmail.com>

RUN apt-get update -y &&  apt-get install -y curl jq

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION "us-east-1"

ARG AWSCLI_HOME=/aws
ENV AWSCLI_HOME=${AWSCLI_HOME}

ARG AWSCLI_PLAYGROUND=${AWSCLI_HOME}/playground
ENV AWSCLI_PLAYGROUND=${AWSCLI_PLAYGROUND}

RUN mkdir -p $AWSCLI_PLAYGROUND

ARG BUMBLEBEE_USER=docker
ARG BUMBLEBEE_UID=12345
ARG BUMBLEBEE_GID=23456

ENV BUMBLEBEE_USER=${BUMBLEBEE_USER}
ENV BUMBLEBEE_UID=${BUMBLEBEE_UID}
ENV BUMBLEBEE_GID=${BUMBLEBEE_GID}

ENV USER=${BUMBLEBEE_USER}
ENV UID=${BUMBLEBEE_UID}
ENV GID=${BUMBLEBEE_GID}


RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$BUMBLEBEE_USER" \
    --no-create-home \
    --uid "$BUMBLEBEE_UID" \
    "$BUMBLEBEE_USER"

RUN export GRPNAME=$(getent group ${BUMBLEBEE_GID} | awk -F ':' '{print $1}') && usermod -aG ${GRPNAME} ${BUMBLEBEE_USER}
RUN chown :${BUMBLEBEE_GID} -R $AWSCLI_HOME

COPY install.aws-cli-v2.sh ${AWSCLI_HOME}
RUN chmod +x ${AWSCLI_HOME}/*.sh
WORKDIR /aws
RUN ${AWSCLI_HOME}/install.aws-cli-v2.sh
USER ${BUMBLEBEE_USER}

CMD [ "/bin/bash" ]
