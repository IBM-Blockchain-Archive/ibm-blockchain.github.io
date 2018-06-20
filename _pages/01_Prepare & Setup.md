---
layout: default
title:  1. Prepare & Setup
permalink: "/setup/"
category: tutorial
order: 2
---

# Prepare & Setup

* * *

Before deploying the IBM Blockchain Developer Environment, you must first prepare a basic cluster on the IBM Container Service.

## Prepare required CLIs and plugins

First, we will download and add the CLIs and plugins that we need to interact with the IBM Container Service. If you do not already have `zip` and `unzip`, install them now.

### 1. Download and install Hyperledger Composer CLI

Download and install the Hyperledger Composer CLI using the following command:

```bash
npm install -g composer-cli
```

### 2. Download and install the IBM Cloud CLI

[https://console.bluemix.net/docs/cli/](https://console.bluemix.net/docs/cli/)

## Setup a cluster

Now, we will use those CLIs and plugins to create a cluster on the IBM Container Service.  Use these steps to setup a cluster named ___blockchain___ on IBM Container Service. For more information about how to use the [ibmcloud cli](https://console.bluemix.net/docs/cli/reference/bluemix_cli/bx_cli.html#bluemix_cli).

### 3. Point IBM Cloud CLI to production API

```bash
$ ibmcloud api api.ng.bluemix.net
```

### 4. Login to IBM Cloud

```bash
$ ibmcloud login
```

If your id is federated in an SSO, you will have to run the following command to login:
```bash
$ ibmcloud login -sso
```

### 5. Create a cluster on IBM Container Service

This will create a __free cluster__ named _blockchain_ on the IBM Container Service.
```bash
$ ibmcloud cs cluster-create --name blockchain
```

### 6. Wait for the cluster to be ready

Issue the following command to ascertain the status of your cluster:
```bash
$ ibmcloud cs clusters
```

The process goes through the following lifecycle - ``requesting`` --> ``pending`` --> ``deploying`` --> ``normal``.  Initially you will see something similar to the following:
```bash
Name         ID                                 State       Created                    Workers
blockchain   7fb45431d9a54d2293bae421988b0080   deploying   2017-05-09T14:55:09+0000   0
```

Wait for the State to change to _normal_. Note that this can take upwards of 15-30 minutes. If it takes more than 30 minutes, there is an inner issue on the IBM Container Service.

You should see the following output when the cluster is ready:
```bash
$ ibmcloud cs clusters
Listing clusters...
OK
Name         ID                                 State    Created                    Workers
blockchain   0783c15e421749a59e2f5b7efdd351d1   normal   2017-05-09T16:13:11+0000   1

```

Use the following syntax to inspect on the status of the workers:
Command:
```bash
$ ibmcloud cs workers <cluster-name>
```

For example:
```bash
$ ibmcloud cs workers blockchain
```

The expected response is as follows:
```bash
$ ibmcloud cs workers blockchain
Listing cluster workers...
OK
ID                                                 Public IP       Private IP       Machine Type   State    Status
kube-dal10-pa0783c15e421749a59e2f5b7efdd351d1-w1   169.48.140.48   10.176.190.176   free           normal   Ready
```

### 7. Configure kubectl to use the cluster

Issue the following command to download the configuration for your cluster:
```bash
$ ibmcloud cs cluster-config blockchain
```

Expected output:

```bash
Downloading cluster config for blockchain
OK
The configuration for blockchain was downloaded successfully. Export environment variables to start using Kubernetes.

export KUBECONFIG=/home/*****/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal10-blockchain.yml
```

The `export` command in the output must be run as a separate command along with the `KUBECONFIG` information that followed it.

(Replace this example with the output from running the step above!)
```bash
$ export KUBECONFIG=/home/*****/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal10-blockchain.yml
```


* * *

### Helpful commands for kubectl

```bash
# To get the logs of a component, use -f to follow the logs
kubectl logs $(kubectl get pods | grep <component> | awk '{print $1}')
# Example
kubectl logs $(kubectl get pods | grep org1peer1 | awk '{print $1}')

# To get into a running container
kubectl exec -ti $(kubectl get pods | grep <component> | awk '{print $1}') bash
# Example
kubectl exec -ti $(kubectl get pods | grep ordererca | awk '{print $1}') bash

# To get kubernetes UI
kubectl proxy

# On the browser go to 127.0.0.1:8001/ui
```

* * *

## Congratulations!
You have successfully created the blockchain cluster on IBM Container Service.  Next, you will deploy the Developer Environment.  Most users will want to follow the **Simple Install** instructions (Advanced and Reference are there for those who want to e.g. only set up part of the environment).

<a href="/simple" class="button" >Next: Install</a>
