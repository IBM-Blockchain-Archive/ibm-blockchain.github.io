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

### 3. Develop Your Business Network

Hyperledger Composer provides a tutorial for using Playground to create a basic Business Network.  We recommend you follow this to get to grips with the programming model:

[Hyperledger Composer playground guide](https://hyperledger.github.io/composer/tutorials/playground-guide.html)

**Note:** If you'd prefer to develop your applications locally, we recommend spending some more time on the Hyperledger Composer documentation, and exploring the Development Environment install instructions.  You can install a VSCode Extension for Composer, and use CLI commands to package up what you create into a .BNA file (Business Network Archive file).  These files can be imported into Playground to easily deploy them to your cloud environment.

Once you've deployed a Business Network Definition that you're happy to start writing some applications against, you can expose it as a REST API...

### 4. Start and Access the Composer REST Server

You can deploy a Hyperledger Composer REST Server after you have deployed a Business Network Definition.  Whilst you _could_ do this as soon as you've accessed Playground (as the Basic Sample Network will be deployed by default), we recommend you start by developing your Business Network Definition and only stand up the REST Server when you've got something you want to develop applications against.

For more getting started information on this see the [Composer REST server documentation](https://hyperledger.github.io/composer/integrating/integrating-index.html)

Unless you've done something outside the scope of these instructions, the file `kube-configs/composer-rest-server.yaml` is already set up to work with the Business Network that you have deployed.

Deploy the composer rest server:
```
cd cs-offerings/free/scripts/
./create/create_composer-rest-server.sh
```

Determine the public IP address of the cluster as in Step 1:

Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer REST server at:
```
http://YOUR_PUBLIC_IP_HERE:31090/explorer/
```

## Congratulations!
You've got a full development environment up and running!  Go create something exciting with IBM Blockchain!
