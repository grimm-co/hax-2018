#!/bin/bash

# install packages and enable them
apt-get update
apt-get install -y nfs-kernel-server docker.io git
update-rc.d docker enable
update-rc.d nfs-kernel-server enable

# install dockersh
git clone https://github.com/wumb0/dockersh
cd dockersh
./install.sh
cp dockersh.ini /etc/dockersh.ini

# create users for dockersh challenges
for i in netcatter escalator trap attrboy
do
    useradd $i -s $(which dockersh) -G docker
    echo "$i:$i" | chpasswd
done

# build netcatter
cd ../netcatter
docker build . -t netcatter

# build escalator, setup final escape on host
cd ../escalator
docker build . -t escalator
useradd escalator-3 -s /bin/bash -m --uid 5000
mkdir -p /srv/escalator-3
mount --bind /home/escalator-3 /srv/escalator-3
cp flag3.txt /flag3.txt
chmod 644 /flag3.txt
echo '/srv/escalator-3   172.17.0.0/16(rw,insecure,sync,no_subtree_check,no_root_squash)' > /etc/exports
service nfs-kernel-server restart

# build trap
cd ../trap
docker build . -t trap

cd ../attrboy
docker build . -t attrboy

cd ../
bash kill_old_containers.sh &disown
