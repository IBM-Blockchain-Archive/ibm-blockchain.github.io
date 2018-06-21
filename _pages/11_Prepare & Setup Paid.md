---
layout: default
title:  1. Prepare & Setup
permalink: "/paid/setup/"
category: paid
order: 1
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

This will create a __paid cluster__ named _blockchain_ on the IBM Container Service. Please check the pricing details for more info.

```bash
$ ibmcloud cs cluster-create --name blockchain --machine-type <type> --location <location> --workers <num-workers> --public-vlan <vlan-id> --private-vlan <vlan-id>

# to get list of locations
$ ibmcloud cs locations

# to get list of machine-types
$ ibmcloud cs machine-types <location>

# to get list of vlans in your account
$ ibmcloud cs vlans <location>
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
OK
Name         ID                                 State    Created      Workers   Datacenter   Version
blockchain   a7b094596db34facb8587d256dc54cee   normal   3 days ago   3         dal12        1.7.4_1502
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
OK
ID                                                 Public IP       Private IP     Machine Type   State    Status   Version
kube-dal12-cra7b094596db34facb8587d256dc54cee-w1   169.47.67.177   10.184.9.157   u1c.2x4        normal   Ready    1.7.4_1502
kube-dal12-cra7b094596db34facb8587d256dc54cee-w2   169.47.67.162   10.184.9.173   u1c.2x4        normal   Ready    1.7.4_1502
kube-dal12-cra7b094596db34facb8587d256dc54cee-w3   169.47.67.178   10.184.9.161   u1c.2x4        normal   Ready    1.7.4_1502
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

### 8. Adding Public IP addresses for services to be exposed outside

Order a new subnet using the following command:

```bash
# if not already initialized
$ ibmcloud sl init

# get list of public vlans in the datacenter that you created the cluster in
$ ibmcloud sl vlan list | grep PUBLIC | grep <datacenter>

# get detail about the vlan, vlan-id comes from previos command
$ ibmcloud sl vlan detail <vlan-id>

# find the vlan that the cluster was deployed in & order a new subnet on it
$ ibmcloud sl subnet create public 8 <vlan-id>
```

Now, add the subnet to be used by the cluster that you have created

```bash
$ ibmcloud cs cluster-subnet-add blockchain <subnet-id>

# if you forgot the subnet id
$ ibmcloud sl subnet list
````

Why is this step needed? As we are using more than 4 services, we exhaust the 4 public IPs that are created for us when we create a new cluster. Thus, in order
to expose all the services to the outside world, we need to add more public IPs. Note: Each public IP may incur cost, please refer to bluemix for prices.

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

<a href="../simple" class="button" >Next: Install</a>
