#! /bin/bash

# Font
loadkeys pl
setfont Lat2-Terminus16.psfu.gz -m 8859-2


# Setup the disk and partitions
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart primary ext4 1MiB 300MiB #boot /dev/sda1
parted /dev/sda --script mkpart primary ext4 300MiB 100% #root /dev/sda2

#mkfs
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

#mount
mount /dev/sda2 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home

# Set up time
timedatectl set-ntp true

# Initate pacman keyring
<<com
pacman-key --init
pacman-key --populate archlinux
pacman-key --refresh-keys
com

# Install Arch Linux
pacstrap /mnt base linux pacman sudo

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Copy post-install system cinfiguration script to new /root
    wget https://raw.githubusercontent.com/tajo48/2/uefi/after.sh -O /mnt/root/after.sh
    chmod +x /mnt/root/after.sh

# Chroot into new system
arch-chroot /mnt /root/after.sh

