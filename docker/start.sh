#!/bin/bash

# install code server
if [ ! -f "/usr/bin/code-server" ]; then
    sudo su - node -c "curl -fsSL https://code-server.dev/install.sh | sh"
fi


if [ -n "${PASSWORD}" ] || [ -n "${HASHED_PASSWORD}" ]; then
    AUTH="password"
else
    AUTH="none"
    echo "starting with no password"
fi

if [ -z ${PROXY_DOMAIN+x} ]; then
    PROXY_DOMAIN_ARG=""
else
    PROXY_DOMAIN_ARG="--proxy-domain=${PROXY_DOMAIN}"
fi
echo "Setting workspace ->"${WORKSPACE_DIR}
sudo su - node -c "/usr/bin/code-server \
            --config /config/config.yaml \
            --bind-addr 0.0.0.0:8443 \
            --user-data-dir /config/data \
            --extensions-dir /config/extensions \
            --disable-telemetry \
            --auth "${AUTH}" \
            "${PROXY_DOMAIN_ARG}" \
            "${WORKSPACE_DIR}
