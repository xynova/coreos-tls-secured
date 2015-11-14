#!/bin/bash

# Exit on error
set -e

# jump to the work directory
dir=`dirname $0`
cd $dir

# select the right binaries
cfssl=$(ls bin | grep -i "cfssl_`uname -s`-amd64" | awk '{print "bin/"$1}')
cfssljson=$(ls bin | grep -i "cfssljson_`uname -s`-amd64" | awk '{print "bin/"$1}')

# build cfssl binaries and copy outputs to the ssl folder
/bin/bash -c "$cfssl genkey -initca -config ca-config.json ca-csr.json" \
    | /bin/bash -c "$cfssljson -bare cluster-ca" \
     && mv cluster-ca-key.pem  cluster-ca.csr  cluster-ca.pem ssl/

