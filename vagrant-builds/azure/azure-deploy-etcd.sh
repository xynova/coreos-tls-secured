# Requires the .publishsettings file that can be downloaded from
# http://go.microsoft.com/fwlink/?LinkId=254432

cd /vagrant/azure && docker run -ti --rm \
-v $(ls | grep -i *publishsettings | sed -e "s|^|`pwd`/|g"):/tmp/credentials \
-v /mnt/cluster-files:/cluster-files \
-v /mnt/bootstrap-files:/bootstrap-files \
-v /vagrant/azure/scripts:/tmp/deploy \
microsoft/azure-cli /bin/bash -c "cat /tmp/credentials | tr -d '\015' > credentials; azure account import credentials;./tmp/deploy/etcd-infra.sh;./tmp/deploy/etcd-peers.sh"
