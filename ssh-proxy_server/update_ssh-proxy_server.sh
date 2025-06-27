#!/bin/bash
if [ -f ../docker_rootless/detect_rootless.sh ]; then
    source ../docker_rootless/detect_rootless.sh
fi

./build_image.sh
docker stop ssh-proxy-server
docker rm ssh-proxy-server

# use command to create it:
#docker network create --attachable \
#--opt "com.docker.network.bridge.name=dockervpn0" \
#--opt "com.docker.network.bridge.enable_ip_masquerade=false" \
#dockervpn0
./run_ssh-proxy_server.sh
