---
layout: default
title:  Script Reference Docs
permalink: "/reference/"
category: advanced
order: 2
---

# Script Reference Docs
* * *

## Before you start
Make sure you have followed the instructions in **Prepare & Setup** - they are a prerequisite to any of the install instructions.

## Install with individual commands

This page covers the same ground as the Simple Install and Advanced Install, but rather than using any scripts we will instead individually call a series of commands to ultimately bootstrap a blockchain network, join peers to a channel and launch the Composer playground.  You can then use Composer Playground to create and deploy Business Networks to your blockchain network.

**Why choose this method?**  The Simple Install is the best option for most users - if you've already successfully followed those instructions, you don't need to follow these!  You may wish to follow these instructions if you want to stop part way through the install process e.g. not set up Composer Playground, or fully understand what the scripts are doing,

### 1. Clone ibm-container-service repository
You'll be using the config files and scripts from this repository, so start by cloning it to a directory of your choice on your local machine.

```bash
git clone https://github.com/IBM-Blockchain/ibm-container-service

# change dir to use the scripts in the following sections
cd cs-offerings/scripts/
```

Finally, you have the option of passing in each configuration file to manually accomplish each step.  If you choose to go this route, you should familiarize yourself with each individual yaml file.  Use the the subsequent section to explore the configs.

### 2. Understand the configurations

Below are the config files used during this install process, to learn more about these see the [config reference.](/configreference)

* blockchain.yaml
* blockchain-services.yaml
* create_channel.yaml
* join_channel.yaml
* composer-playground.yaml
* composer-playground-services.yaml
* composer-rest-server.yaml
* composer-rest-server-services.yaml
* wipe_shared.yaml

Now that you are familiar with the configurations above, use the following instructions to stand up a network with an orderer, two peer nodes (one per org), hyperledger-composer and a proxy that allows for network accessibility from the internet.  Once the network is properly bootstrapped, you will create a channel - ``channel1`` - and join both peers to the channel.  

### 3. Deploy the blockchain network & services

Ensure you are in the ``cs-offerings/free`` sub-directory when executing the following commands.

First, create the blockchain-services.  This provides the containers with the relevant DNS setup info, in turn allowing them to communicate amongst one another:

```bash
kubectl create -f kube-configs/blockchain-services.yaml
```

Now create the blockchain network components:

```bash
kubectl create -f kube-configs/blockchain.yaml
```

Wait for all the pods to come up and stabilize. You can check the status of the pods by running:

```bash
kubectl get pods
```

### 4. Create the channel

Use an editor to open the ``create_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).

Under the `createchanneltx` and `createchannel` containers remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.

Save the file as `create_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `createchannel` containers are removed:
```bash
kubectl delete -f kube-configs/create_channel.yaml
```

Next, run the `createchannel` pod to create the channel.
```bash
kubectl create -f kube-configs/create_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod createchannel
```

You can check if the channel creation was successful by following the logs:
```bash
kubectl logs -f createchannel
```

Look for a huge blob (channel block output) at the end of the logs.  This indicates a successful channel creation.

### What's happening here?

The `createchanneltx` container reads in the `TwoOrgsChannel` profile to generate a channel transaction artifact, and then the `createchannel` container passes this artifact to the ordering service.  The ordering service uses this config to generate a channel configuration block that serves as the genesis block for the channel.  The peers then join the channel by passing in the channel configuration block as an argument.

### 5. Join Org1 peer to `channel1`

Use an editor to open the ``join_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `joinchannel1` container remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.
* Ensure that the `PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org1peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org1MSP`
* Ensure that `MSP_CONFIGPATH` is properly set to MSP folder of the admin user for Org1 as `/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp` 
Save the file as `join_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `joinchannel` containers are removed:
```bash
kubectl delete -f kube-configs/join_channel.yaml
```

Next, run the `joinchannel` pod to join the Org1 peer to the channel.
```bash
kubectl create -f kube-configs/join_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod joinchannel
```

You can check if the peer successfully joined the channel by following the logs:
```bash
kubectl logs -f joinchannel
```

