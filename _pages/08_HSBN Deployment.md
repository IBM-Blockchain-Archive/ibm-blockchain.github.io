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
2. You will also need access to an Enterprise Service instance on IBM Cloud. You can register for an account at [Bluemix.net](https://console.bluemix.net/registration/) and you can create a service via the [IBM Blockchain Service](https://console.ng.bluemix.net/catalog/services/blockchain).
You will need to create a channel and at least one peer.

---

## Creating a connection.json file for your IBM Cloud Blockchain Service instance
Create a file in the using your favorite editor and name it `connection.json`.
You can use the following as a code template for your ``connection.json`` file:

```json
{
    "name": "bmx-hlfv1",
    "description": "A description for a V1 Profile",
    "type": "hlfv1",
    "orderers": [
        {
            "url": "grpcs://abca.4.secure.blockchain.ibm.com:12345"
        }
    ],
    "ca": {
        "url": "https://abc.4.secure.blockchain.ibm.com:98765",
        "name": "PeerOrg1CA"
    },
    "peers": [
        {
            "requestURL": "grpcs://abcd.4.secure.blockchain.ibm.com:22222",
            "eventURL": "grpcs://abcd.4.secure.blockchain.ibm.com:33333"
        }
    ],
    "channel": "mychannel",
    "mspID": "PeerOrg1",
    "globalCert": "-----BEGIN CERTIFICATE-----\r\n...LotsOfStuff\r\n-----END CERTIFICATE-----\r\n-----BEGIN CERTIFICATE-----\r\nMorestuff\r\n-----END CERTIFICATE-----\r\n",
    "timeout": 300
}
```
We will refer to this `connection.json` file as `<YOUR_CONNECTION_PROFILE_FILE>` in various commands later.

You will populate the newly created `connection.json` file with attributes that are provided via your IBM Blockchain Platform dashboard. From your Platform dashboard on IBM Cloud, select **Overview** from the navigation menu on the left panel. Then click on the **Service Credentials** button to display the endpoint and certificate information for the members of the channel where you want to deploy your business network archive.

### Orderers
Now we can start to modify the template with the information provided by the Service Credentials, starting with the orderers. While you have multiple orderers in your Service Credentials only one is required for your `connection.json` file replace the orderer url values in the template:
```
“url”: “grpcs://abca.4.secure.blockchain.ibm.com:12345”
```
With the “url” value for the first orderer found in your service credentials. Modify this value with your information.

### CA (Certificate Authority)
Modify the ca value in your `connection.json` with both the **url** and the **caName** from either of the entries in the **certificateAuthorities** section.

### Peers
Now we need to set the url for each Peer **requestURL** and **eventURL**. Modify the ``connection.json`` file and replace the **url** attribute with the **url** value found in your Service Credentials. Replace the **eventURL** attribute with the **eventUrl** found in your Service Credentials. After making the changes it should look similar to this, although your ports and host address should be different:

```
"peers": [
  {
      "requestURL": "grpcs://abca.4.secure.blockchain.ibm.com:12345",
      "eventURL": "grpcs://abca.4.secure.blockchain.ibm.com:12345"
```

### Channel
Modify the channel value in the ``connection.json`` to match the name of the channel which you plan to create and deploy your business network to.

### mspID
The mspID value in your connection.json file should be set to the mspID or your organization. The service credentials provide a list of the organizations with their associated msp id’s and peers. You should use the value from the **mspid** attribute from your organization.

### globalCert
Currently IBM Blockchain Platform uses a common TLS certificate for the orderers and peers. For each orderer and peer there is a **tlsCACerts** attribute which all contain the same certificate. Replace the dummy value in the connection.json file template with the **tlsCACerts** value. It should look like this:
```bash
"globalCert": "-----BEGIN CERTIFICATE-----\r\.......
```

---

## Preparing your peers by uploading certificate to provide administrative authority.

> ### Important
> You **must** perform this step first before creating your channel. Failure to do so will mean you won’t be able to start the business network.
>

1. The first step is to request certificates for an identity that is a member of your Membership Service Provider (msp). in your service credentials document under **certificateAuthorities** should be an attribute **registrar** containing attributes for **enrollId** and **enrollSecret**. For example:
```
"registrar": [
    {
        "enrollId": "admin",
        "enrollSecret": "PA55W0RD12"
    }
],
```
2. To request the certificates you would issue the following commands
```bash
composer card create -f ca.card -p <YOUR_CONNECTION_PROFILE_FILE> -u admin -s <YOUR_ADMIN_ENROLLSECRET>
composer card import -f ca.card
rm ca.card
```
These 3 commands create a temporary card which you will use to request the admin identity certificates, import that card into the Hyperledger Composer card store and then remove the used card file.
Note the name of the card when it was imported. If you specified the name `bmx-hlfv1` as the name of your connection profile as shown in the template previously then the card name would be `admin@bmx-hlfv1`. We
will refer to this card name as `<TEMP_CARD_NAME>` in subsequent commands

```bash
composer identity request -c <TEMP_CARD_NAME>
```
This will download 3 files into the ``.identityCredentials`` directory under your home directory. The 2 files of interest are based on the enrollId. So in the above example there will be 2 files called **admin-pub.pem** and **admin-priv.pem**

We now delete that card from the card store as it will no longer be used.
```bash
composer card delete -n <TEMP_CARD_NAME>
```

3. Select **Members** from the navigation menu on the left panel, then select the **Certificates** menu option and click on the **Add Certificate** button.
4. Enter a unique name for this certificate (don’t use dashes in the name) in the **Name** field.
5. Open the file ``admin-pub.pem`` created earlier in your favourite editor and copy the contents of this file into the **Key** field and press the **Submit** button (note: you may have to move the cursor in order for the dialogue to recognise the certificate you have pasted in).
6. Please restart your peers using the next modal.
7. Once created it should appear in the list of certificates. Note that there is a arrow symbol. If you add more peers you should press this button to apply the certificates to newly added peers.

---

## Creating your channel.

1. Select **Channels** from the navigation menu on the left panel and click the **New Channel** button.
2. Enter a Channel Name (Ensure it matches the name you have specified in your connection profile for the channel attribute) and optional description and press **Next**.
3. Give permissions as required and press **Next**.
4. Select the policy of the number of Operators that need to accept Channel updates and submit Request.
5. You should now be taken to the **Notifications** section where there should be a new request to review. Click on the **Review Request** button.
6. Press the **Accept** button to accept and you will be taken back to the **Notifications** section where you can see the request can now be submitted. Press the **Submit Request** button to bring up the submission dialog and then Press the **Submit** button. Your new Channel has been created.
7. Select **Channels** from the navigation menu on the left panel and you will see your new channel in the list of channels and note that it say “No peers added yet”. Click on the actions menu next to it and select **Join Peers**. Check the check boxes next to the Peers you want to add and press **Add Selected**.
8. Now you are ready to complete the set up of the Hyperledger Composer environment to use this fabric channel.

---

## Importing a new identity to administer your Business Network Archive

Next we are going to create a card in Composer using the certificates requested previously. This new card will have the authority to install chaincode onto the peers that have your uploaded public certificate and will be an issuer for the certificate authorities.

To create and import the new card into the Composer card store, run the following commands:

```bash
composer card create -p <YOUR_CONNECTION_PROFILE_FILE> -u admin -c ~/.identityCredentials/admin-pub.pem -k ~/.identityCredentials/admin-priv.pem
```
Note the name of the card file created, it should be something like `admin@bmx-hlfv1.card` and we will refer to this file as `<HLFV1_CARD_FILE>`
```bash
composer card import -f <HLFV1_CARD_FILE>
```
Note the card name. It should be something like `admin@bmx-hlfv1` and we refer to this later with `<HLFV1_CARD_NAME>
Now we are ready to deploy your .bna file to the IBM Blockchain Platform.

---

## Deploying the Business Network Archive

Now you can deploy your .bna file to your IBM Blockchain Platform instance. An example of how to deploy is shown below. Replace `myNetwork.bna` with the name (and if necessary fully qualify it with a path) with your bna file you want to deploy.
```bash
composer network deploy -c <HLFV1_CARD_NAME> -a myNetwork.bna -A admin -C ~/.identityCredentials/admin-pub.pem -f delete_me.card
```
The command creates a card file called `delete_me.card`. This card is of no use so just delete it.

---

## Create a Business network card which can interaction on the deployed network

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

## Congratulations!

You should now have the ability to deploy Business Network Archive (.bna) files to your IBM Blockchain Platform Enterprise instance on IBM Cloud.
