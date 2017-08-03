<!-- ---
layout: default
title:  Overview
permalink: "/overview/"
--- -->

# IBM Blockchain Platform for Developers on IBM Container Service

Follow these instructions to launch a basic IBM Blockchain network on the IBM Container Service's free plan.

Most users will want to follow the **Prepare & Setup** instructions, to prepare a cluster on the IBM Container Service ready for IBM Blockchain to deploy to, and then the **Simple Install** instructions to deploy the default Developer Environment in a single script.

## Is this right for me?

You __could__ choose to run these images locally with Minikube.  However, if you're looking for a local Blockchain development environment, we recommend the Local Dev Environment install offered on the Hyperledger Composer website [ADD LINK HERE]: this uses Docker and Docker Compose to run Fabric and Composer on your local machine, and comes with other useful tools like a VSCode extension and CLI tools to deploy the Business Networks you create elsewhere (e.g. Faric running on IBM Cloud) later on.

> **Warning:** these instructions will stand up a publicly accessible development environment for IBM Blockchain.  We recommend you only use it for experimentation, and it is **not suitable and not supported** for any sort of "real" deployment.  If that's what you need, you should instead take a look at the IBM Blockchain Platform service, which provides a fully managed Fabric runtime on IBM Cloud (you could also install the local Dev Tools to build your business networks, then push them to the managed service in a secure way).

## What do I get?

The **Simple Install** will bring up the following components:

* A pre-configured Fabric (blockchain runtime):
  * 3 Fabric CAs (one apiece for the orderer org and two peer orgs)
  * Orderer node (running "solo")
  * 2 Fabric peer nodes (one apiece for each peer org - ``org1`` & ``org2``)
  * Some example installed and instantiated chaincode
* Composer Playground (UI for creating and deploying Business Networks to Fabric)
* The basic-sample-network deployed

It also creates services to expose the components.

At the end of the install, you will be able to obtain a public URL to access your instance of Composer Playground, and should use this to create and deploy your Business Networks.  For more on how to use IBM Blockchain Platform for Developers on IBM Container Service after installing it, see the **Interacting with your Blockchain** topic.  This is also where you will learn how to expose your deployed network as a REST API for further application development.

## Ready to get started?

The first step is to run through the **Prepare & Setup** instructions:

ADD A BUTTON LINKING TO THOSE INSTRUCTIONS
