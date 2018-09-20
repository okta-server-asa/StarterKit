#! /bin/bash

echo "Add an enrollment token"

sudo mkdir -p /var/lib/sftd

# get enrollment token from app.scaleft.com
echo "${enrollment_token}" | sudo tee /var/lib/sftd/enrollment.token

# enter an altname for the server
echo "Add a basic sftd configuration"
sudo mkdir -p /etc/sft/
sftcfg=$(cat <<EOF
---
AltNames: ["${name}"]
EOF
)
echo -e "$sftcfg" | sudo tee /etc/sft/sftd.yaml

export DEBIAN_FRONTEND=noninteractive

echo "Add the ScaleFT apt repo to your /etc/apt/sources.list system config file"
echo "deb https://pkg.scaleft.com/deb linux main" | sudo tee -a /etc/apt/sources.list

echo "Trust the repository signing key"
curl -C - https://dist.scaleft.com/pki/scaleft_deb_key.asc | sudo apt-key add -

echo "Retrieve information about new packages"
sudo apt-get update

echo "Install sftd"
sudo apt-get install scaleft-server-tools