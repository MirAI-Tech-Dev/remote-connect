#!/bin/bash
CACHE_OPTS=""
if [ -e use_cache ]; then
    echo "WARN: caching enabled"
else
    CACHE_OPTS="--no-cache"
    # always pull
    #CACHE_OPTS="--pull ${CACHE_OPTS}"
fi

if [ -f ../docker_rootless/detect_rootless.sh ]; then
    source ../docker_rootless/detect_rootless.sh
fi

docker build ${CACHE_OPTS} --network=host -t ssh-proxy_server .

ret_code=$?
if [ $ret_code == 0 ]; then
    echo "Build succeeded"
else
    echo "Build failed"
    # make sure base image is built
    TARGET=$(grep -e FROM Dockerfile | awk '{print($2);}')
    echo "#-------------------------------------------------"
    echo "# make sure base image is built:"
    echo "# ${TARGET}"
    echo "#-------------------------------------------------"
    docker image ls ${TARGET}
fi

