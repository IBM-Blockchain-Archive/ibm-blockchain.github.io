#!/bin/bash
ARCH=`uname -m | sed 's|i686|x86_64|'`
SNAPSHOT=9d6cec8
VERSION=1.0.0
RELEASE=rc1
BASE_FOLDER=${PWD}

if [ -z $RELEASE ]; then
	PEER_VERSION=${VERSION}-snapshot-${SNAPSHOT}
else
	PEER_VERSION=${VERSION}-${RELEASE}
fi

sed -e "s/TAG/${PEER_VERSION}/g" Dockerfile_utils > Dockerfile_utils_tagged
docker build -f Dockerfile_utils_tagged -t dbshahibm/fabric-tools:${PEER_VERSION} .
rm Dockerfile_utils_tagged