The following output in the logs indicates a successful join:
```
`Peer joined the channel!`
```

### What's happening here?

The `joinchannel1` container fetches the channel genesis block from the orderer and then provides the block to the Org1 peer to join the channel. The container then uses the peer's admin certs (located in the `/shared/crypto-config` folder) to authenticate this action.

### 6. Join Org2 peer to `channel1`

Use an editor to open the ``join_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `joinchannel2` container remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.
* Ensure that the `PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org2peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org2MSP`
* Ensure that `MSP_CONFIGPATH` is properly set to MSP folder of the admin user for Org2 as `/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp`

Save the file as `join_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `joinchannel` containers are removed:
```bash
kubectl delete -f kube-configs/join_channel.yaml
```

Next, run the `joinchannel` pod to join the Org2 peer to the channel.
```bash
kubectl create -f kube-configs/join_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod joinchannel
```

You can check if the peer successfully joined the channel by following the logs:
```bash
kubectl logs -f joinchannel
```

The following output in the logs indicates a successful join:
```
`Peer joined the channel!`
```

### What's happening here?

The `joinchannel2` container fetches the channel genesis block from the orderer and then provides the block to the Org2 peer to join the channel. The container then uses the peer's admin certs (located in the `/shared/crypto-config` folder) to authenticate this action.

## Install Hyperledger Composer Playground

### 7. Understand the configurations

Below are the config files used during this install process, to learn more about these see the [config reference.](/configreference)

* composer-playground.yaml
* composer-playground-services.yaml
* composer-rest-server.yaml
* composer-rest-server-services.yaml

Now that you are familiar with the configurations above, use the following instructions to stand up a Hyperledger Composer playground and REST server.

### 8. Deploy the hyperledger composer services

Ensure you are in the `cs-offerings/free` sub-directory when executing the following commands.

First, create the Composer playground services. This provides the containers with the relevant DNS setup info, in turn allowing them to communicate amongst one another:
```bash
kubectl create -f kube-configs/composer-playground-services.yaml
```

### 9. Create Hyperledger Composer playground

Now create the Composer playground.
```bash
kubectl create -f kube-configs/composer-playground.yaml
```

### 10. Access the playground

Determine the public IP address of the cluster by running the following command:
```bash
bx cs workers blockchain
```

The output should be similiar to the following:
```bash
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```

Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer Playground at:
```bash
http://YOUR_PUBLIC_IP_HERE:31080
```

### 11. Start a Hyperledger Composer REST server

You can also deploy a Hyperledger Composer REST server after you have deployed a business network definition.

The file `kube-configs/composer-rest-server.yaml` is already set up to reflect the business network that you have deployed.

Create the Composer REST server services:
```bash
kubectl create -f kube-configs/composer-rest-server-services.yaml
```

Create the Composer REST server:
```bash
kubectl create -f kube-configs/composer-rest-server.yaml
```

### 12. Access Hyperledger Composer REST Server

Determine the public IP address of the cluster by running the following command:
```bash
bx cs workers blockchain
```
The output should be similiar to the following:
```bash
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```
Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer REST server at:
```
http://YOUR_PUBLIC_IP_HERE:31090/explorer/
```

## Congratulations!
You have successfully created the Hyperledger Composer playground and Hyperledger Composer REST server.

## Install and Instantiate Chaincode example02

### 13. Install `example02` chaincode on `Org1 peer`

Use an editor to open the ``chaincode_install.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `chaincodeinstall` container remove the `%CHAINCODE_NAME%` placeholder values for the `CHAINCODE_NAME` variable and replace them with `example02`.
* Under the `chaincodeinstall` container remove the `%CHAINCODE_VERSION%` placeholder values for the `CHAINCODE_VERSION` variable and replace them with `v1`.
* Ensure that the `CORE_PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org1peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org1MSP`
* Ensure that `CORE_PEER_MSPCONFIGPATH` is properly set to MSP folder of the admin user for Org1 as `/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp`

Save the file as `chaincode_install.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `chaincodeinstall` containers are removed:
```bash
kubectl delete -f kube-configs/chaincode_install.yaml
```

