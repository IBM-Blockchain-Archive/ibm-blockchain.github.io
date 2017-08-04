#!/bin/bash

if [ "${PWD##*/}" == "create" ]; then
    KUBECONFIG_FOLDER=${PWD}/../../kube-configs
elif [ "${PWD##*/}" == "scripts" ]; then
    KUBECONFIG_FOLDER=${PWD}/../kube-configs
else
    echo "Please run the script from 'scripts' or 'scripts/create' folder"
fi

echo "Creating composer-rest-server pod"
echo "Running: kubectl create -f ${KUBECONFIG_FOLDER}/composer-rest-server.yaml"
kubectl create -f ${KUBECONFIG_FOLDER}/composer-rest-server.yaml

if [ "$(kubectl get svc | grep composer-rest-server | wc -l | grep -o -E '[0-9]+')" == "0" ]; then
    echo "Creating composer-rest-server service"
    echo "Running: kubectl create -f ${KUBECONFIG_FOLDER}/composer-rest-server-services.yaml"
    kubectl create -f ${KUBECONFIG_FOLDER}/composer-rest-server-services.yaml
fi

echo "Composer rest server created successfully"