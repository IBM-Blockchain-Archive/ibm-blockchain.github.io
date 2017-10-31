---
layout: default
title:  3. Interacting with your Blockchain
permalink: "/paid/interacting/"
category: paid
order: 3
---

# Interacting with your Blockchain
* * *

## Before you start
Make sure you have installed the IBM Blockchain Platform for Developers on IBM Container Service.  The easiest way to achieve this is by following the  **Prepare & Setup** steps, and then followed the **Simple Install** instructions.  Note that if you followed the Advanced Install instructions or ran through command-by-command using the Script Reference Docs, you may not have everything set up fully - if you have any trouble with these steps, try setting up an environment using the Simple Install.

### 1. Get the list of services for your network

Determine the public IP address of each service by running the following command:

```bash
$ kubectl get svc
NAME                   CLUSTER-IP       EXTERNAL-IP     PORT(S)                           AGE
blockchain-ca          172.21.19.128    169.48.207.86   30054:30054/TCP                   4m
blockchain-orderer     172.21.194.183   169.47.102.85   31010:31010/TCP                   4m
blockchain-org1peer1   172.21.165.205   169.48.207.83   30110:30110/TCP,30111:30111/TCP   4m
blockchain-org2peer1   172.21.174.181   169.48.207.84   30210:30210/TCP,30211:30211/TCP   4m
composer-playground    172.21.185.47    169.47.102.83   8080:31080/TCP                    2m
kubernetes             172.21.0.1       <none>          443/TCP                           3d
```

### 2. Access Composer Playground

Using your cluster's `External-IP` for `composer-playground` service you can now access the Hyperledger Composer Playground:

**Composer Playground** is a UI that can be used to create and deploy business networks to your blockchain runtime.  To access it, go to:
```
http://EXTERNAL_IP_FOR_COMPOSER_PLAYGROUND:31080
```

### 3. Develop And Deploy Your Business Network

Hyperledger Composer provides a tutorial for using Playground to create a basic Business Network.  We recommend you follow this to get to grips with the programming model:

[Hyperledger Composer playground guide](https://hyperledger.github.io/composer/tutorials/playground-guide.html)

**Note:** If you'd prefer to develop your applications locally, we recommend spending some more time on the Hyperledger Composer documentation, and exploring the Development Environment install instructions.  You can install a VSCode Extension for Composer, and use CLI commands to package up what you create into a .BNA file (Business Network Archive file).  These files can be imported into Playground to easily deploy them to your cloud environment.

Once you've deployed a Business Network Definition that you're happy to start writing some applications against, you can expose it as a REST API...

### 4. Expose Your Business Network As A REST API

Before performing this step, you must first have deployed a Business Network. You can use the Hyperledger Composer Playground, command line (CLI), or Node.js APIs to deploy a Business Network. For more information on deploying Business Networks, see the Hyperledger Composer documentation.

The Hyperledger Composer REST server allows you to expose your deployed Business Network via a REST API. Client applications, such as web or mobile applications, can interact with your deployed Business Network by using a REST or HTTP client. For more information on the Hyperledger Composer REST server and integrating existing systems with your deployed Business Network, see the [Integrating existing systems documentation](https://hyperledger.github.io/composer/integrating/integrating-index.html).

1. Start the Hyperledger Composer REST server for a deployed Business Network by running the following commands. Replace `INSERT_BIZNET_NAME` with the name of the Business Network.

    ```bash
    cd cs-offerings/scripts/
    ./create/create_composer-rest-server.sh --paid --business-network-id INSERT_BIZNET_NAME
    ```

2. Determine the public IP address of the `composer-rest-server` service similar to Step 1.

    ```bash
    $ kubectl get svc
    NAME                   CLUSTER-IP       EXTERNAL-IP     PORT(S)                           AGE
    blockchain-ca          172.21.19.128    169.48.207.86   30054:30054/TCP                   16m
    blockchain-orderer     172.21.194.183   169.47.102.85   31010:31010/TCP                   16m
    blockchain-org1peer1   172.21.165.205   169.48.207.83   30110:30110/TCP,30111:30111/TCP   16m
    blockchain-org2peer1   172.21.174.181   169.48.207.84   30210:30210/TCP,30211:30211/TCP   16m
    composer-playground    172.21.185.47    169.47.102.83   8080:31080/TCP                    14m
    composer-rest-server   172.21.61.175    169.47.102.82   3000:31090/TCP                    4m
    kubernetes             172.21.0.1       <none>          443/TCP                           3d
    ```
    From the example here, `composer-rest-server` service has an external endpoint of `169.47.102.83`.

3. Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer REST server at:

		http://EXTERNAL_ENDPOINT_FOR_REST_SERVER:31090/explorer/

### 5. Build A Connection Profile For Your Deployed Business Network

In order to interact with your deployed Business Network using the Hyperledger Composer command line (CLI) or Node.js APIs, you must create a Hyperledger Composer connection profile. A Hyperledger Composer connection profile defines all of the information required to access the Hyperledger Fabric network, for example the URLs of the peers.

For more information on Hyperledger Composer connection profiles, see the [Connection Profiles documentation](https://hyperledger.github.io/composer/reference/connectionprofile.html)

The Hyperledger Fabric network created by these scripts defines two organisations called `org1` and `org2`. In order to create a Hyperledger Composer connection profile for use by `org1`, perform the following steps:

1. Determine the public IP address of the cluster as in Step 1. The public IP address will be used later in the contents of the connection profile file.

2. Connection profiles are stored in a connection profile folder. The name of the connection profile folder is also the name of the connection profile. Create a connection profile folder named `ibm-bc-org1`:

		mkdir -p $HOME/.composer-connection-profiles/ibm-bc-org1
		cd $HOME/.composer-connection-profiles/ibm-bc-org1
		pwd

	The full path to the connection profile folder will be printed by the `pwd` command. It will contain the path to your home directory, for example `/home/testuser/.composer-connection-profiles/ibm-bc-org1`. You will need to remember this path in order to create the connection profile.

3. Blockchain identities, or digital certificates, are stored in a credentials folder. Create a credentials folder that will be used to store Blockchain identities which are used for the `ibm-bc-org1` connection profile:

		mkdir -p $HOME/.composer-credentials/ibm-bc-org1
		cd $HOME/.composer-credentials/ibm-bc-org1
		pwd

	The full path to the credentials folder will be printed by the `pwd` command. It will contain the path to your home directory, for example `/home/testuser/.composer-credentials/ibm-bc-org1`. You will need to remember this path in order to create the connection profile.

4. Finally, using your favourite editor, create a connection profile file named `connection.json` in the connection profile folder. This is the path that you determined in step 2.

	The contents of the connection profile file should be as follows. Replace all instances of `INSERT_PUBLIC_IP` with the IP address that you determined in step 1. Replace all instances of `INSERT_CREDENTIALS_PATH` with the path to the credentials folder that you determined in step 3.

		{
			"name": "ibm-bc-org1",
			"description": "Connection profile for IBM Blockchain Platform",
			"type": "hlfv1",
			"orderers": [
				{
					"url": "grpc://EXTERNAL_IP_ORDERER:31010"
				}
			],
			"ca": {
				"url": "http://EXTERNAL_IP_CA:30054",
				"name": "CA1"
			},
			"peers": [
				{
					"requestURL": "grpc://EXTERNAL_IP_PEER:30110",
					"eventURL": "grpc://EXTERNAL_IP_PEER:30111"
				}
			],
			"keyValStore": "INSERT_CREDENTIALS_PATH",
			"channel": "channel1",
			"mspID": "Org1MSP",
			"timeout": 300
		}

5. You can now use the Hyperledger Composer connection profile `ibm-bc-org1` with the Hyperledger Composer CLI application `composer`, or the Hyperledger Composer Node.js APIs. You can test this by using the `composer network ping` command to ping a deployed Business Network. Replace `INSERT_BIZNET_NAME` with the name of the Business Network.

		composer network ping -p ibm-bc-org1 -n INSERT_BIZNET_NAME -i admin -s adminpw

## Congratulations!
You've got a full development environment up and running!  Go create something exciting with IBM Blockchain!