Next, run the `chaincodeinstall` pod to install chaincode on Org1 peer
```bash
kubectl create -f kube-configs/chaincode_install.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod chaincodeinstall
```

You can check if the peer successfully joined the channel by following the logs:
```bash
kubectl logs -f chaincodeinstall
```

The following output in the logs indicates a successful install:
```
[chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
[chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
[main] main -> INFO 003 Exiting.....
```

### What's happening here?

The `chaincodeinstall` container clones the example02 chaincode from the fabric repo, it then uses the admin user creds for Org1's peer and installs the chaincode on Org1 peer. In the same way by just changing the `git clone` command and the path, you can install some other chaincode as well.

### 14. Install `example02` chaincode on `Org2 peer`

Use an editor to open the ``chaincode_install.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `chaincodeinstall` container remove the `%CHAINCODE_NAME%` placeholder values for the `CHAINCODE_NAME` variable and replace them with `example02`.
* Under the `chaincodeinstall` container remove the `%CHAINCODE_VERSION%` placeholder values for the `CHAINCODE_VERSION` variable and replace them with `v1`.
* Ensure that the `CORE_PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org2peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org2MSP`
* Ensure that `CORE_PEER_MSPCONFIGPATH` is properly set to MSP folder of the admin user for Org2 as `/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp`

Save the file as `chaincode_install.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `chaincodeinstall` containers are removed:
```bash
kubectl delete -f kube-configs/chaincode_install.yaml
```

Next, run the `chaincodeinstall` pod to install chaincode on Org1 peer
```bash
kubectl create -f kube-configs/chaincode_install.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod chaincodeinstall
```

You can check if the peer successfully joined the channel by following the logs:
```bash
kubectl logs -f chaincodeinstall
```

The following output in the logs indicates a successful install:
```
[chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
[chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
[main] main -> INFO 003 Exiting.....
```

### What's happening here?

The `chaincodeinstall` container clones the example02 chaincode from the fabric repo, it then uses the admin user creds for Org1's peer and installs the chaincode on Org1 peer. In the same way by just changing the `git clone` command and the path, you can install some other chaincode as well.

### 15. Instantiate `example02` chaincode on `channel1`

Use an editor to open the ``chaincode_instantiate.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `chaincodeinstantiate` container remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.
* Under the `chaincodeinstantiate` container remove the `%CHAINCODE_NAME%` placeholder values for the `CHAINCODE_NAME` variable and replace them with `example02`.
* Under the `chaincodeinstantiate` container remove the `%CHAINCODE_VERSION%` placeholder values for the `CHAINCODE_VERSION` variable and replace them with `v1`.
* Ensure that the `CORE_PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org1peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org1MSP`
* Ensure that `CORE_PEER_MSPCONFIGPATH` is properly set to MSP folder of the admin user for Org1 as `/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp`

Save the file as `chaincode_instantiate.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `chaincodeinstantiate` containers are removed:
```bash
kubectl delete -f kube-configs/chaincode_instantiate.yaml
```

Next, run the `chaincodeinstantiate` pod to instantiate example02 chaincode on channel1
```bash
kubectl create -f kube-configs/chaincode_instantiate.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```bash
kubectl get pod chaincodeinstantiate
```

You can check if the peer successfully joined the channel by following the logs:
```bash
kubectl logs -f chaincodeinstantiate
```

The following output in the logs indicates a successful install:
```
[chaincodeCmd] checkChaincodeCmdParams -> INFO 001 Using default escc
[chaincodeCmd] checkChaincodeCmdParams -> INFO 002 Using default vscc
[main] main -> INFO 003 Exiting.....
```

### What's happening here?

The `chaincodeinstantiate` container instantiates the example02 chaincode, it then uses the admin user creds for Org1's peer. Instainate transaction happens on the channel and all the peers that have joined the channel now will get a block that has the instantiate transacation from the orderer.

