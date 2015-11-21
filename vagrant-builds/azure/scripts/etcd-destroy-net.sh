scriptdir=$(cd "$(dirname $0)"; pwd)
source ${scriptdir}/etcd.conf

# Prepare metadata
storagename=${CLOUD_SERVICE}store


# Get all machines in cloud service and delete them
for vm in $(azure vm list --json | grep "$CLOUD_SERVICE.cloudapp.net" -A 10 | grep VMName | cut -d'"' -f 4); do 
  azure vm delete --blob-delete --quiet $vm
done;

# Delete cloud service
azure service delete --serviceName $CLOUD_SERVICE --quiet

# Delete storage
azure storage account delete --quiet $storagename

# Delete virtual network


