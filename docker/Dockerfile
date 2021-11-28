# Workspace dev.nodejs
# Update the VARIANT arg in docker-compose.yml to pick a Node version: 10, 12, 14, 16
ARG VARIANT=16
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

# Install MongoDB command line tools
ARG MONGO_TOOLS_VERSION=4.2
RUN curl -sSL "https://www.mongodb.org/static/pgp/server-${MONGO_TOOLS_VERSION}.asc" | (OUT=$(apt-key add - 2>&1) || echo $OUT) \
    && echo "deb http://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/${MONGO_TOOLS_VERSION} main" | tee /etc/apt/sources.list.d/mongodb-org-${MONGO_TOOLS_VERSION}.list \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mongodb-org-tools mongodb-org-shell \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Update args in docker-compose.yaml to set the UID/GID of the "node" user.
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then groupmod --gid $USER_GID node && usermod --uid $USER_UID --gid $USER_GID node; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends htop wget curl less iputils-ping dnsutils telnet docker.io docker-compose python3-pip python3 python3-setuptools python3-wheel
RUN usermod -aG docker node

# Install latest Code Server
ENV CONFIG_DIR=/home/node/.code-server
RUN mkdir -p $CONFIG_DIR && ln -s $CONFIG_DIR /config && chown node:node -R $CONFIG_DIR /config
RUN curl -fsSL https://code-server.dev/install.sh > ./install-code-server.sh && sh ./install-code-server.sh

#ARG EXTRA_NODE_VERSION=14
#RUN su node -c "source /usr/local/share/nvm/nvm.sh && nvm install ${EXTRA_NODE_VERSION}"

# Create workspace directory
ENV WORKSPACE_DIR=/home/node/workspace
RUN mkdir -p $WORKSPACE_DIR && ln -s $WORKSPACE_DIR /workspace && chown node:node -R $WORKSPACE_DIR /workspace
WORKDIR $WORKSPACE_DIR

USER node

# NPM setup
#RUN printf "\nexport PATH=/home/node/.local/bin:\$PATH\n" >> /home/node/.bashrc && export PATH
ENV PATH=/home/node/bin:/home/node/.local/bin:/home/node/.npm-global/bin:$PATH
RUN export PATH=$PATH
RUN mkdir /home/node/.npm-global && \
    npm config set prefix '/home/node/.npm-global' && \
    npm install -g @waves/surfboard cross-env webpack webpack-cli typescript ts-node http-server license-checker ipfs-car

#Install ipfs-publish
RUN bash --rcfile /home/node/.bashrc -c "pip3 install ipfs-publish"


RUN printf "\n\nalias ll='ls -hlF'\nalias la='ls -AhlF'\nalias l='ls -CF'\n" >> /home/node/.bashrc

# ADD Starting script
ADD ./start.sh /start.sh

EXPOSE 3000-3100
EXPOSE 8080
EXPOSE 5000
EXPOSE 24678
EXPOSE 35729
# CODE-SERVER PORT
EXPOSE 8443 

CMD ["/start.sh", "1>/proc/1/fd/1", "2>/proc/1/fd/2"]
