# CoreOS secure cluster (made easy)
Bootstrapping a CoreOS secure cluster can become a tedious task if not automated. The current project aggregates scripts that simplify this deployment process so that you can quickly get a cluster running and get on to more important problems.

## Preparing necessary files
I am using [CloudFlare's PKI toolkit](https://cfssl.org/) to generate certificates for TLS communications. The first thing we need to do is to build this tool directly from source using Docker. Flowingly, we will execute the output binaries to generate a cluster-wide trusted CA certificate that will be then used to automatically sign other TLS oriented certificates on cluster node creation.

### Building cfssl Binary

Let's jump into the **vagrant-builds** directory and spin up a Boot2docker machine using vagrant. 
 
```shell
# Boot UP our boot2docker machine

cd vagrant-builds
vagrant up && vagrant ssh

```

Once logged in, we proceed to run the **~/prep-ssl/build-cfssl.sh script**. This script will fetch the [**cfssl** source code](https://github.com/cloudflare/cfssl), build the required binaries and automatically copy them back to our project under the **./cluster-files/bin** directory.

* NOTE: Do not run this build while connected to a mobile data plan: the build requires a golang docker image that is around 1GB in size.

```shell
# Fetch cloudflare/cfssl and build it 
# If you have some pending reading or tweeting to do, this is a good 
# time to look into that because this will take a while.

cd ~ && ./prep-ssl/build-cfssl.sh

```


### Generating the Root CA

In the same Boot2docker session, we can execute the **~/prep-ssl/generate-ca.sh** to quickly create our Root CA certificates. These will be also automatically copied back to the host machine under the **./cluster-files/ssl** directory.

```shell
# Within the same vagrant session we execute the following

cd ~ && ./prep-ssl/generate-ca.sh
```

* NOTE: You can customise the CA's fields by editing either the **~/prep-ssl/ca-csr.json** certificate request file within the Boot2docker session or its by editing it at its source location **./cluster-files/ca-csr.json** in the project folder on the host.

##Initialise a CoreOS cluster

### Local Vagrant TLS etcd cluster

There is an already prepared 3 peer etcd cluster in the **vagrant-etc** project sub-directory. The number of peers can be increased by adding an additional ip address to the $instance_IPs variable. As usual with Vagrant, cd into the vagrant-etcd directory and execute a vagrant up command. After all machines come online, ssh into one of them (vagrant ssh etcd1) and do a cluster health check by executing the **etcdctl cluster-health** command. You should see responses comming back from https endpoints.

* NOTE for Windows users: you might have to install the vagrant-winnfsd plugin (NFS support for Windows hosts). Find this and other [available plugins here](https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Plugins).

```shell
# Boot UP the vagrant cluster
cd vagrant-etcd
vagrant up

# SSH into one of the machines and check the cluster health
vagrant ssh etcd3
etcdctl --debug cluster-health

```

### Azure Cloud TLS etcd cluster

