#! /bin/bash

echo "Add an enrollment token"
sudo mkdir -p /var/lib/sftd
echo "${enrollment_token}" | sudo tee /var/lib/sftd/enrollment.token

echo "Add a basic sftd configuration"
sudo mkdir -p /etc/sft/
sftcfg=$(cat <<EOF
---
# CanonicalName: Specifies the name clients should use/see when connecting to this host
CanonicalName:            "centos-target"
# AccessAddress lets us specify the static IP for connections to this host
AccessAddress:            "${public_ip}"
EOF
)

echo -e "$sftcfg" | sudo tee /etc/sft/sftd.yaml

echo "Add the ScaleFT yum repo"

sudo rpm --import https://dist.scaleft.com/pki/scaleft_rpm_key.asc

curl -C - https://pkg.scaleft.com/scaleft_yum.repo | sudo tee /etc/yum.repos.d/scaleft.repo

sudo yum install -y scaleft-server-tools-${sftd_version}

