---
layout: default
title:  Advanced Install
permalink: "/advanced/"
category: advanced
order: 1
---

# Advanced Install
* * *

## Before you start
Make sure you have followed the instructions in **Prepare & Setup** - they are a prerequisite to any of the install instructions.

## Install with a collection of scripts

The Advanced Install method covers the same ground as the Simple Install, but rather than using the all in one script - ``create_all.sh`` - we will instead individually call a series of scripts to ultimately bootstrap a blockchain network, join peers to a channel and launch the Composer playground.  You can then use Composer Playground to create and deploy Business Networks to your blockchain network.

**Why choose Advanced Install?**  The Simple Install is the best option for most users - if you've already successfully followed those instructions, you don't need to follow these!  You may wish to follow these instructions if you want to stop part way through the install process e.g. not set up Composer Playground.

### 1. Clone ibm-container-service repository
You'll be using the config files and scripts from this repository, so start by cloning it to a directory of your choice on your local machine.

```bash
git clone https://github.com/IBM-Blockchain/ibm-container-service

# change dir to use the scripts in the following sections
cd cs-offerings/free/scripts/
```

### 2. Set up the Blockchain Network

1. Create blockchain network
```
./create/create_blockchain.sh
```

2. Create channel named `channel1`
```
CHANNEL_NAME="channel1" create/create_channel.sh
```

3. Join Org1 peer to `channel1`
```
CHANNEL_NAME="channel1" PEER_ADDRESS="blockchain-org1peer1:5010" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" create/join_channel.sh
```

4. Join Org2 peer to `channel1`
```
CHANNEL_NAME="channel1" PEER_ADDRESS="blockchain-org2peer1:5010" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" create/join_channel.sh
```

### 3. Set up Composer Playground

1. Launch the Playground - this is a UI for creating and deploying Business Networks to your Blockchain runtime.
```
./create/create_composer-playground.sh
```

2. Create and start the REST server
```
./create/create_composer-rest-server.sh
```

### 4. Install and Instantiate Chaincode

1. Install `example02` chaincode on Org1 peer
```bash
CHAINCODE_NAME="example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"  PEER_MSPID="Org1MSP" PEER_ADDRESS="blockchain-org1peer1:5010" create/chaincode_install.sh
```

2. Install `example02` chaincode on Org2 peer
```bash
CHAINCODE_NAME="example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp"  PEER_MSPID="Org2MSP" PEER_ADDRESS="blockchain-org2peer1:5010" create/chaincode_install.sh
```

3. Instantiate `example02` chaincode on `channel1`
```bash
CHANNEL_NAME="channel1" CHAINCODE_NAME="example02" CHAINCODE_VERSION="v1" MSP_CONFIGPATH="/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"  PEER_MSPID="Org1MSP" PEER_ADDRESS="blockchain-org1peer1:5010" create/chaincode_instantiate.sh
```
