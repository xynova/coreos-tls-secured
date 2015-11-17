# CoreOS secure cluster (made easy)
I really like the CoreOS's concept of providing a pattern for managing container hosts and trying to keep complexity down at the OS level. However, bootstrapping a cluster can become a tedious task, specially if you want to have your endpoints TLS secured.

The following is the way I have managed to automate that process to allow me to easily run and destroy a TLS secured cluster as many times as it is required, without shedding a tear.

## Preparing necessary files

### Building cfssl Binary

I am using [CloudFlare's PKI toolkit](https://cfssl.org/) to easily create all the necessary certificates
for secure communications.

 Let's jump into the **vagrant-builds** folder and build our binaries using Docker.
 
```shell
# Boot UP our boot2docker machine

cd vagrant-builds
vagrant up && vagrant ssh

```

Once we are logged into a session, we can salute the Whale and then proceed to run the **~/prep-ssl/build-cfssl.sh script**. This will fetch the cfssl source code, build the required binaries and automatically copy them back to our project under the **./cluster-files/bin** directory.

* NOTE: Do not do this on your mobile data plan as the build requires a golang docker image that is around 1GB in size.*

```shell
# Fetch cloudflare/cfssl and build it 
# If you have some pending reading or tweeting to do, this is a good 
# time to look into that because this will take a while.

cd ~ && ./prep-ssl/build-cfssl.sh

```

### Generating the Root CA

Within the same boot2docker session, we can execute the **~/prep-ssl/generate-ca.sh** to quickly create our Root CA certificates. These will be then used later on to automatically sign additional certificates for internal cluster TSL communications. 

These certificates will be automatically copied back to the host under the **./cluster-files/ssl** directory.

```shell
# Within the same vagrant session we execute the following
# ... too easy

cd ~ && ./prep-ssl/generate-ca.sh
```

* NOTE: You can customise the CA's fields by editing the **~/prep-ssl/ca-csr.json** certificate request file within the boot2docker session or at its source location **./cluster-files/ca-csr.json** in the project folder on the host.

##Initialise a CoreOS cluster

### Vagrant etcd cluster

The easiest way to start experimenting is by using the **vagrant-etcd** 3 machine cluster setup. Move into the vagrant-etc directory and boot the cluster UP. After all default machines come online, we can then ssh into one of them and do a sanity check by validating the cluster health with the **etcdctl cluster-health** command.


```shell
# Boot UP the vagrant cluster
cd vagrant-etcd
vagrant up

# SSH into one of the machines and check the cluster health
vagrant ssh etcd3
etcdctl --debug cluster-health

```

