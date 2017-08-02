# IBM Blockchain Platform for Developers on IBM Container Service

Follow these instructions to launch a basic IBM Blockchain network on the IBM Container Service's free plan.

Most users will want to follow the **Prepare & Setup** instructions, to prepare a cluster on the IBM Container Service ready for IBM Blockchain to deploy to, and then the **Simple Install** instructions to deploy the default Developer Environment in a single script.

The **Simple Install** will bring up the following components:

* A pre-configured Fabric (blockchain runtime):
  * 3 Fabric CAs (one apiece for the orderer org and two peer orgs)
  * Orderer node (running "solo")
  * 2 Fabric peer nodes (one apiece for each peer org - ``org1`` & ``org2``)
  * Some example installed and instantiated chaincode
* Fabric Composer Playground (UI for creating and deploying Business Networks to Fabric)

It also creates services to expose the components.

At the end of the install, you will be able to obtain a public URL to access your instance of Composer Playground, and should use this to create and deploy your Business Networks.

## Ready to get started?

The first step is to run through the **Prepare & Setup** instructions:

ADD A BUTTON LINKING TO THOSE INSTRUCTIONS
