FROM alpine:3.11.3

MAINTAINER Viktor Farcic <viktor@farcic.com>

RUN apk --update add curl jq && \
    rm -rf /var/cache/apk/*

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION "us-east-1"

ARG AWSCLI_PLAYGROUND=/aws/playground
ENV AWSCLI_PLAYGROUND=$${AWSCLI_PLAYGROUND}

RUN mkdir -p $AWSCLI_PLAYGROUND

ENV BUMBLEBEE_USER=docker
ENV BUMBLEBEE_UID=12345
ENV BUMBLEBEE_GID=23456

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$BUMBLEBEE_USER" \
    --no-create-home \
    --uid "$BUMBLEBEE_UID" \
    "$BUMBLEBEE_USER"

RUN usermod -aG ${BUMBLEBEE_GID} ${BUMBLEBEE_USER}
COPY install.aws-cli-v2.sh
