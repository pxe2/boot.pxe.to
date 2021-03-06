#!/bin/bash

ACTIVE_INTERFACE=`/usr/bin/ip route get 1 | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f5`
NEWHOSTNAME=`/usr/bin/ifconfig $ACTIVE_INTERFACE | /usr/bin/grep "ether" | /usr/bin/tr -s " " | /usr/bin/cut -d " " -f3 | /usr/bin/sed -e "s/://g;"`



echo $ACTIVE_INTERFACE
echo $NEWHOSTNAME

sudo hostname -s $NEWHOSTNAME
sudo hostnamectl set-hostname $NEWHOSTNAME

# Download cloud-config

curl -O http://i.pxe.to/cloud-config.yml/coreos-stable-amd64.cloud-config.yml
sed -i "/hostname: coreos/c\hostname: $NEWHOSTNAME" ./coreos-stable-amd64.cloud-config.yml
# apply cloud config
sudo coreos-cloudinit -validate --from-file ./coreos-stable-amd64.cloud-config.yml
sudo coreos-cloudinit --from-file ./coreos-stable-amd64.cloud-config.yml


