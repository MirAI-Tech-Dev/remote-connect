#!/bin/bash
if [ -f ../docker_rootless/detect_rootless.sh ]; then
    source ../docker_rootless/detect_rootless.sh
fi

if [ "$#" -eq 0 ];then
    docker exec -ti ssh-proxy-server bash
else
    docker exec -ti ssh-proxy-server "$@"
fi
