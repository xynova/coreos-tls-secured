# CoreOS secure cluster (made easy)
I really like the CoreOS's concept of providing a pattern for managing container hosts. 



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

Once we are logged into a session, we can salute the Whale and then proceed to run the **~/build-cfssl.sh script**. This will fetch the cfssl source code, build the binaries and copy them back to our project under the **./cluster-files/bin** directory.

* NOTE: Do not do this on your mobile data plan as the build requires a golang docker image that is around 1GB in size.*

```shell
# Fetch cloudflare/cfssl and build it 
# If you have some pending reading or tweeting to do, this is a good 
# time to look into that because this will take a while.

./build-cfssl.sh

```

### Generating the Root CA

Once the build process finishes creating all the binaries, we can exit the vagrant session and move back to our project directory. From here we can the execute **./cluster-files/gen-ca.sh** script to generate a Root CA certificate that will be later used to sign Server certificates for internal TSL cluster communications. 

```shell
# Exit the vagrant session 
# jump to the project directory
# and use cfssl to build the Root CA

cd ..
./cluster-files/gen-ca.sh
```

* NOTE: You can customise the CA's fields by editing the **cluster-files/ca-csr.json** configuration file.*

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

