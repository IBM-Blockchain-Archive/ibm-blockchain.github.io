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

First, we will download and add the CLIs and plugins that we need to interact with the IBM Container Service.

### 1. Download and install kubectl CLI

[https://kubernetes.io/docs/tasks/kubectl/install/](https://kubernetes.io/docs/tasks/kubectl/install/)

### 2. Download and install the Bluemix CLI

[http://clis.ng.bluemix.net/ui/home.html](http://clis.ng.bluemix.net/ui/home.html)

### 3. Add the bluemix plugins repo

```bash
$ bx plugin repo-add bluemix https://plugins.ng.bluemix.net
```

Note: If you get the following error, it means that the repository bluemix already exists on your computer. Thus, you can ignore the error and move to the next step.

`Plug-in repo named ‘bluemix’ already exists. Try a different name.`

### 4. Add the container service plugin

```bash
$ bx plugin install container-service -r bluemix
```

## Setup a cluster

Now, we will use those CLIs and plugins to create a cluster on the IBM Container Service.  Use these steps to setup a cluster named ___blockchain___ on IBM Container Service. For more information about how to use the [bluemix cli](https://console.bluemix.net/docs/cli/reference/bluemix_cli/bx_cli.html#bluemix_cli).

### 5. Point Bluemix CLI to production API

```bash
$ bx api api.ng.bluemix.net
```

### 6. Login to bluemix

```bash
$ bx login
```

If your id is federated in an SSO, you will have to run the following command to login:
```bash
$ bx login -sso
```

### 7. Create a cluster on IBM Container Service

This will create a __paid cluster__ named _blockchain_ on the IBM Container Service. Please check the pricing details for more info.

```bash
$ bx cs cluster-create --name blockchain --machine-type u1c.2x4 --location dal12 --workers 3 --public-vlan <vlan-id> --private-vlan <vlan-id>

# to get list of locations
$ bx cs locations

# to get list of machine-types
$ bx cs machine-types <location>

# to get list of vlans in your account
$ bx cs vlans
```

### 8. Wait for the cluster to be ready

Issue the following command to ascertain the status of your cluster:
```bash
$ bx cs clusters
```

The process goes through the following lifecycle - ``requesting`` --> ``pending`` --> ``deploying`` --> ``normal``.  Initially you will see something similar to the following:
```bash
Name         ID                                 State       Created                    Workers
blockchain   7fb45431d9a54d2293bae421988b0080   deploying   2017-05-09T14:55:09+0000   0
```

Wait for the State to change to _normal_. Note that this can take upwards of 15-30 minutes. If it takes more than 30 minutes, there is an inner issue on the IBM Container Service.

You should see the following output when the cluster is ready:
```bash
$ bx cs clusters
OK
Name         ID                                 State    Created      Workers   Datacenter   Version
blockchain   a7b094596db34facb8587d256dc54cee   normal   3 days ago   3         dal12        1.7.4_1502
```

Use the following syntax to inspect on the status of the workers:
Command:
```bash
$ bx cs workers <cluster-name>
```

For example:
```bash
$ bx cs workers blockchain
```

The expected response is as follows:
```bash
$ bx cs workers blockchain
OK
ID                                                 Public IP       Private IP     Machine Type   State    Status   Version
kube-dal12-cra7b094596db34facb8587d256dc54cee-w1   169.47.67.177   10.184.9.157   u1c.2x4        normal   Ready    1.7.4_1502
kube-dal12-cra7b094596db34facb8587d256dc54cee-w2   169.47.67.162   10.184.9.173   u1c.2x4        normal   Ready    1.7.4_1502
kube-dal12-cra7b094596db34facb8587d256dc54cee-w3   169.47.67.178   10.184.9.161   u1c.2x4        normal   Ready    1.7.4_1502
```

### 9. Configure kubectl to use the cluster

Issue the following command to download the configuration for your cluster:
```bash
$ bx cs cluster-config blockchain
```

Expected output:

```bash
Downloading cluster config for blockchain
OK
The configuration for blockchain was downloaded successfully. Export environment variables to start using Kubernetes.

export KUBECONFIG=/home/*****/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal12-blockchain.yml
```

Use the export command printed as output above to point your kubectl cli to the cluster.  For example:

(Replace this example with the output from the step above!)
```bash
$ export KUBECONFIG=/home/*****/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal12-blockchain.yml
```

### 10. Adding Public IP addresses for services to be exposed outside

Order a new subnet using the following command:

```bash
# if not already initialized
$ bx sl init

# get list of public vlans in the datacenter that you created the cluster in
$ bx sl vlan list | grep PUBLIC | grep <datacenter>

# get detail about the vlan, vlan-id comes from previos command
$ bx sl vlan detail <vlan-id>

# find the vlan that the cluster was deployed in & order a new subnet on it
$ bx sl subnet create public 8 <vlan-id>
```

Now, add the subnet to be used by the cluster that you have created

```bash
$ bx cs cluster-subnet-add blockchain <subnet-id>

# if you forgot the subnet id
$ bx sl subnet list
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

<a href="/simple" class="button" >Next: Install</a>
