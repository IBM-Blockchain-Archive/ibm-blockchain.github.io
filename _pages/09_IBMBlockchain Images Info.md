---
layout: default
title:  IBM Blockchain Images
permalink: "/ibmblockchainimages/"
category: advanced
order: 3
---

## IBM Blockchain Images

IBM Blockchain Docker images are based on Hyperledger Fabric v1.0 with a number of enhancements for serviceability. These images also benefit from a complete series of tests for functionality, stability, and performance across the following supported system platforms: z Systems and LinuxONE (s390), Power (ppc64le), and x86.

Once testing is complete, IBM signs the images and places them on the IBM Blockchain Docker Hub repository (https://hub.docker.com/r/ibmblockchain/). Eligibility for an IBM support agreement is based on the use of these images.

## Technical Support

Technical support may be purchased only when using the IBM Blockchain images available from the [IBM Blockchain Docker Hub repo](https://hub.docker.com/u/ibmblockchain/). Support will not be provided for images that have been altered. Please see the Getting Support section below for more information.   

Samples provided for blockchain network setup are intended only as examples, and should not be used as a prescription for setting up, administering, and operating an individual blockchain network or solution. For additional help setting up and operating a blockchain network, IBM recommends use of IBM Lab Services.

Additional information can be found below under the heading Documentation Links.

## Supported Platforms

All downloadable images are supported on platforms capable of running the required prerequisites, provided in the Getting Started information.

## Sample Network Setup  

Refer to the "first-network" subdirectory in the [fabric-samples](https://github.com/hyperledger/fabric-samples/tree/master/first-network) repository for a series of sample docker-compose scripts.  Instructions for running a network against these files can be found in the [Build Your First Network](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) section of the Hyperledger Fabric documentation.

**Note**:  
These are sample docker-compose yaml files that contain the fundamental components for a Fabric network.  They are not meant to be a prescriptive approach to your individual network or solution.  However, the exposed configuration provides a functional baseline from which you may begin building out your network.  To leverage the IBM Blockchain docker images, you need to make a few minor alterations to the file(s).  As per standard docker implemenation, each container is specified against an image.  You'll notice that the Hyperledger Fabric docker-compose files are appropriately tagged against Hyperledger Fabric Images.  Simply replace the Hyperledger Fabric ``image`` specification with the IBM Blockchain specification and drop the architecture (x86_64, ppc64le, s390x) from image.

For example:

``` yaml
version: '2'
services:
  orderer.example.com:
    container_name: orderer.example.com
    image: hyperledger/fabric-orderer:x86_64-1.0.0
    environment:
      - ORDERER_GENERAL_LOGLEVEL=debug
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/etc/hyperledger/configtx/twoorgs.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/msp/orderer
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/orderer
```


_**WOULD BECOME**_


``` yaml
version: '2'
services:
  orderer.example.com:
    container_name: orderer.example.com
    image: ibmblockchain/fabric-orderer:1.0.0
    environment:
      - ORDERER_GENERAL_LOGLEVEL=debug
      - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
      - ORDERER_GENERAL_GENESISMETHOD=file
      - ORDERER_GENERAL_GENESISFILE=/etc/hyperledger/configtx/twoorgs.genesis.block
      - ORDERER_GENERAL_LOCALMSPID=OrdererMSP
      - ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/msp/orderer
    working_dir: /opt/gopath/src/github.com/hyperledger/fabric/orderer
```

Once you have made these alterations, you can proceed with customizing and running your Fabric instance.  

## Setting Users and Groups in the containers

By default, Hyperledger Peer Docker containers use the docker.sock file for communications to create chaincode containers via the /host/var/run mount. Non-root users running inside Hyperledger Peer Docker containers MUST be a member of the docker group defined in the native OS (/etc/group). If the non-root user running inside a Hyperledger Peer Docker container does not have the same group id as the docker group id contained in the native OS /etc/group file then an error will occur.

Processes can be started with the user of choice by passing the following variables:

USERNAME=<username of choice>
GROUP_ID=<guid of choice>
USER_ID=<uuid of choice>

Otherwise, all processes will start with the following default user:
USERNAME=fabric
GROUP_ID=198
USER_ID=199

Note: if you are mounting the docker socket inside the peer container, the docker socket will need to have enough permissions for the user to be able to use it. We suggest to pass the docker group's guid to the peer's GROUP_ID environment variable.

## Documentation links

For additional learning and assistance on administering and operating a blockchain network, refer to the following links:

Educational information: [IBM DeveloperWorks](https://developer.ibm.com/blockchain/)
Educational and technical information: [Hyperledger Fabric Documentation](http://hyperledger-fabric.readthedocs.io/en/latest/)
Docker specific information: [Docker Documentation](https://docs.docker.com/engine/reference/commandline/cli/)
FAQs and troubleshooting: [Stack Overflow](https://stackoverflow.com/questions/tagged/hyperledger-fabric)

## Getting Support

When building production networks, IBM offers technical support which can be purchased. Start by ordering through [Passport Advantage and Passport Advantage Express](https://www-01.ibm.com/software/passportadvantage/)

## Additional Support Channels

* Connect with IBM Blockchain expertise at the [IBM Blockchain Support](https://www.ibm.com/blockchain/hyperledger-fabric-support.html) page.
* [Rocket Chat](https://chat.hyperledger.org) is a great resource to consult with the Hyperledger Fabric community and component subject matter experts.  

## Disclaimer
[Click here for disclaimer](https://ibm-blockchain.github.io/notices/)
