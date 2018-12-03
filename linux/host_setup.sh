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
    useradd $i -s $(which bash) -G docker
    echo "$i:$i" | chpasswd
done

# force shell to dockersh for created users
cat << EOF >> /etc/ssh/sshd_config
Match User attrboy,escalator,netcatter,trap
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand /usr/local/bin/dockersh
EOF

# stop users from switching user
chmod go-x $(which su)

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

# build attrboy
cd ../attrboy
docker build . -t attrboy

# setup godeep
useradd godeep -s /bin/bash -m
echo "godeep:godeep" | chpasswd
pushd /home/godeep
for i in {1..250}; do mkdir -p $i;cd $i; mktemp ./XXXXXXX.txt 2>/dev/null;cp -r ../ . 2>/dev/null;done
popd
cp godeep/flag.txt /home/godeep/1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/16/17/18/19/20/21/22/23/24/25/26/27/28/29/30/31/32/33/34/35/36/37/38/39/40/41/42/43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74/75/76/77/78/79/80/81/82/83/84/85/86/87/88/89/90/91/92/93/94/95/96/97/98/99/100/101/102/103/104/105/106/107/108/109/110/111/112/113/114/115/116/117/118/119/120/121/122/123/124/125/126/127/128/129/130/131/132/133/134/135/136/137/138/139/140/141/142/143/144/145/146/147/148/149/150/151/152/153/154/155/156/157/158/159/160/161/162/163/164/165/166/167/168/169/170/171/172/173/174/175/176/177/178/143/Xd73dew.txt
find /home/godeep/1 -type f -exec chmod 644 {} + && find /home/godeep/1 -type d -exec chmod 755 {} +

# start container killer
cd ../
bash kill_old_containers.sh &disown
