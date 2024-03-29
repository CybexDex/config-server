#!/bin/bash
###################################################################
#Script Name    : buildimage-configSvr.sh
#Description    : 用于给config server生成docker镜像，生成镜像后，可以手动执行下面一条指令启动容器
#Start container: docker run -d --name gateway -p 8081:8081 -p 8182:8182 -v /data/logs-gateway:/usr/src/app/log -v /opt/gateway/backend/config:/usr/src/app/config --link postgres:postgres 121.196.217.176:5000/gateway/gateway-backend:rc-1.0
#Args           : BUILD_DATE - build date
#                 VERSION    - gateway version info
#Author         : invan
#Email          : nan.yin@nbltrust.com
###################################################################

VERSION_FILE='package.json'
VERSION=V$(jq -r '.version' $VERSION_FILE)
echo -e "start to build image cybex-config-server:${VERSION}"

echo -e "1 remove exist image and container"
docker stop cybex-config-server 
docker rm cybex-config-server
docker rmi cybex-config-server:${VERSION}

echo -e "2 build executable files"
echo `pwd`
git pull

echo -e "3 build docker image"
docker build --force-rm --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VERSION=$VERSION -t cybex-config-server:$VERSION -f ./Dockerfile .

echo -e "---------------------------"
echo -e "build cybex-config-server success"
echo -e "---------------------------"
