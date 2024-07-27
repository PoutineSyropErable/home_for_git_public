#working account: franck, pw 1234


loadkeys cf
timedatectl set-timezone Canada/Eastern



iwctl
>>station wlan0 get-networks
>>station wlan0 connect BELL374
>>Type Password
>>exit

ip addr show # Do you see an ip adress

systemctl status sshd # for ssh, make sure it's enabled (enable for boot, start for now). 

passwd
>>>1234 # Just for the internet


ip link
ping google.com

cat /sys/firmware/efi/fw_platform_size  # check boot in uefi

ls /usr/share/kbd/consolefonts | grep -i "ter" | less
setfont ter-132b # or 120n or something. 


fdisk -l
sudo fdisk /dev/sda #change to nvme something on ssd

#add a gpt partition type
Command (m for help): g


# create first partition: EFI System/Boot
command (m for help): n
Partition number (1-128, default 1): <Enter>
First sector (2048-..., default 2048): <Enter>
Last sector, +/-sectors or +/-size{K,M,G,T,P} (...-..., default ...): +512M



#change it's type to efi:
Command (m for help): t
Partition number (1-128): 1
Hex code or alias (type L to list all): 1 # 1 is efi


# create second partition - Swap/sw
Command (m for help): n
Partition number (2-128, default 2): <Enter>
First sector (..., default ...): <Enter>
Last sector, +/-sectors or +/-size{K,M,G,T,P} (...-..., default ...): +4G


#change it's type to linux swap
Command (m for help): t
Partition number (1-128): 2
Hex code or alias (type L to list all): 19





#create root partition
Command (m for help): n
Partition number (3-128, default 3): <Enter>
First sector (..., default ...): <Enter>
Last sector, +/-sectors or +/-size{K,M,G,T,P} (...-..., default ...): +12G


#change it's type to Linux File System (Not needed)
Command (m for help): t
Partition number (1-128): 3
Hex code or alias (type L to list all): 20




#--- Possible: Create a 4th partition for /home

#create home partition
Command (m for help): n
Partition number (3-128, default 4): <Enter>
First sector (..., default ...): <ENTER>
Last sector, +/-sectors or +/-size{K,M,G,T,P} (...-..., default ...): <Enter>


#change it's type to Linux File System (Not needed)
Command (m for help): t
Partition number (1-128): 4
Hex code or alias (type L to list all): 20


Command (m for help): w




##------------------------------------- format disks ----------------------

mkfs.fat -F 32 /dev/sda1 # Format root to UEFI compatible

mkswap /dev/sda2 #format swap

mkfs.ext4 /dev/sda3 #format root
mkfs.ext4 /dev/sda4 # format home



#------------------------ mounting partitions----------------------



mount /dev/nvme0n1p6 /mnt
mount --mkdir /dev/nvme0n1p9 /mnt/boot
swapon /dev/nvme0n1p8
mount --mkdir /dev/nvme0n1p7 /mnt/home



#----------------------- package time, Install necessary shit --------------------

pacstrap -K /mnt base linux linux-firmware sudo vim iwd dhcpcd grub efibootmgr alacritty networkmanager


#------------------------ internet -----------------------------
ip link set ens33 up #needed?
dhcpcd ens33         #needed?

ping -c 4 archlinux.org



sudo vim /etc/systemd/network/ens33.network
```
[Match]
Name=ens33

[Network]
DHCP=yes
```


Configure dhcpcd for ens33:
Edit the dhcpcd configuration file for your network interface (ens33 in your case):

bash
Copy code
sudo nano /etc/dhcpcd.conf
Add the following lines at the end of the file for DHCP configuration:

plaintext
Copy code
interface ens33

sudo systemctl disable systemd-networkd.service
sudo systemctl stop systemd-networkd.service



#----------------------- Make the parititoning and mounting stuff be always done at boot time ----------------
genfstab -U /mnt >> /mnt/etc/fstab


#--------------------- makes /mount the new root. Aka, this drive is the new root. 
arch-chroot /mnt

#this need different permissions?

pacman -S vim # install vim cause you don't it now. 




#-------------------------- etc, setting "files" that will be accessed by the os

ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime  # config

hwclock --systohc # generate /etc/adjtime using the config. It's a "file" used by the os to get the time


#------------------- locales and language stuff

vim /etc/locale.gen

uncomment en_US.UTF-8 UTF-8
uncomment en_CA.UTF-8 UTF-8
uncomment fr_CA.UTF-8 UTF-8
uncomment ca_FR.UTF-8 UTF-8

locale-gen

echo LANG=en_CA.UTF-8 > /etc/locale.conf #Set system language
echo KEYMAP=cf > /etc/vconsole.conf


###---------------- Set device name

echo "ArchBTW" > /etc/hostname  #It will appear on network as the name of the device, and terminals and stuff. 
#Here, I name my device ArchBTW


#---------set root password  --------------

passwd 
>>>enter pw: (1234)
>>>re-enter pw: 1234
#-- That's not my actual password lol
#----------- create user
useradd -m -G wheel -s /bin/bash francois
passwd francois
        1234
        1234


EDITOR=vim visudo
#Shift+G to go to the end
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL


#------------------ Grub setting

pacman -S grub efibootmgr #grub use efibootmgr


# If you forgot the info about what is mounted where
lsblk 
#or
df -h
#or
mount
#or


recreate the pn file in /home/francois




grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch_GRUB

grub-mkconfig -o /boot/grub/grub.cfg


refind-install

exit
jobs
exit
reboot
