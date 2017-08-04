# Setup a blockchain network

(This assumes that you have followed [Step 2 - Creating a cluster on IBM Container Service](./create-cluster.md) on the [Main Instructions](../README.md) page.  If you have not yet done so, go back and do that now.)

Follow these instructions to set up a blockchain network on the Kubernetes cluster on IBM Container Service. You can pursue one of three routes to ultimately launch your blockchain network.

## All in one
The simplest of the three approaches, the all in one script - ``create_all.sh`` - will call a series of scripts and in turn accomplish the following tasks:
* launch the blockchain network
* create a channel named ``channel1``
* join each org's peer to the channel
* install example02 chaincode onto each peer's filesystem
* instantiates the chaincode on ``channel1``

Navigate to the ``scripts`` sub-directory:
```bash
cd cs-offerings/free/scripts
```

Now run the script:
```bash
./create_all.sh
```

## Script by script
Alternatively, you can use the following bash scripts to exercise each step incrementally.

While not required, you may wish to [understand the configurations](./setup-blockchain.md#1-understand-the-configurations) that each step is using prior to running the different scripts. Return to this section once you're done.  

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

## Step by step
Finally, you have the option of passing in each configuration file to manually accomplish each step.  If you choose to go this route, you should familiarize yourself with each individual yaml file.  Use the the subsequent section to explore the configs.

## 1. Understand the configurations

Click on the following links for descriptions of each config file:

* [blockchain.yaml](./descriptions/blockchain-yaml.md)
* [blockchain-services.yaml](./descriptions/blockchain-services-yaml.md)
* [create_channel.yaml](./descriptions/create_channel-yaml.md)
* [join_channel.yaml](./descriptions/join_channel-yaml.md)
* [composer-playground.yaml](./descriptions/composer-playground-yaml.md)
* [composer-playground-services.yaml](./descriptions/composer-playground-services-yaml.md)
* [composer-rest-server.yaml](./descriptions/composer-rest-server-yaml.md)
* [composer-rest-server-services.yaml](./descriptions/composer-rest-server-services-yaml.md)
* [wipe_shared.yaml](./description/wipe_shared.yaml)

Now that you are familiar with the configurations above, use the following instructions to stand up a network with an orderer, two peer nodes (one per org), hyperledger-composer and a proxy that allows for network accessibility from the internet.  Once the network is properly bootstrapped, you will create a channel - ``channel1`` - and join both peers to the channel.  

## 2. Deploy the blockchain network & services

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

## 3. Create the channel

Use an editor to open the ``create_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).

Under the `createchanneltx` and `createchannel` containers remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.

Save the file as `create_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `createchannel` containers are removed:
```bash
kubectl delete -f kube-configs/create_channel.yaml
```

Next, run the `createchannel` pod to create the channel.
```
kubectl create -f kube-configs/create_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```
kubectl get pod createchannel
```

You can check if the channel creation was successful by following the logs:
```
kubectl logs -f createchannel
```

Look for a huge blob (channel block output) at the end of the logs.  This indicates a successful channel creation.

### What's happening here?

The `createchanneltx` container reads in the `TwoOrgsChannel` profile to generate a channel transaction artifact, and then the `createchannel` container passes this artifact to the ordering service.  The ordering service uses this config to generate a channel configuration block that serves as the genesis block for the channel.  The peers then join the channel by passing in the channel configuration block as an argument.

## 4. Join Org1 peer to `channel1`

Use an editor to open the ``join_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `joinchannel1` container remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.
* Ensure that the `PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org1peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org1MSP`
* Ensure that `MSP_CONFIGPATH` is properly set to MSP folder of the admin user for Org1 as `/shared/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp` 
Save the file as `join_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `joinchannel` containers are removed:
```
kubectl delete -f kube-configs/join_channel.yaml
```

Next, run the `joinchannel` pod to join the Org1 peer to the channel.
```
kubectl create -f kube-configs/join_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```
kubectl get pod joinchannel
```

You can check if the peer successfully joined the channel by following the logs:
```
kubectl logs -f joinchannel
```

The following output in the logs indicates a successful join:
```
`Peer joined the channel!`
```

### What's happening here?

The `joinchannel1` container fetches the channel genesis block from the orderer and then provides the block to the Org1 peer to join the channel. The container then uses the peer's admin certs (located in the `/shared/crypto-config` folder) to authenticate this action.

## 5. Join Org2 peer to `channel1`

Use an editor to open the ``join_channel.yaml.base`` file (located in the ``kube-configs`` sub-directory).
* Under the `joinchannel2` container remove the `%CHANNEL_NAME%` placeholder values for the `CHANNEL_NAME` variable and replace them with `channel1`.
* Ensure that the `PEER_ADDRESS` address variable is properly set with the peer's URL (`blockchain-org2peer1:5010`).
* Ensure that the `CORE_PEER_LOCALMSPID` is properly set with `Org2MSP`
* Ensure that `MSP_CONFIGPATH` is properly set to MSP folder of the admin user for Org2 as `/shared/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp`

Save the file as `join_channel.yaml` in the same sub-directory .  **Note**: you are removing the `base` suffix with this renaming.

First, make sure any old `joinchannel` containers are removed:
```
kubectl delete -f kube-configs/join_channel.yaml
```

Next, run the `joinchannel` pod to join the Org2 peer to the channel.
```
kubectl create -f kube-configs/join_channel.yaml
```

You can check if the container completed successfully by looking at the status of the container:
```
kubectl get pod joinchannel
```

You can check if the peer successfully joined the channel by following the logs:
```
kubectl logs -f joinchannel
```

The following output in the logs indicates a successful join:
```
`Peer joined the channel!`
```

### What's happening here?

The `joinchannel2` container fetches the channel genesis block from the orderer and then provides the block to the Org2 peer to join the channel. The container then uses the peer's admin certs (located in the `/shared/crypto-config` folder) to authenticate this action.

## Congratulations!
You have successfully created a basic blockchain network, created a channel - `channel1` - and joined the peers of Org1 & Org2 to the channel.

[Click here to go back to main instructions.](../README.md)
