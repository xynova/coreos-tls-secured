# Requires the .publishsettings file that can be downloaded from
# http://go.microsoft.com/fwlink/?LinkId=254432

cd /vagrant/azure && docker run -ti --rm \
-v $(ls | grep -i *publishsettings | sed -e "s|^|`pwd`/|g"):/credentials \
-v /mnt/cluster-files:/cluster-files \
-v /mnt/bootstrap-files:/bootstrap-files \
-v /vagrant/azure/scripts:/tmp/deploy \
microsoft/azure-cli /bin/bash -c "azure account import credentials;./tmp/deploy/etcd-destroy-all.sh"

