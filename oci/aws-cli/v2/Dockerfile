FROM debian:9.12-slim
# FROM ubuntu:20.04
# FROM alpine:3.11.3
# can't install aws cli v2 on alpine by now (march 2020) :
# https://github.com/aws/aws-cli/issues/4685#issuecomment-556436861
# basically reason is the aws cli binary distrobution for linux, is
# compiled for some linux target OS, but not others. It shoudl be ok on debian or ubuntu

LABEL maintainer="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL author="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL build="0.0.0.0.0.0.0.0"
LABEL commitid="0.0.0.0.0.0.0.0"
LABEL daymood="firefox https://www.youtube.com/watch?v=fBM3nb-3iFs"

RUN apt-get update -y &&  apt-get install -y curl jq unzip vim

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION "us-east-1"

ARG AWSCLI_HOME=/aws
ENV AWSCLI_HOME=${AWSCLI_HOME}

ARG AWSCLI_PLAYGROUND=${AWSCLI_HOME}/playground
ENV AWSCLI_PLAYGROUND=${AWSCLI_PLAYGROUND}

RUN mkdir -p $AWSCLI_PLAYGROUND

ARG OPERATOR_UID=${OPERATOR_UID}
ARG OPERATOR_GID=${OPERATOR_GID}

ARG BUMBLEBEE_USER=beeio
ARG BUMBLEBEE_UID=${OPERATOR_UID}
ARG BUMBLEBEE_GID=${OPERATOR_GID}

ENV BUMBLEBEE_USER=${BUMBLEBEE_USER}
ENV BUMBLEBEE_UID=${BUMBLEBEE_UID}
ENV BUMBLEBEE_GID=${BUMBLEBEE_GID}

ENV USER=${BUMBLEBEE_USER}
ENV UID=${BUMBLEBEE_UID}
ENV GID=${BUMBLEBEE_GID}

RUN groupadd -g ${BUMBLEBEE_GID} bumblebee
RUN adduser \
    --disabled-password \
    --gecos "" \
    # --home "$(pwd)" \
    --ingroup "${BUMBLEBEE_GID}" \
    # --no-create-home \
    --uid "$BUMBLEBEE_UID" \
    "$BUMBLEBEE_USER"

# RUN export GRPNAME=$(getent group ${BUMBLEBEE_GID} | awk -F ':' '{print $1}') && usermod -aG ${GRPNAME} ${BUMBLEBEE_USER}
RUN chown ${BUMBLEBEE_USER}:${BUMBLEBEE_USER} -R ${AWSCLI_HOME}

COPY install.aws-cli-v2.sh ${AWSCLI_HOME}
COPY create-aws-ec2-keypair.sh ${AWSCLI_HOME}
COPY healthcheck.sh ${AWSCLI_HOME}

RUN chmod +x ${AWSCLI_HOME}/*.sh
WORKDIR /aws
USER root
RUN ${AWSCLI_HOME}/install.aws-cli-v2.sh
# since https://github.com/aws/aws-cli/issues/2690
# ENV AWS_CA_BUNDLE=/etc/ssl/certs/cacert.pem
ENV AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# since https://github.com/aws/aws-cli/issues/5038#issuecomment-595892997
ENV AWS_PAGER=""
# where well map the creds
RUN mkdir -p ~/.aws/
RUN mkdir -p ${AWSCLI_HOME}/.secrets
RUN chown -R ${BUMBLEBEE_USER}:${BUMBLEBEE_USER} ${AWSCLI_HOME}/
RUN chown -R ${BUMBLEBEE_USER}:${BUMBLEBEE_USER} ${AWSCLI_HOME}/.secrets
RUN chown -R ${BUMBLEBEE_USER}:${BUMBLEBEE_USER} /aws/.secrets
USER ${BUMBLEBEE_USER}
VOLUME /aws/.secrets

WORKDIR /aws/playground

ENTRYPOINT [ "/aws/create-aws-ec2-keypair.sh" ]
CMD [ "/bin/bash" ]
