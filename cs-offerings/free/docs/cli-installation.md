# Install CLIs

[Click here to go back to main instructions.](../README.md)

This document will take you through installation of Kubernetes CLI (kubectl) and Bluemix CLI (bx). It will also help you install the IBM Container Service plugin for Bluemix (bx cs).

## 1. Download and install kubectl cli

https://kubernetes.io/docs/tasks/kubectl/install/

## 2. Download and install the Bluemix cli

http://clis.ng.bluemix.net/ui/home.html

## 3. Add the bluemix plugins repo

```
bx plugin repo-add bluemix https://plugins.ng.bluemix.net
```

## 4. Add the container service plugin

```
bx plugin install container-service -r bluemix
```

## Congratulations!
You have successfully installed the required CLIs on your machine.

[Click here to go back to main instructions.](../README.md)
