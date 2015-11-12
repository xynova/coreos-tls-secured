#!/bin/bash

# Exit on error
set -e

# Move to the work directory
dir=`dirname $0`
cd $dir

# Copies trusted CA
cp ssl/cluster-ca.pem /etc/ssl/certs/

# Generate ssl cert for this node
echo '{"CN":"<HOSTNAME>","hosts":["<PUBLIP>","<PRIVIP>","<HOSTNAME>"],"key":{"algo":"rsa","size":2048}}' \
| sed -e "s#<HOSTNAME>#$hostname#g;s#<PUBLIP>#$1#g;s#<PRIVIP>#$2#g" \
| bin/cfssl_linux-amd64 gencert \
    -ca=ssl/cluster-ca.pem -ca-key=ssl/cluster-ca-key.pem \
    -config=ca-config.json -profile=server  - \
| bin/cfssljson_linux-amd64 -bare `hostname`-server \
&& mv `hostname`-server* ssl/

# Copies generated ssl certs
mkdir -p /etc/ssl/etcd && cd /mnt/cluster-files/ssl \
&& cp `hostname`-server.pem /etc/ssl/etcd/server.pem \
&& cp `hostname`-server-key.pem /etc/ssl/etcd/server-key.pem

# Change permissions to cert files
cd /etc/ssl/etcd && chown -R root:etcd . && chmod 0640 server-key.pem 

# Update certificates
update-ca-certificates

