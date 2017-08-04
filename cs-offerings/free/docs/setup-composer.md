# Setup Hyperledger Composer Playground

(This assumes that you have followed [Step 3 - Setup a blockchain network](./setup-blockchain.md).  If you have not yet done so, go back and do that now.)

Hyperledger Composer is a framework that aims to simplify the development of blockchain applications. Explore the 
[Composer docs](https://hyperledger.github.io/composer/introduction/introduction.html) for more information.  You can pursue one of three routes to setup your Composer playground.

## All in one
The simplest of the three approaches, the all in one script - ``create_all.sh`` - will call a series of scripts to ultimately bootstrap a blockchain network, join peers to a channel and launch the Composer playground.

Navigate to the `scripts` sub-directory:
```
cd cs-offerings/free/scripts
```
Now run the script:
```
./create_all.sh
```

## Script by script
Alternatively, you can use the following bash scripts to exercise each step incrementally.

While not required, you may wish to [understand the configurations](./setup-composer.md#1-understand-the-configurations) that each step is using prior to running the different scripts. Return to this section once you're done.

1. Launch the playground
```
./create/create_composer-playground.sh
```

2. Create and start the REST server
```
./create/create_composer-rest-server.sh
```

## Step by step
Finally, you have the option of passing in each configuration file to manually accomplish each step. If you choose to go this route, you should familiarize yourself with each individual yaml file. Use the the subsequent section to explore the configs.

## 1. Understand the configurations

Click on the following links for descriptions:
* [composer-playground.yaml](./descriptions/composer-playground-yaml.md)
* [composer-playground-services.yaml](./descriptions/composer-playground-services-yaml.md)
* [composer-rest-server.yaml](./descriptions/composer-rest-server-yaml.md)
* [composer-rest-server-services.yaml](./descriptions/composer-rest-server-services-yaml.md)

Now that you are familiar with the configurations above, use the following instructions to stand up a Hyperledger Composer playground and REST server.

## 2. Deploy the hyperledger composer services

Ensure you are in the `cs-offerings/free` sub-directory when executing the following commands.

First, create the Composer playground services. This provides the containers with the relevant DNS setup info, in turn allowing them to communicate amongst one another:
```
kubectl create -f kube-configs/composer-playground-services.yaml
```

## 3. Create Hyperledger Composer playground

Now create the Composer playground.
```
kubectl create -f kube-configs/composer-playground.yaml
```

## 4. Access the playground

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

Using the value of the `Public IP` (in this example 169.48.140.99) you can now access the Hyperledger Composer Playground at:
```
http://YOUR_PUBLIC_IP_HERE:31080
```

## 5. Start a Hyperledger Composer REST server

You can also deploy a Hyperledger Composer REST server after you have deployed a business network definition.

The file `kube-configs/composer-rest-server.yaml` is already set up to reflect the business network that you have deployed. 

Create the Composer REST server services:
```
kubectl create -f kube-configs/composer-rest-server-services.yaml
```

Create the Composer REST server:
```
kubectl create -f kube-configs/composer-rest-server.yaml
```

## 6. Access Hyperledger Composer REST Server

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

[Click here to go back to main instructions.](../README.md)
