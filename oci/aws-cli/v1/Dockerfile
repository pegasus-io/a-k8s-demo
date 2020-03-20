FROM alpine:3.11.3

MAINTAINER Viktor Farcic <viktor@farcic.com>

RUN apk --update add curl jq && \
    rm -rf /var/cache/apk/*

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION "us-east-1"
