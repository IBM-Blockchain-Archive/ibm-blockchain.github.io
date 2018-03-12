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

**Composer Playground** is a UI that can be used to create and deploy Business Networks to your blockchain runtime.  To access it, go to:
```
http://EXTERNAL_IP_FOR_COMPOSER_PLAYGROUND:31080
```

### 3. Develop And Deploy Your Business Network

Hyperledger Composer provides a tutorial for using Playground to create a basic Business Network.  We recommend you follow this to get to grips with the programming model:

[Playground Tutorial](https://ibm-blockchain.github.io/develop/tutorials/playground-tutorial)

**Note:** If you are familiar with Hyperledger Composer and do not want to use Playground to develop a Business Network at this time, jump to section 6.

1. Underneath the section **Connection: hlfv1**  (NOT Connection: Web Browser) - click **Deploy New Business Network** 
2. Use an _empty-business-network_ if you have a model already to paste in, otherwise select a template and complete details e.g.

    Name: **perishable-network**

    Description: **Initial Test Perishable Goods Business Network**

    Network Admin Card: **admin@perishable-network**

3. Scroll down and complete details:
    Credentials: ID and **Secret**

    Enrollment ID: **admin**

    Enrollment Secret: **adminpw**

4. Click the **Deploy** button
5. When the Business Network is started you will see your new Network Admin card and you can click **Connect now**
6. You are now able to work with the Define and Test tabs of the new Business Network.

### 4. Understanding Business Network Cards

On the **My Business Networks** screen in the Hyperledger Composer Playground, you should see two _business network cards_. The first Business Network Card is called _PeerAdmin@hlfv1_ and was automatically created by the `create_all.sh` script. The second Business Network Card is the network administrator card which was generated, the name of this card will likely be _admin@BIZNET_ where `BIZNET` is the name of the Business Network you deployed in the previous step. The _name_ of a business network card is both the identity name and the network which is belongs to in the following format: _admin@BIZNET_ 

The PeerAdmin card has 2 roles in our dev fabric server setup. It has the authority to install the Composer Runtime (chaincode) onto the peer, and to start the Business Network (chaincode) on the channel. Importantly, once the PeerAdmin has started the Business Network it has no access to the Business Network!

The Network Admin card is a card that provides access to the deployed Business Network. The default Admin ID from the CA is bound to an instance of the inbuilt NetworkAdmin Participant type.   Assuming a default ACL, the ID belonging to this card can Create Assets, Create Participants and Submit transactions.  The ID belonging to the Network Admin Card can also Issue new IDs to Participants, Update the Business Network Definition and modify the ACL.

### 5. Expose Your Business Network As A REST API

Once you've deployed a Business Network Definition that you're happy to start writing some applications against, you can expose it as a REST API. 

Client applications, such as web or mobile applications, can interact with your deployed Business Network by using a REST or HTTP client. For more information on the Hyperledger Composer REST server and integrating existing systems with your deployed Business Network, see the [Integrating existing systems documentation](https://ibm-blockchain.github.io/develop/integrating/integrating-index).

(This document assumes you have deployed a Business Network from the previous step, but note that you can also deploy networks using the command line (CLI) or the Node.js API - see the Hyperledger Composer documentation for more information.)

1. Start the Hyperledger Composer REST server for a deployed Business Network by running the following commands. Replace `INSERT_BIZCARD_NAME` with the name of the Business Network Card from Playground.  (This should be the Network Admin Card NOT the PeerAdmin card.)

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

### 6. Export the Business Network Card to the CLI and Ping the deployed business network from the CLI

In order to interact with your deployed Business Network using the Hyperledger Composer command line (CLI) you must export a business network card.  (Use the Network Admin card.)

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

4. Check the current list of imported cards by running the following command. 

    ```bash
    composer card list
    ```

5. You can now ping your business network using the imported business network card.

    ```bash
		composer network ping -c CARD_NAME
    ```
### 7. Develop and Deploy business networks from the CLI

If you'd prefer to develop your applications locally, we recommend spending some more time on the Hyperledger Composer documentation, and exploring the Development Environment install instructions.  You can install a VSCode Extension for Composer, and use CLI commands to package up what you create into a .BNA file (Business Network Archive file).  These files can be imported into Playground to easily deploy them to your cloud environment.

If you wish to Deploy Business Networks from the CLI you will need the PeerAdmin card - use the steps in the previous section to get the PeerAdmin card locally.


## Congratulations!
You've got a full development environment up and running!  Go create something exciting with IBM Blockchain!
