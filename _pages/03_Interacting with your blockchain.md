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
Make sure you have installed the IBM Blockchain Platform for Developers on IBM Container Service.  The easiest way to achieve this is by following the **Simple Install** instructions.  Note that if you followed the Advanced Install instructions or ran through command-by-command using the Script Reference Docs, you may not have everything set up fully - if you have any trouble with these steps, try setting up an environment using the Simple Install.

### 1. Get the IP Address of your cluster

Determine the public IP address of your cluster by running the following command:
```
bx cs workers blockchain
```

The output should be similiar to the following:
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

Hyperledger Composer provides a tutorial for using Playground to create a basic Business Network.

[Hyperledger Composer playground guide](https://hyperledger.github.io/composer/tutorials/playground-guide.html)

### 4. Start and Access the Composer REST Server

You can also deploy a Hyperledger Composer REST server after you have deployed a business network definition. For more getting started information on this see the [Composer REST server documentation](https://hyperledger.github.io/composer/integrating/integrating-index.html)

The file `kube-configs/composer-rest-server.yaml` is already set up to reflect the business network that you have deployed.

Create the Composer REST server services:
```
kubectl create -f kube-configs/composer-rest-server-services.yaml
```

Create the Composer REST server:
```
kubectl create -f kube-configs/composer-rest-server.yaml
```

Determine the public IP address of the cluster by running the following command:
```
bx cs workers blockchain
```
The output should be similiar to the following:
```
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
