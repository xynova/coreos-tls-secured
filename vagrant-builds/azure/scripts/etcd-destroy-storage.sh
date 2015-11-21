CLOUD_SERVICE=etcdsyd

# Prepare metadata
storagename=${CLOUD_SERVICE}store

# Delete storage
azure storage account delete --quiet $storagename


