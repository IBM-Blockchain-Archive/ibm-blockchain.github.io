# Create a cluster on IBM Container Service

(This assumes that you have followed [Step 1 - Installing the command line tools](./cli-installation.md) on the [Main Instructions](../README.md) page.  If you have not yet done so, go back and do that now.)


Use these steps to setup a cluster named ___blockchain___ on IBM Container Service.

## 1. Point Bluemix CLI to production API

```bash
# Point to bluemix
bx api api.ng.bluemix.net
```

## 2. Login to bluemix

```bash
# Login to Bluemix
bx login
```

If your id is federated in an SSO, you will have to run the following command to login:
```bash
bx login -sso
```

## 3. Create a cluster on IBM Container Service

This will create a __free cluster__ named _blockchain_ on the IBM Container Service.
```bash
bx cs cluster-create --name blockchain
```

## 4. Wait for the cluster to be ready

Issue the following command to ascertain the status of your cluster:
```bash
bx cs clusters
```

The process goes through the following lifecycle - ``requesting`` --> ``pending`` --> ``deploying`` --> ``normal``.  Initially you will see something similar to the following:
```
Name         ID                                 State       Created                    Workers
blockchain   7fb45431d9a54d2293bae421988b0080   deploying   2017-05-09T14:55:09+0000   0
```

Wait for the State to change to _normal_. Note that this can take upwards of 15-30 minutes. If it takes more than 30 minutes, there is an inner issue on the IBM Container Service.

You should see the following output when the cluster is ready:
```
$ bx cs clusters
Listing clusters...
OK
Name         ID                                 State    Created                    Workers
blockchain   0783c15e421749a59e2f5b7efdd351d1   normal   2017-05-09T16:13:11+0000   1

```

Use the following syntax to inspect on the status of the workers:
Command:
```bash
bx cs workers <cluster-name>
```

For example:
```bash
bx cs workers blockchain
```

The expected response is as follows:
```
$ bx cs workers blockchain
Listing cluster workers...
OK
ID                                                 Public IP       Private IP       Machine Type   State    Status
kube-dal10-pa0783c15e421749a59e2f5b7efdd351d1-w1   169.48.140.48   10.176.190.176   free           normal   Ready
```

## 5. Configure kubectl to use the cluster

Issue the following command to download the configuration for your cluster:
```bash
#bx cs cluster-config <cluster-name>
bx cs cluster-config blockchain
```

Expected output:

```
Downloading cluster config for blockchain
OK
The configuration for blockchain was downloaded successfully. Export environment variables to start using Kubernetes.

export KUBECONFIG=/home/*****/.bluemix/plugins/container-service/clusters/blockchain/kube-config-prod-dal10-blockchain.yml
```

## 6. Configure kubectl to use the cluster

Use the export command printed as output in [step 5](./create-cluster.md#5) to point your kubectl cli to the cluster.

_Note_: If you are on windows, you should use `set` in place of `export`. If the scripts run in a different terminal or git bash, you should start git-bash and use the export command.

## Congratulations!
You have successfully created the blockchain cluster on IBM Container Service.

[Click here to go back to main instructions.](../README.md)
