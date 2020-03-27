FROM alpine:3.11.3

LABEL maintainer="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL author="Jean-Baptiste-Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>"
LABEL build="0.0.0.0.0.0.0.0"
LABEL commitid="0.0.0.0.0.0.0.0"
LABEL daymood="firefox https://www.youtube.com/watch?v=fBM3nb-3iFs"


RUN apk --update add curl jq && \
    rm -rf /var/cache/apk/*

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV AWS_DEFAULT_REGION "us-east-1"
