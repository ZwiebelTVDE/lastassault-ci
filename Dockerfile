FROM node:lts-slim

MAINTAINER ZwiebelTVDE

ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

ENV NPM_CONFIG_LOGLEVEL=warn NG_CLI_ANALYTICS=false

ENV HOME "$USER_HOME_DIR"

WORKDIR $APP_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

RUN apt-get update && apt-get install -qqy --no-install-recommends \
    dumb-init \
    git \
    build-essential \
    python \
    procps \
    rsync \
    openssh-client \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG NG_CLI_VERSION=8.0.3
LABEL angular-cli=$NG_CLI_VERSION node=$NODE_VERSION

RUN set -xe \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && mkdir -p $APP_DIR \
    && chown $USER_ID $APP_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm install -g @angular/cli@$NG_CLI_VERSION; npm install -g yarn; chmod +x /usr/local/bin/yarn; npm cache clean --force")

USER $USER_ID