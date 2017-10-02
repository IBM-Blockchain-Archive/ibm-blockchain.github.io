---
layout: default
title:  2. Simple Install
permalink: "/simple/"
category: tutorial
order: 3
---

# Simple Install
* * *

## Before you start
Make sure you have followed the instructions in **Prepare & Setup** - they are a prerequisite to any of the install instructions.

## Install with a single script

The Simple Install method is to use the all in one script - ``create_all.sh`` - which will call a series of scripts to ultimately bootstrap a blockchain network, join peers to a channel and launch the Composer playground.  You can then use Composer Playground to create and deploy Business Networks to your blockchain network.

### 1. Clone ibm-container-service repository
You'll be using the config files and scripts from this repository, so start by cloning it to a directory of your choice on your local machine.

```bash
git clone https://github.com/IBM-Blockchain/ibm-container-service
```

### 2. Run the script

Navigate to the ``scripts`` sub-directory:
```bash
cd cs-offerings/scripts
```

Now run the script:

* Option 1: To use __leveldb__ as worldstate db for peers:
  ```bash
  ./create_all.sh
  ```

* Option 2: To use __couchdb__ as worldstate db for peers:
  ```bash
  ./create_all.sh --with-couchdb
  ```

* * *

### Congratulations!

You have completed the install steps.  Next, refer to **Interacting with your Blockchain** to learn how development is done with IBM Blockchain Platform for Developers on IBM Container Service.

<a href="/interacting" class="button">Next: Develop</a>
