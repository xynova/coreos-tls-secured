# exit on any errors
set -e

# download cfssl source code
ls cfssl > /dev/null || git clone https://github.com/cloudflare/cfssl.git cfssl
ls cfssl/dist > /dev/null || mkdir cfssl/dist

# do the docker locomotion and copy the binaries to the shared folder
cd cfssl && ./script/build && cp dist/* /mnt/build-outputs/
