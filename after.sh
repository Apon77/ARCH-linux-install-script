#! /bin/bash

#programs
pacman -S --noconfirm alsa-utils netctl grub os-prober mtools dialog wpa_supplicant dhcpcd vim git make alsa-firmware wget xorg-server pulseaudio xorg-xinit curl tar libxft ranger fakeroot binutils patch pkgconf base-devel
#obs-studio

# Set date time
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
echo "en_US.UTF-8 UTF-8
pl_PL.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
locale-gen

# Set hostname
echo "ARCH" >> /etc/hostname
echo "
127.0.0.1	localhost
::1		localhost
127.0.1.1	ARCH" >> /etc/hosts

# Set root passwd
echo -en "root\nroot" | passwd

# Useradd,internet and sudo 
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers
systemctl enable dhcpcd
useradd -m tajo48
echo -en "pass\npass" | passwd tajo48
usermod -aG wheel,audio,video,optical,storage,users tajo48

# Install bootloader
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

<<testi3
#i3 wm
pacman -S --noconfirm i3-gaps feh firefox rxvt-unicode rofi neofetch termite
echo "feh --bg-fill /home/tajo48/photos/wallpaper.jpg
setxkbmap -layout 'pl'
exec dwm" >> ~/.xinitrc
mkdir /home/tajo48/photos
cd /home/tajo48/photos
wget https://raw.githubusercontent.com/tajo48/2/master/wallpaper.jpg -O /home/tajo48/photos/wallpaper.jpg
startx
testi3

###DWM part

#makepkg in root
rm /usr/bin/makepkg
wget https://raw.githubusercontent.com/tajo48/2/master/makepkg /root/makepkg
cat makepkg > /usr/bin/makepkg
rm /root/makepkg
chmod +x /usr/bin/makepkg

#wallpaper
mkdir /home/tajo48/photos
wget https://raw.githubusercontent.com/tajo48/2/master/wallpaper.jpg -O /home/tajo48/photos/wallpaper.jpg

#dwm try
cd /home/tajo48
echo "feh --bg-fill /home/tajo48/photos/wallpaper.jpg
setxkbmap -layout 'pl'
exec dwm" >> ~/.xinitrc
pacman -S --noconfirm feh firefox rxvt-unicode neofetch

#download (almost temporary)
wget https://aur.archlinux.org/cgit/aur.git/snapshot/dwm.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/st.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/dmenu.tar.gz
tar -xzvf dwm.tar.gz
tar -xzvf st.tar.gz
tar -xzvf dmenu.tar.gz
#wgetpatch (temporary)
cd /home/tajo48/dwm
wget https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.2.diff

#patch (temporary)
cd /home/tajo48/dwm
mv config.h config.def.h
patch < dwm-fullgaps-6.2.diff
mv config.def.h config.h

#makekpkg
cd /home/tajo48/st
makepkg -sic --noconfirm --skipchecksums
cd /home/tajo48/dmenu
makepkg -sic --noconfirm --skipchecksums
cd /home/tajo48/dwm
makepkg -sic --noconfirm --skipchecksums

startx
