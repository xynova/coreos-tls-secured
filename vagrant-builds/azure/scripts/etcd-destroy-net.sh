scriptdir=$(cd "$(dirname $0)"; pwd)
source ${scriptdir}/etcd.conf

# Prepare metadata
storagename=${CLOUD_SERVICE}store

# Delete virtual network
azure network vnet delete --vnet $VNET

