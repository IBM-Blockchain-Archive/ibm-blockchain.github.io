---
layout: default
title:  3. Interacting with your Blockchain
permalink: "/interacting/"
category: tutorial
order: 4
---

# Interacting with your Blockchain

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

LINK TO THE PLAYGROUND TUTORIAL ON THE COMPOSER DOC

### 4. Start (or access?) the Composer REST Server

I get fuzzy on the detail here ;)  Need to figure out how this bit works, and when/how you need to re-start your REST Server because of changes to your business network.  TBC.
