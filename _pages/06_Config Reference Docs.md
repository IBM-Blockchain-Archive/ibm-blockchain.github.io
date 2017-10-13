---
layout: default
title:  Config Reference Docs
permalink: "/configreference/"
category: advanced
---

# Config Reference Docs

This page will describe the layout and contents of the different config files used by the scripts (we plan to complete this section over time!).

* * *
### Generating crypto material (crypto-config.yaml)

For bootstrapping the blockchain network, we need to first generate crypto material for all the components that we need to run. For eg., in our case we have

* one orderer-org with one orderer
* one admin user for orderer-org
* two peer-orgs each with two peers
* one admin user and two other users for each peer-org

See the yaml file that is being used [crypto-config.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/crypto-config.yaml) which can also be found in tools image at `/sampleconfig/crypto-config.yaml`. Following is the command used to generate the crypto-material.

```bash
cryptogen generate --config /sampleconfig/crypto-config.yaml
```

`cryptogen` is the tool that Hyperledger Fabric provides to generate crypto-material in a particular directory format that the components expect, for ease of setting up a basic network. More details can be found on [Hyperledger Fabric docs for crypto-gen](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html?highlight=cryptogen#crypto-generator).


From kubernetes point of view, in the utils pod, a container named `cryptogen` is defined which uses the same command as described above to generate crypto-material. Here is the block from [blockchain.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/cs-offerings/kube-configs/blockchain.yaml)

```bash
name: cryptogen
	image: ibmblockchain/fabric-tools:1.0.1
	imagePullPolicy: Always
	command: ["sh", "-c", "cryptogen generate --config /sampleconfig/crypto-config.yaml && cp -r crypto-config /shared/ && for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir /*_sk ${dir}/key.pem; done && find /shared -type d | xargs chmod a+rx &&  find /shared -type f | xargs chmod a+r && touch /shared/status_cryptogen_complete "]
	volumeMounts:
	- mountPath: /shared
	name: shared
```

* * *
### Generating Orderer Genesis Block (configtx.yaml)

After generating the crypto-material the next step in the process is to generate orderer genesis block. A `genesis block` is the configuration block that initializes a blockchain network or channel, and also serves as the first block on a chain. This can be done using the `configtxgen` tool which is also available in the tools image. The configtxgen tool takes [configtx.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/configtx.yaml) as input. The yaml has comments and is self explanatory.

To get the genesis block for orderer we run the following command
```bash
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
```

From kubernetes point of view, in the utils pods, a container named `configtxgen` is defined which uses the same command as described above to generate orderer genesis block. Here is the block from [blockchain.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/cs-offerings/kube-configs/blockchain.yaml)

```bash
name: configtxgen
	image: ibmblockchain/fabric-tools:1.0.1
	imagePullPolicy: Always
	command: ["sh", "-c", "sleep 1 && while [ ! -f /shared/status_cryptogen_complete ]; do echo Waiting for cryptogen; sleep 1; done; cp /sampleconfig/configtx.yaml 	/shared/configtx.yaml; cd /shared/; configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block && find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r && touch /shared/status_configtxgen_complete && rm /shared/status_cryptogen_complete"]
	env:
	- name: PEERHOST1
	value: blockchain-org1peer1
	- name: PEERPORT1
	value: "30110"
	- name: PEERHOST2
	value: blockchain-org2peer1
	- name: PEERPORT2
	value: "30210"
	- name: ORDERER_URL
	value: blockchain-orderer:31010
	- name: FABRIC_CFG_PATH
	value: /shared
	- name: GODEBUG
	value: "netdns=go"
	volumeMounts:
	- mountPath: /shared
	name: shared
```

* * *
### Fabric CA configs (ca.yaml's)

The fabric-ca now has capability to run more than one instances of the ca-server in the same process. This means that we need to pass all those yamls to start multiple ca-servers inside the same kubernetes container. These yamls can be found in the tools images in `/sampleconfig/cas`, there are 3 yamls one for orderer-org CA and one each for two peer-org's CA.
* [Orderer-org CA](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/cas/ca.yaml)
* [Peer-org1 CA](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/cas/org1/ca.yaml)
* [Peer-org2 CA](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/cas/org2/ca.yaml)

* * *
### Kubernetes config to bootsrtap and start the network (blockchain.yaml)


**Step 1 - Generate Crypto Material**

`cryptogen` is a Hyperledger Fabric utility that generates and packages crypto material (certs and keys) into a structure that is consumable by the network components.  The tool conveniently mimics a variety tasks typically done by a Certificate Authority, and thereby expedites the somewhat tedious process of setting up a basic blockchain network. See the [Hyperledger Fabric docs](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html?highlight=cryptogen#crypto-generator) for more details on the implementation and underlying mechanics of `cryptogen`.

For bootstrapping purposes, we need to first generate crypto material for all the components that will run in the network. For example, in our network we have:

* one Orderer Org (``OrdererOrg``) with a single ordering node
* one admin user for ``OrdererOrg``
* two Peer Orgs (``Org1`` & ``Org2``) with two peer nodes for each
* one admin user and two standard users for each Peer Org

The [crypto-config.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/crypto-config.yaml) file used to generate the crypto material is already added to fabric-tools image at `/sampleconfig/crypto-config.yaml`.

The following is the command used to generate the crypto-material:

```bash
cryptogen generate --config /sampleconfig/crypto-config.yaml
```

Within the kubernetes config, in the utils pod, a container defined as `cryptogen` exercises the above command to generate the requisite crypto material.  The following snippet from [blockchain.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/cs-offerings/kube-configs/blockchain.yaml), shows the codeblock where the cryptogen container is defined and the `generate` command is passed:

```bash
  - name: cryptogen
    image: ibmblockchain/fabric-tools:1.0.1
    imagePullPolicy: Always
    command: ["sh", "-c", "cryptogen generate --config /sampleconfig/crypto-config.yaml && cp -r crypto-config /shared/ && for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir}/*_sk ${dir}/key.pem; done && find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r && touch /shared/status_cryptogen_complete "]
    volumeMounts:
    - mountPath: /shared
      name: shared
```

Apart from generating the crypto material, the container also performs the following tasks:

1. copies the entirety of the crypto material into the `/shared` folder
   ```bash
   cp -r crypto-config /shared/
   ```
2. renames all the random key files to `key.pem`
   ```bash
   for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir}/*_sk ${dir}/key.pem; done
   ```
3. provides permissions to the crypto files
   ```bash
   find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r
   ```
4. writes `status_cryptogen_complete` file allowing the next process to start
   ```bash
   touch /shared/status_cryptogen_complete
   ```

**Step 2 - Generate the orderer genesis block**

After generating the crypto-material the next step generating orderer genesis block.

A `genesis block` is the configuration block that initializes a blockchain network or channel, and also serves as the first block on a chain. This can be done using the `configtxgen` tool which is also available in the tools image. The configtxgen tool takes [configtx.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/sampleconfig/configtx.yaml) as input. The yaml has comments and is self explanatory. See the [Hyperledger Fabric docs](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html?highlight=cryptogen#configuration-transaction-generator)
for more details on the implementation and underlying mechanics of `configtxgen`.

To get the genesis block for orderer we run the following command
```bash
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
```

Within the kubernetes config, in the utils pod, a container defined as `configtxgen`
exercises the above command to generate the orderer genesis block.  The following
snippet from [blockchain.yaml](https://github.com/IBM-Blockchain/ibm-container-service/blob/master/cs-offerings/kube-configs/blockchain.yaml), shows the
codeblock:

```bash
  - name: configtxgen
    image: ibmblockchain/fabric-tools:1.0.1
    imagePullPolicy: Always
    command: ["sh", "-c", "sleep 1 && while [ ! -f /shared/status_cryptogen_complete ]; do echo Waiting for cryptogen; sleep 1; done; cp /sampleconfig/configtx.yaml /shared/configtx.yaml; cd /shared/; configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block && find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r && touch /shared/status_configtxgen_complete && rm /shared/status_cryptogen_complete"]
    env:
     - name: PEERHOST1
       value: blockchain-org1peer1
     - name: PEERPORT1
       value: "30110"
     - name: PEERHOST2
       value: blockchain-org2peer1
     - name: PEERPORT2
       value: "30210"
     - name: ORDERER_URL
       value: blockchain-orderer:31010
     - name: FABRIC_CFG_PATH
       value: /shared
    # - name: GODEBUG
    #   value: "netdns=go"
    volumeMounts:
    - mountPath: /shared
      name: shared
```

The section does the following:
1. Wait for the [Step 1]() to be done
   ```bash
   while [ ! -f /shared/status_cryptogen_complete ]; do echo Waiting for cryptogen; sleep 1; done;
   ```

2. Copy the configtx.yaml to shared folder for future use
   ```bash
   cp /sampleconfig/configtx.yaml /shared/configtx.yaml;
   ```

3. Generate the orderer genesis block
   ```bash
   cd /shared/; configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
   ```

4. Make sure we have the correct permissions on the files
   ```bash
   find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r
   ```

5. Announce that the process is done, so the next processes can start
   ```
   touch /shared/status_configtxgen_complete
   ```

**Step 3 - Prepare the files for the CAs & hyperledger fabric composer**

Description goes here

```bash
- name: bootstrap
	image: ibmblockchain/fabric-tools:1.0.1
	imagePullPolicy: Always
	command: ["sh", "-c", "sleep 1 && while [ ! -f /shared/status_configtxgen_complete ]; do echo Waiting for configtxgen; sleep 1; done; cp -r /sampleconfig/cas /shared; touch /shared/bootstrapped && rm /shared/status_configtxgen_complete && mkdir -p /shared/composer-credentials && chown 100 /shared/composer-credentials && echo 'Done with bootstrapping'" ]
	volumeMounts:
- mountPath: /shared
	name: shared
```
