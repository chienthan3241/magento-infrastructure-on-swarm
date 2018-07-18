#1. change ssh config

rm /etc/ssh/sshd_config
cp /usr/share/ssh/sshd_config /etc/ssh/ssd_config
vi /etc/ssh/sshd_config
# Use most defaults for sshd configuration.
Subsystem sftp internal-sftp
ClientAliveInterval 180
UseDNS no
UsePAM yes
PrintLastLog no # handled by PAM
PrintMotd no # handled by PAM
PermitRootLogin no
AllowUsers core sh nsb kg    #<-do not forget yourself ;)
AuthenticationMethods publickey
#remove pre installed key
rm /root/.ssh/authorized_keys.d/coreos-ignition
#add users
useradd -G wheel sh
passwd sh
sudo systemctl daemon-reload
sudo systemctl restart sshd.socket
#add keys to users
vi /home/sh/.ssh/authorized_keys
#create new root partition on other drive
cgpt add -i 9 -l ROOT -t coreos-rootfs -b 4857856 -s 20971520 /dev/nvme1n1
mkfs.ext4 -L root /dev/nvme1n1p9
mount /dev/nvme1n1p9 /mnt/
#copy files of root and root only
cd /
tar -c --one-file-system -f - . | (cd /mnt/; tar -xvf -)
#make coreos choose the new partition
e2label /dev/nvme1n1p9 ROOT
e2label /dev/nvme0n1p9 root
#CHECK LOGIN IN ANOTHER TERMINAL BEFORE REBOOT! sudo ALSO! Dont forget core login is disabled now

#boot from other partition
reboot
#change partition layout, resize original roo and add lvm containers
cgpt add -i 9 -l ROOT -t coreos-rootfs -b 4857856 -s 20971520 /dev/nvme0n1
cgpt add -i 10 -l vg0disk0 -t linux-lvm -b 25829376 -s 853268556 /dev/nvme0n1
cgpt add -i 10 -l vg0disk1 -t linux-lvm -b 25829376 -s 853268556 /dev/nvme1n1
#add lvm2 service
systemctl enable lvm2-lvmetad.service
systemctl enable lvm2-lvmetad.socket
systemctl start lvm2-lvmetad.socket
systemctl start lvm2-lvmetad.socket
#reboot for partition changes to take effect, kpartx is not working
reboot
#copy root files back
mkfs.ext4 -L root /dev/nvme0n1p9
mount /dev/nvme0n1p9 /mnt/
cd /
tar -c --one-file-system -f - . | (cd /mnt/; tar -xvf -)
e2label /dev/nvme0n1p9 ROOT
e2label /dev/nvme1n1p9 root
#reboot from original drive
reboot
#create lvm volume group vg0
vgcreate vg0 /dev/disk/by-partlabel/vg0disk0 /dev/disk/by-partlabel/vg0disk1
#add logical volumes for swap on each physical drive for independant access
lvcreate vg0 -n swap0 -C y -L 20G /dev/nvme0n1p10
lvcreate vg0 -n swap1 -C y -L 20G /dev/nvme1n1p10
#create logical volume for data 
lvcreate --stripes 2 vg0 -n data -L 500G

#encrypt data
cryptsetup -y luksFormat --type LUKS2 /dev/mapper/vg0-data  # type YES, not yes

thisIstheGermantomDATApasswordnobodyelseknows

cryptsetup open --allow-discards /dev/mapper/vg0-data vg0-data-decrypted

#encrypt swap (encrypted data is useless without enrypted swap
#twice for 0 and 1!!
cryptsetup -y luksFormat --type LUKS2 /dev/mapper/vg0-swap0
cryptsetup open --allow-discards /dev/mapper/vg0-swap0 vg0-swap0-decrypted
mkswap /dev/mapper/vg0-swap0-decrypted
swapon -d -p0 /dev/mapper/vg0-swap0-decrypted
#format data and move docker
mkfs.ext4 -L data  -b 4096 -E stride=2 -E stride-width=1024 -E discard -v /dev/mapper/vg0-data-decrypted
mkdir /data
mount /dev/mapper/vg0-data-decrypted /data 
mkdir /data/docker
systemctl stop docker
systemctl disable docker

mv /var/lib/docker/* /data/docker/              #if docker was never started before, it gives an error, ignore it
rm -rf /var/lib/docker/
ln -s /data/docker /var/lib/docker
systemctl start docker
#check docker is working in the right dir:
ls /data/docker/

#done



#tasks for each reboot:

cryptsetup open --allow-discards /dev/mapper/vg0-data vg0-data-decrypted
mount /dev/mapper/vg0-data-decrypted /data
cryptsetup open --allow-discards /dev/mapper/vg0-swap0 vg0-swap0-decrypted
cryptsetup open --allow-discards /dev/mapper/vg0-swap1 vg0-swap1-decrypted
swapon -d -p0 /dev/mapper/vg0-swap0-decrypted
swapon -d -p0 /dev/mapper/vg0-swap1-decrypted
systemctl start docker

