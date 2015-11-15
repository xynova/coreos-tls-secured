#!/bin/bash

# Exit on error
set -e

# build cfssl binaries and copy outputs to the ssl folder
./mnt/build-outputs/cfssl_linux-amd64 genkey -initca -config ca-config.json ca-csr.json \
    |  ./mnt/build-outputs/cfssljson_linux-amd64 -bare cluster-ca \
     && mv cluster-ca-key.pem  cluster-ca.csr  cluster-ca.pem /mnt/ssl-outputs/

