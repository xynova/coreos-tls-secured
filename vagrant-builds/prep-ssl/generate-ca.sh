#!/bin/bash

# Exit on error
set -e

cd ~/prep-ssl

# build cfssl binaries and copy outputs to the ssl folder
/mnt/cluster-files/bin/cfssl_linux-amd64 genkey -initca -config ca-config.json ca-csr.json \
    |  /mnt/cluster-files/bin/cfssljson_linux-amd64 -bare cluster-ca \
     && mv cluster-ca-key.pem  cluster-ca.csr  cluster-ca.pem /mnt/cluster-files/ssl/

