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

[Hyperledger Composer playground guide](https://hyperledger.github.io/composer/stable/tutorials/playground-guide.html)

**Note:** If you'd prefer to develop your applications locally, we recommend spending some more time on the Hyperledger Composer documentation, and exploring the Development Environment install instructions.  You can install a VSCode Extension for Composer, and use CLI commands to package up what you create into a .BNA file (Business Network Archive file).  These files can be imported into Playground to easily deploy them to your cloud environment.

Once you've deployed a Business Network Definition that you're happy to start writing some applications against, you can expose it as a REST API...

### 4. Expose Your Business Network As A REST API

Before performing this step, you must first have deployed a Business Network. You can use the Hyperledger Composer Playground, command line (CLI), or Node.js APIs to deploy a Business Network. For more information on deploying Business Networks, see the Hyperledger Composer documentation.

On the **My Business Networks** screen in the Hyperledger Composer Playground, you should see two _business network cards_. The first business network card is called _PeerAdmin@hlfv1_ and was automatically created by the `create_all.sh` script above. The second business network card is the network administrator card which was generated and used to deploy your business network in the previous step, the name of this card will likely be _admin@BIZNET_ where `BIZNET` is the name of the business network you deployed in the previous step. The _name_ of a business network card is both the identity name and the network which is belongs to in the following format: _admin@BIZNET_

The Hyperledger Composer REST server allows you to expose your deployed Business Network via a REST API. Client applications, such as web or mobile applications, can interact with your deployed Business Network by using a REST or HTTP client. For more information on the Hyperledger Composer REST server and integrating existing systems with your deployed Business Network, see the [Integrating existing systems documentation](https://hyperledger.github.io/composer/stable/integrating/integrating-index.html).

1. Start the Hyperledger Composer REST server for a deployed Business Network by running the following commands. Replace `INSERT_BIZCARD_NAME` with the name of the Business Network Card from Playground.

    ```bash
    cd cs-offerings/scripts/
    ./create/create_composer-rest-server.sh --paid --business-network-card INSERT_BIZCARD_NAME
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

### 5. Ping the deployed business network from the CLI

In order to interact with your deployed Business Network using the Hyperledger Composer command line (CLI) you must export a business network card.

1. In the Hyperledger Composer Playground, at the **My Business Networks** screen, click the ![Export](../assets/Export-button.png) **Export** button underneath the business network card created for a network.

2. Now that the business network card has been downloaded, the card's connection profile must be reconfigured to connect to the kubernetes containers using the following script.

    ```bash
    cd cs-offerings/scripts/
    ./connection-profile/update_card.sh -c PATH_TO_EXPORTED_CARD -a YOUR_PUBLIC_IP_HERE
    ```

3. After the card has been reconfigured, import the card using the following command.

    ```bash
    composer card import -f PATH_TO_EXPORTED_CARD
    ```

4. Check the current list of imported cards by running the following command. There should be a `PeerAdmin@hlfv1` card and the card configured in the previous step.

    ```bash
    composer card list
    ```

5. You can now ping your business network using the imported business network card.

    ```bash
		composer network ping -c CARD_NAME
    ```

## Congratulations!
You've got a full development environment up and running!  Go create something exciting with IBM Blockchain!
