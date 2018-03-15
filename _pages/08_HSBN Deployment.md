---
layout: default
title: Deploying Composer Business Networks to IBM Blockchain Platform
permalink: "/platform-deployment/"
category: hsbn
order: 1
---

# Deploying Hyperledger Composer Business Network to IBM Blockchain Platform Enterprise Plan on IBM Cloud

IBM Blockchain Platform's developer tools help you create a **Business Network Definition**, which can then be packaged up into a **.bna** file (Business Network Archive).  The developer environments allow you to deploy .bna files to a local or cloud blockchain for development and sharing.

This guide deals with the next step in a pilot or production use case: activating your business network by deploying the .bna to a production environment - the IBM Blockchain Platform Service on IBM Cloud.

> ### Warning!
> These directions are applicable for the current version the IBM Blockchain Platform Enterprise Plan and Hyperledger Composer v0.16 release. This guide uses a pre-release version of Hyperledger Composer which could be updated, without notice, to include breaking changes. The guide should be treated as guidance only.<br><br>
> When you start this guide, you should already have your .bna file ready. For a guide to  developing your business network archive please refer to the [Developing Business Networks](https://ibm-blockchain.github.io/develop/business-network/business-network-index) documentation provided for Hyperledger Composer.

## Before You Start
1. You will need to install the Composer Development Environment to create the required business network archive (.bna) file. You can read about installation here: [Installing Hyperledger Composer](https://ibm-blockchain.github.io/develop/installing/development-tools).  Guidance on writing your business network is also available in the Hyperledger documentation.
2. You will also need access to an IBM Blockchain Platform Enterprise Plan service instance on IBM Cloud. You can register for an account at [Bluemix.net](https://console.bluemix.net/registration/) and you can create a service via the [IBM Blockchain Service](https://console.ng.bluemix.net/catalog/services/blockchain).

When you create the service, you will be offered the opportunity to create up to 3 peers. You will need at least one peer and to also follow the steps to create a channel into which you will add peers and then deploy your application.

If you intend to create a network with more than one organization then you will need to follow instructions here to invite others once you've setup your IBP Enterprise cloud services.

---

## Creating a connection.json file for your IBM Cloud Blockchain Service instance
From the main IBM Cloud dashboard, select the Blockchain service offering that you just created from the Cloud Foundry Services list. Then click the Enter Monitor button to view the network dashboard.

Now click the Service Credentials button at the top of the page and download them to your local system.

The downloaded file contains a `registrar` elemtent containing an `enrollId` and `enrollSecret` that is specific to your service/organization. 
For example:
```
"registrar": [
    {
        "enrollId": "admin",
        "enrollSecret": "PA55W0RD12"
    }
],
```
Make a note of these values as you will need them shortly.

You now need to convert the downloaded credentials file into a connection profile that Composer can use in a Business Network Card.
There is a handy tool that performs this task for you which can be installed using

```
npm install -g connection-profile-converter
```

Once that is installed, run the following to create a connection profile.

```
connection-profile-converter --input <YOUR_DOWNLOADED_CONNECTION_PROFILE_AS_.json> --output connection.json --channel <YOUR_CHANNEL_NAME> 
```

## Preparing a local Business Network card for Network Administration

1. You need to create a Composer business network card and import it using the following commands

```
composer card create -p connection.json -u <YOUR_enrollId> -s <YOUR_enrollSecret> -r PeerAdmin -r ChannelAdmin
composer card import -f admin@fabric-network.card
```

2. Check that the card imported succesfully with 
```
composer card list
```
This will show you the card name that you will need in the following steps.

3. Now request an identity for the admin user from the fabric Certificate Authority using
```
composer identity request --card admin@fabric-network
```

Now that we have an identity issued by the certificate authority for this participant, it is good practice to start using the credentials that were issued rather than the default enrolling id and secret that was created when the service was started.
This means deleting the card file that you just created and imported, from the card store to avoid the possibility of the ID being re-enrolled and another set of keys and certificates being generated which would then invalidate the card.

4. To delete the card run 
```
composer card delete --name admin@fabric-network
```

5. We now need to create a new business network card containing the credentials issued from the identity request that we just performed
To do this and then import the new card into the card store, issue the following commands

```
composer card create -p connection.json -u admin -c ~/.identityCredentials/admin-pub.pem -k ~/.identityCredentials/admin-priv.pem
composer card import -f admin@fabric-network.card
composer card list
```

What is this Business Network card for?
We have not specified anything about a business network or application yet. This card is there solely to perform administrative operations such as issuing new identities, managing business networks etc.

---

## Uploading your Certificate to the Monitor

1. Select **Members** from the navigation menu on the left panel, then select the **Certificates** tab and click on the **Add Certificate** button.
2. Enter a unique name for this certificate (don’t use dashes in the name) in the **Name** field.
3. Open the file ``admin-pub.pem`` created earlier in your favourite editor and copy the contents of this file into the **Key** field and press the **Submit** button (note: you may have to move the cursor in order for the dialogue to recognise the certificate you have pasted in).
4. Restart your peers by clicking OK when asked.
5. Once created it should appear in the list of certificates. Note that there is an arrow symbol. If you add more peers you should press this button to apply the certificates to newly added peers.
6. Return to the **Channels** page from the navigation panel and from the 3-dot actions menu select the **Sync Certificate** option. This pulls the certificates just uploaded into the channel.

---

## Deploying the Business Network Archive

Now you can deploy your .bna file to your IBM Blockchain Platform instance. An example of how to deploy is shown below.
```bash
composer network deploy -c admin@fabric-network -a <PATH_TO_.bna_FILE> -A admin -C ~/.identityCredentials/admin-pub.pem -f delete_me.card
```
The command creates a card file called `delete_me.card`. This card is of no use so just delete it.

---

## Create a Business network card which can interact with the deployed network

Now you need a Business network card that will allow you to interact on the deployed business network which can perform actions such as issue identities. To create the card issue the following command (note that it differs from the previous command used to create a card by the presence of the `-n` option flag)
```bash
composer card create -n <YOUR_BUSINESS_NETWORK_NAME> -p <YOUR_CONNECTION_PROFILE_FILE> -u admin -c ~/.identityCredentials/admin-pub.pem -k ~/.identityCredentials/admin-priv.pem
```
where `<YOUR_BUSINESS_NETWORK_NAME>` is the name of the business network you have just deployed. It should create a card file `admin@<YOUR_BUSINESS_NETWORK_NAME>.card` for example and we will refer to this as `<BN_CARD_FILE>`
You can then import this card into the card store
```bash
composer card import -f <BN_CARD_FILE>
```
Note the name of the card it should be something like `admin@<YOUR_BUSINESS_NETWORK_NAME>` and we will refer to it as `<BN_CARD_NAME>`
You can then test this card by doing
```bash
composer network ping -c <BN_CARD_NAME>
```

---

## Congratulations!

You should now have the ability to deploy Business Network Archive (.bna) files to your IBM Blockchain Platform Enterprise instance on IBM Cloud.
