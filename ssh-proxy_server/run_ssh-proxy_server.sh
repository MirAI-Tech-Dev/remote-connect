#!/bin/bash
if [ -f ../docker_rootless/detect_rootless.sh ]; then
    source ../docker_rootless/detect_rootless.sh
fi

# for dma
MAIL_CONFIG="-v /etc/dma:/etc/dma:ro"
MAIL_CONFIG="${MAIL_CONFIG} -v /etc/aliases:/etc/aliases:ro"


#RESTART=always | unless-stopped | on-failure | no
RESTART=unless-stopped
RESTART=no

ENTRY=""
# uncomment for debugging
#ENTRY="--entrypoint /init.sh"

# limits
LIMITS=""
# uncomment for limits
#LIMITS="--memory=1500m --memory-swappiness=0"

ENV_FILE=""
# uncomment to use env file
#ENV_FILE="--env-file ssh-proxy.env"

MOUNTS="-v /srv/ssh-proxy:/srv/ssh-proxy"
MOUNTS=""

PORT_IN=11111
PORT_OUT=22
PORTS="-p ${PORT_IN}:${PORT_OUT}"

# with docker-net
docker run --init -d --name="ssh-proxy-server" \
       --restart=${RESTART} ${ENTRY} \
       ${ENV_FILE} \
       ${MOUNTS} \
       ${PORTS} \
       --net=docker-net \
       --hostname=ssh-proxy \
       ssh-proxy_server:latest

