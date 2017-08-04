#

This kubernetes config bootstraps the blockchain network and then starts the network.

## Step 1 - Generate Crypto Material

`cryptogen` is a Hyperledger Fabric utility that generates and packages crypto material (certs and keys) into a structure that is consumable by the network components.  The tool conveniently mimics a variety tasks typically done by a Certificate Authority, and thereby expedites the somewhat tedious process of setting up a basic blockchain network. See the [Hyperledger Fabric docs](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html?highlight=cryptogen#crypto-generator) for more details on the implementation and underlying mechanics of `cryptogen`.

For bootstrapping purposes, we need to first generate crypto material for all the components that will run in the network. For example, in our network we have:

* one Orderer Org (``OrdererOrg``) with a single ordering node
* one admin user for ``OrdererOrg``
* two Peer Orgs (``Org1`` & ``Org2``) with two peer nodes for each
* one admin user and two standard users for each Peer Org

The [crypto-config.yaml](../sampleconfig/crypto-config.yaml) file used to generate the crypto material is already added to fabric-tools image at `/sampleconfig/crypto-config.yaml`.

The following is the command used to generate the crypto-material:

```bash
cryptogen generate --config /sampleconfig/crypto-config.yaml
```

Within the kubernetes config, in the utils pod, a container defined as `cryptogen` exercises the above command to generate the requisite crypto material.  The following snippet from [blockchain.yaml](../../kube-configs/blockchain.yaml), shows the codeblock where the cryptogen container is defined and the `generate` command is passed:

```
  - name: cryptogen
    image: ibmblockchain/fabric-tools:1.0.0
    imagePullPolicy: Always
    command: ["sh", "-c", "cryptogen generate --config /sampleconfig/crypto-config.yaml && cp -r crypto-config /shared/ && for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir}/*_sk ${dir}/key.pem; done && find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r && touch /shared/status_cryptogen_complete "]
    volumeMounts:
    - mountPath: /shared
      name: shared
```

Apart from generating the crypto material, the container also performs the following tasks:

1. copies the entirety of the crypto material into the `/shared` folder
   ```
   cp -r crypto-config /shared/
   ```
2. renames all the random key files to `key.pem`
   ```
   for file in $(find /shared/ -iname *_sk); do dir=$(dirname $file); mv ${dir}/*_sk ${dir}/key.pem; done
   ```
3. provides permissions to the crypto files
   ```
   find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r
   ```
4. writes `status_cryptogen_complete` file allowing the next process to start
   ```
   touch /shared/status_cryptogen_complete
   ```

## Step 2 - Generate the orderer genesis block

After generating the crypto-material the next step generating orderer genesis block.

A `genesis block` is the configuration block that initializes a blockchain network or channel, and also serves as the first block on a chain. This can be done using the `configtxgen` tool which is also available in the tools image. The configtxgen tool takes [configtx.yaml](../sampleconfig/configtx.yaml) as input. The yaml has comments and is self explanatory. See the [Hyperledger Fabric docs](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html?highlight=cryptogen#configuration-transaction-generator)
for more details on the implementation and underlying mechanics of `configtxgen`.

To get the genesis block for orderer we run the following command
```bash
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
```

Within the kubernetes config, in the utils pod, a container defined as `configtxgen`
exercises the above command to generate the orderer genesis block.  The following
snippet from [blockchain.yaml](../../kube-configs/blockchain.yaml), shows the
codeblock:

```
  - name: configtxgen
    image: ibmblockchain/fabric-tools:1.0.0
    imagePullPolicy: Always
    command: ["sh", "-c", "sleep 1 && while [ ! -f /shared/status_cryptogen_complete ]; do echo Waiting for cryptogen; sleep 1; done; cp /sampleconfig/configtx.yaml /shared/configtx.yaml; cd /shared/; configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block && find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r && touch /shared/status_configtxgen_complete && rm /shared/status_cryptogen_complete"]
    env:
     - name: PEERHOST1
       value: blockchain-org1peer1
     - name: PEERPORT1
       value: "5010"
     - name: PEERHOST2
       value: blockchain-org2peer1
     - name: PEERPORT2
       value: "5010"
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
   ```
   while [ ! -f /shared/status_cryptogen_complete ]; do echo Waiting for cryptogen; sleep 1; done;
   ```

2. Copy the configtx.yaml to shared folder for future use
   ```
   cp /sampleconfig/configtx.yaml /shared/configtx.yaml;
   ```

3. Generate the orderer genesis block
   ```
   cd /shared/; configtxgen -profile TwoOrgsOrdererGenesis -outputBlock orderer.block
   ```

4. Make sure we have the correct permissions on the files
   ```
   find /shared -type d | xargs chmod a+rx && find /shared -type f | xargs chmod a+r
   ```

5. Announce that the process is done, so the next processes can start
   ```
   touch /shared/status_configtxgen_complete
   ```

## Step 3 - Prepare the files for the CAs & hyperledger fabric composer

<Description goes here>

```
     - name: bootstrap
    image: ibmblockchain/fabric-tools:1.0.0
    imagePullPolicy: Always
    command: ["sh", "-c", "sleep 1 && while [ ! -f /shared/status_configtxgen_complete ]; do echo Waiting for configtxgen; sleep 1; done; cp -r /sampleconfig/cas /shared; touch /shared/bootstrapped && rm /shared/status_configtxgen_complete && mkdir -p /shared/composer-credentials && chown 100 /shared/composer-credentials && echo 'Done with bootstrapping'" ]
    volumeMounts:
    - mountPath: /shared
      name: shared
```