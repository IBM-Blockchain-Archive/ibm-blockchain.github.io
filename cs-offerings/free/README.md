# IBM Blockchain on IBM Container Service (Free Plan)

Follow these instructions to launch a basic IBM blockchain network on the IBM Container Service's free plan.
It will bring up the following components:
* 3 Fabric CAs (one apiece for the orderer org and two peer orgs)
* Orderer node (running "solo")
* 2 Fabric peer nodes (one apiece for each peer org - ``org1`` & ``org2``)
* Fabric Composer
* Install and instantiate example02 chaincode

It also creates services to expose the components.

## Instructions

### 1. Install and setup CLIs
[Click here for instructions to install the required Command Line interfaces.](./docs/cli-installation.md)

### 2. Create a cluster on IBM Container Service
[Click here for instructions to create a cluster on IBM Container Service.](./docs/create-cluster.md)

### 3. Setup Blockchain Network
[Click here for instructions to deploy your blockchain network on the cluster on IBM Container Service.](./docs/setup-blockchain.md)

### 4. Start Hyperledger Composer Playground
[Click here for instructions to deploy Hyperledger Composer Playground; a framework for developing blockchain applications.](./docs/setup-composer.md)

## Congratulations!
You have successfully deployed all of the components for your blockchain network.

## Helpful commands:
```
# To get the logs of a component, use -f to follow the logs
kubectl logs $(kubectl get pods | grep <component> | awk '{print $1}')
# Example
kubectl logs $(kubectl get pods | grep org1peer1 | awk '{print $1}')

# To get into a running container
kubectl exec -ti $(kubectl get pods | grep <component> | awk '{print $1}') bash
# Example
kubectl exec -ti $(kubectl get pods | grep ordererca | awk '{print $1}') bash

# To get kubernetes UI
kubectl proxy

# On the browser go to 127.0.0.1:8001/ui
```
