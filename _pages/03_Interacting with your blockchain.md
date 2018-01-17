---
layout: default
title:  3. Interacting with your Blockchain
permalink: "/interacting/"
category: tutorial
order: 4
---

# Interacting with your Blockchain
* * *

## Before you start
Make sure you have installed the IBM Blockchain Platform for Developers on IBM Container Service.  The easiest way to achieve this is by following the  **Prepare & Setup** steps, and then followed the **Simple Install** instructions.  Note that if you followed the Advanced Install instructions or ran through command-by-command using the Script Reference Docs, you may not have everything set up fully - if you have any trouble with these steps, try setting up an environment using the Simple Install.

### 1. Get the IP Address of your cluster

Determine the public IP address of your cluster by running the following command:
```
bx cs workers blockchain
```

The output should be similar to the following:
```
Listing cluster workers...
OK
ID                                                 Public IP      Private IP       Machine Type   State    Status
kube-dal10-pabdda14edc4394b57bb08d53c149930d7-w1   169.48.140.99   10.171.239.186   free           normal   Ready
```

The value you need is `Public IP` (in this example 169.48.140.99).

### 2. Access Composer Playground

Using your cluster's `Public IP` you can now access the Hyperledger Composer Playground:

**Composer Playground** is a UI that can be used to create and deploy business networks to your blockchain runtime.  To access it, go to:
```
http://YOUR_PUBLIC_IP_HERE:31080
```

### 3. Develop And Deploy Your Business Network

Hyperledger Composer provides a tutorial for using Playground to create a basic Business Network.  We recommend you follow this to get to grips with the programming model:

[Playground Tutorial](https://ibm-blockchain.github.io/develop/tutorials/playground-tutorial)

**Note:** If you'd prefer to develop your applications locally, we recommend spending some more time on the Hyperledger Composer documentation, and exploring the Development Environment install instructions.  You can install a VSCode Extension for Composer, and use CLI commands to package up what you create into a .BNA file (Business Network Archive file).  These files can be imported into Playground to easily deploy them to your cloud environment.

Once you've deployed a Business Network Definition that you're happy to start writing some applications against, you can expose it as a REST API...

### 4. Expose Your Business Network As A REST API

Before performing this step, you must first have deployed a Business Network. You can use the Hyperledger Composer Playground, command line (CLI), or Node.js APIs to deploy a Business Network. For more information on deploying Business Networks, see the Hyperledger Composer documentation.

On the **My Business Networks** screen in the Hyperledger Composer Playground, you should see two _business network cards_. The first business network card is called _PeerAdmin@hlfv1_ and was automatically created by the `create_all.sh` script above. The second business network card is the network administrator card which was generated and used to deploy your business network in the previous step, the name of this card will likely be _admin@BIZNET_ where `BIZNET` is the name of the business network you deployed in the previous step. The _name_ of a business network card is both the identity name and the network which is belongs to in the following format: _admin@BIZNET_

The Hyperledger Composer REST server allows you to expose your deployed Business Network via a REST API. Client applications, such as web or mobile applications, can interact with your deployed Business Network by using a REST or HTTP client. For more information on the Hyperledger Composer REST server and integrating existing systems with your deployed Business Network, see the [Integrating existing systems documentation](https://ibm-blockchain.github.io/develop/integrating/integrating-index).

1. Start the Hyperledger Composer REST server for a deployed Business Network by running the following commands. Replace `INSERT_BIZNET_CARD_NAME` with the name of the network administrator card created in the previous step.

    ```bash
    cd cs-offerings/scripts/
    ./create/create_composer-rest-server.sh --business-network-card INSERT_BIZNET_CARD_NAME
    ```

2. Determine the public IP address of the cluster as in Step 1.

3. Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer REST server at:

		http://YOUR_PUBLIC_IP_HERE:31090/explorer/

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
