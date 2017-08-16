---
layout: default
title:  HSBN Production Deployment
permalink: "/hsbn-deployment/"
category: hsbn
order: 1
---

# Deploying Hyperledger Composer Business Network to HSBN v1 Beta on Bluemix
This guide will help you deploy your Hyperledger Composer Business Network to an HSBN v1 Beta. It will show you how you can deploy your business network archive (.bna) file to the HSBN v1 Beta.

> ### Note
> These directions are applicable for the current version of Hyperledger Fabric (v1.0.1) supported by HSBN v1 and that this is subject to change.
> To develop your business network archive please refer to the [Developing Business Networks](https://hyperledger.github.io/composer/business-network/business-network-index.html) documentation.

## Requirements
You will need to install the Composer Development Environment or work with Composer Playground to create the required business network archive (.bna) file. You can read about installation here: [Installing Hyperledger Composer](https://hyperledger.github.io/composer/installing/installing-index.html).
You will also need access to a Bluemix HSBN V1 Service. You can register for an account at Bluemix.net and you can create a service via the [Bluemix Blockchain Service](https://console.ng.bluemix.net/catalog/services/blockchain?env_id=ibm:yp:us-south).
You will need to create a channel and at least one peer.
Note:  If you have been working with a local instance of HLFV1, then you may have existing credentials for users like admin or PeerAdmin in your ``homedir/.composer-credentials`` directory. I highly recommend pointing to a different directory for your Bluemix HSBN credentials to avoid confusion (e.g. ``.composer-credentials-hsbn-mychannel``) to ensure that you are using the Bluemix HLFV1 credentials versus your local credentials later.

---

## Creating a connection.json file for Bluemix HSBN v1
If you have been working with Composer and fabric locally, you have likely run the steps documented as [Installing a development environment](https://hyperledger.github.io/composer/installing/development-tools.html) in Step 2 of those instructions you should have created a ``fabric-tools`` directory and created a composer connection profile. For example if you are developing on a Mac, you will likely find the directory under
 ``/Users/myUserId/.composer-connection-profiles/hlfv1.``
Each connection profile should contain a ``connection.json`` file. For Bluemix, create a new directory under the ``.composer-connection-profiles``, e.g. (bmx-hlfv1). This will be the name of the profile that you will use when working with Hyperledger composer and your HSBN service.
```bash
mkdir -p ~/.composer-connection-profiles/bmx-hlfv1
cd ~/.composer-connection-profiles/bmx-hlfv1
```
You should now have a directory structure which looks like ``/Users/myUserId/.composer-connection-profiles/bmx-hlfv1``
Create a file in the newly created directory using your favorite editor and name it connection.json.
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
    "keyValStore": "/Users/jeff/.composer-credentials-mychannel-hsbn",
    "channel": "mychannel",
    "mspID": "PeerOrg1",
    "globalCert": "-----BEGIN CERTIFICATE-----\r\n...LotsOfStuff\r\n-----END CERTIFICATE-----\r\n-----BEGIN CERTIFICATE-----\r\nMorestuff\r\n-----END CERTIFICATE-----\r\n",
    "timeout: 300
}
```
You will populate the newly created connection.json file with attributes that are provided via your Bluemix HSBN v1 dashboard. From your HSBN v1 dashboard on Bluemix, select **Overview** from the navigation menu on the left panel. Then click on the **Service Credentials** button to display the endpoint and certificate information for the members of the channel where you want to deploy your business network archive.

### Orderers
Now we can start to modify the template with the information provided by the Service Credentials, starting with the orderers. While you have multiple orderers in your Service Credentials only one is required for your ``connection.json`` file replace the orderer url values in the template:
```
url”: “grpcs://abca.4.secure.blockchain.ibm.com:12345
```
With the “url” value for the first orderer found in your service credentials. The modified value should look similar to:
```
grpcs://ldn3-abc2b.2.secure.blockchain.ibm.com:53105
```
### CA (Certificate Authority)
Modify the ca value in your ``connection.json`` with both the **url** and the **caName** from either of the entries in the **certificateAuthorities** section.

### Peers
Now we need to set the url for each Peer **requestURL** and **eventURL**. Modify the connection.json file and replace the **url** attribute with the **url** value found in your Service Credentials. Replace the **eventURL** attribute with the **eventUrl** found in your Service Credentials. After making the changes it should look similar to this, although your ports and host address should be different:
```bash
"peers": [
  {
      "requestURL": "grpcs://ldn0-abc3a.2.secure.blockchain.ibm.com:53411",
      "eventURL": "grpcs://ldn1-abc3a.2.secure.blockchain.ibm.com:53410"
```
### keyValStore
Next we need to set the keyValStore attribute to point to the appropriate directory. This directory should be different than the ``.composer-credentials`` directory that was set up for a local composer-connection profile. For example you could create a new directory under your home directory called ``.composer-credentials-mychannel-hsbn``. Make sure the KeyValStore attribute points to your newly created directory.
```bash
"keyValStore": "/Users/myUserId/.composer-credentials-mychannel-hsbn",
```
### Channel
Modify the channel value in the connection.json to match the name of the channel which you plan to create and deploy your business network to.

### mspID
The mspID value in your connection.json file should be set to the mspID or your organization. The service credentials provide a list of the organizations with their associated msp id’s and peers. You should use the value from the **mspid** attribute from your organization.

### globalCert
Currently HSBN uses a common tls certificate for the orderers and peers. For each orderer and peer there is a **tlsCACerts** attribute which all contain the same certificate. Replace the dummy value in the connection.json file template with the **tlsCACerts** value. It should look like this:
```bash
"globalCert": "-----BEGIN CERTIFICATE-----\r\.......
```

---

## Preparing your peers by uploading certificate to provide administrative authority.

> ### Important
> You **must** perform this step first before creating your channel. Failure to do so will mean you won’t be able to start the business network.

1. The first step is to request certificates for an identity that is a member of your Membership Service Provider (msp). in your service credentials document under **certificateAuthorities** should be an attribute **registrar** containing attributes for **enrollId** and **enrollSecret**. For example:
```
"registrar": [
    {
        "affiliation": "org1",
        "enrollId": "admin",
        "enrollSecret": "CC9CA1CDDA"
    }
],
```
2. To request the certificates you would issue the following command
```
composer identity request -p bmx-hlfv1 -i admin -s CC9CA1CDDA
```
This will download 3 files into the **.identityCredentials** directory under your home directory. The 2 files of interest are based on the enrollId. So in the above example there will be 2 files called **admin-pub.pem** and **admin-priv.pem**
3. Select **Members** from the navigation menu on the left panel, then select the **Certificates** menu option and click on the **Add Certificate** button
4. Enter a unique name for this certificate (don’t use dashes in the name) in the **Name** field
5. Open the file admin-pub.pem created earlier in your favourite editor and copy the contents of this file into the **Key** field and press the **Submit** button.
6. Once created it should appear in the list of certificates. Note that there is a arrow symbol. If you add more peers you press this button apply the certificates to newly added peers.

---

## Creating your channel.

1. Select **Channels** from the navigation menu on the left panel and click the ***New Channel*** button
2. Enter a Channel Name (Ensure it matches the name you have specified in your connection profile for the channel attribute) and optional description and press **Next**.
3. Give permissions as required and press **Next**.
4. Select the policy of the number of Operators that need to accept Channel updates and submit Request.
5. You should now be taken to the **Notifications** section where there should be a new request to review. Click on the **Review Request** button.
6. Press the **Accept** button to accept and you will be taken back to the **Notifications** section where you can see the request can now be submitted. Press the **Submit Request** button to bring up the submission dialog and then Press the **Submit** button. Your new Channel has been created.
7. Select **Channels** from the navigation menu on the left panel and you will see your new channel in the list of channels and note that it say “No peers added yet”. Click on the Actions menu next to it (the 3 vertical dots as that obviously means it is a menu....) and select **Join Peers**. Check the check boxes next to the Peers you want to add and press **Add Selected**.
8. Now you are ready to complete the set up of the Hyperledger Composer environment to use this fabric channel.

---

## Importing in a new identity to Administer your Business Network Archive

Now we are going to create an identity in composer using the certificates requested previously. This identity not only has authority now to install chaincode onto the peers you have uploaded the public certificate to but will also have issuer authority for the certificate authorities.
To create the new id, run the following command:
```bash
composer identity import -p bmx-hlfv1 -u admin -c ~/.identityCredentials/admin-pub.pem -k ~/.identityCredentials/admin-priv.pem
```
Where ``bmx-hlfv1`` is the name of the composer connection profile that you previously created. Now we are ready to deploy your .bna file to HSBN.

---

## Deploying the Business Network Archive

Now you can deploy your .bna file to your Bluemix HSBN instance. Simply point to the appropriate connection profile using the newly created admin id (e.g. testAdmin)
```bash
composer network deploy -a myNetwork.bna -p bmx-hlfv1 -i admin -s anyString -p bmx-hlfv1
```
