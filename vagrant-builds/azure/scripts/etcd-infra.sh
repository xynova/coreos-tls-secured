scriptdir=$(cd "$(dirname $0)"; pwd)
source ${scriptdir}/etcd.conf

# VIRTUAL NETWORK
# ------------------------>

# Create Virtual Network
azure network vnet create --vnet $VNET --location "$LOCATION" --cidr 22 --address-space 10.0.20.0 \
  --subnet-name static --subnet-cidr 24 --subnet-start-ip 10.0.20.0 

# Fill in the address space with other subnet masks
azure network vnet subnet create --vnet-name $VNET --name dynamic1 --address-prefix 10.0.21.0/24
azure network vnet subnet create --vnet-name $VNET --name dynamic2 --address-prefix 10.0.22.0/24
azure network vnet subnet create --vnet-name $VNET --name dynamic3 --address-prefix 10.0.23.0/24


# STORAGE
# ------------------------>

# Create shared storage
storagename=${CLOUD_SERVICE}store
azure storage account create --type LRS --location "$LOCATION" $storagename
storageconnstr="$(azure storage account connectionstring show $storagename | grep -i $storagename | cut -d':' -f3 | sed -e 's/ //g')"

# Create vm blob container 
azure storage container create --connection-string $storageconnstr --container vhd

# Create and cluster-files file share
azure storage share create --share cluster-files --connection-string $storageconnstr
azure storage directory create --share cluster-files --connection-string $storageconnstr ssl
azure storage directory create --share cluster-files --connection-string $storageconnstr bin

# Copy /cluster-files into shared storage
for f in $(find /cluster-files -type f | grep -P -v "_darwin|_windows|-arm|-386|.keepme|multirootca|mkbundle"); do
  if [ -z $(echo $f | cut -d'/' -f4) ]; then
     azure storage file upload --share cluster-files --connection-string $storageconnstr $f;
  else
     azure storage file upload --share cluster-files --path $(echo $f | cut -d'/' -f3) --connection-string $storageconnstr $f;
  fi;
done;

