#!/bin/sh

loadkeys hu
timedatectl set-ntp true
cfdisk
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt
pacman -Sy reflector
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware intel-ucode networkmanager neovim
genfstab -U /ment >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=hu" > /etc/vconsole.conf
echo "vbox" > /etc/hostname
echo "127.0.0.1 	localhost" > /etc/hosts
echo "::1 			localhost" >> /etc/hosts
echo "127.0.1.1		vbox.localdomain 	vbox" >> /etc/hosts
systemctl enable NetworkManager
passwd
useradd -mG wheel,users,audio,video,optical,storage,power,rfkill roland
passwd roland
EDITOR=nvim visudo
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
echo "Rebooting..." && wait 5
reboot