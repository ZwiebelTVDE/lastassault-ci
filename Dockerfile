#autor ZwiebelTVDE

FROM node:alpine

MAINTAINER ZwiebelTVDE

ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

WORKDIR $APP_DIR
#EXPOSE 4200

RUN apt update && apt rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
