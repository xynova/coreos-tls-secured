scriptdir=$(cd "$(dirname $0)"; pwd)
source ${scriptdir}/etcd.conf

# CLOUD SERVICE AND VMS
# ------------------------>

# Create etcd cloud service 
azure service create --serviceName $CLOUD_SERVICE --location "$LOCATION"

# Prepare metadata
storagename=${CLOUD_SERVICE}store
storagekey=$(azure storage account keys list etcdsydstore | grep -i Primary | cut -d':' -f3 | sed -e 's# ##')
storagepath=`echo $(azure storage account show $storagename --json | grep ${storagename}.file | cut -d'"' -f2)"cluster-files" | sed -e 's#https:##'`
blobpath=$(azure storage account show $storagename --json | grep ${storagename}.blob | cut -d'"' -f2)"vhd"
initialcluster=$(./bootstrap-files/to-initial-cluster.sh -n $VM_PREFIX ${VM_IPS[@]})
cat /bootstrap-files/etcd-template.yaml /bootstrap-files/etcd-template-azure-xtn.yaml > /tmp/etcd-template.yaml

# Create virtual machines (enabling ssh but deleting public endpoint)
for i in `seq ${#VM_IPS[@]}`; do 
  membername="$VM_PREFIX$i"
  replaceexpr="s#<MEMBER-NAME>#$membername#;s#<INITIAL-CLUSTER>#$initialcluster#;s#<STORAGEACC>#$storagename#;s#<STORAGEKEY>#$storagekey#;s#<STORAGEPATH>#$storagepath#;"
  sed -e $replaceexpr /tmp/etcd-template.yaml > "/tmp/${membername}-config.yaml"
  
  azure vm create --vm-name=$membername --blob-url="$blobpath/$membername.vhd" --static-ip="${VM_IPS[i-1]}" \
    --userName=$VM_USER --password=$VM_PASSWORD --virtual-network-name=$VNET --connect=$CLOUD_SERVICE \
    --custom-data "/tmp/${membername}-config.yaml" \
    --vm-size=Basic_A0 --ssh "1001$i" $VM_IMAGE \
  && azure vm endpoint delete $membername ssh; 
done;


