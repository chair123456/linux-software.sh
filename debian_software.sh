#!/bin/bash
echo basic install?
echo "yes = 1"
echo "no/skip = 2"
option=0
read option
if [[ $option -eq 1 ]]
then
    codename=$(grep -oP 'VERSION_CODENAME=\K\w+' /etc/os-release)
    echo 
	apt-add-repository --component contrib
	apt-add-repository --component non-free-firmware
	apt-add-repository --component non-free
    
	echo "deb http://deb.debian.org/debian "$codename"-backports main contrib non-free" >> /etc/apt/sources.list
	echo "deb https://fasttrack.debian.net/debian-fasttrack/ "$codename"-fasttrack main contrib" >> /etc/apt/sources.list
 
 	echo "deb https://fasttrack.debian.net/debian-fasttrack/ "$codename"-backports-staging main contrib" >> /etc/apt/sources.list
	apt install fasttrack-archive-keyring extrepo -y && dpkg --add-architecture i386
	apt update && apt upgrade -y
    #media
	apt install libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi libdvd-pkg -y && dpkg-reconfigure
    #windows fonts compatibility
	#apt install ttf-mscorefonts-installer fonts-crosextra-carlito fonts-crosextra-caladea
    #other 
    apt install printer-driver-all cups ibus-typing-booster -y
fi
echo "Gnome"?
echo "yes = 1"
echo "no/skip = 2"
option=0
read option 
if [[ $option -eq 1 ]]
then
	apt install gnome-remote-desktop openssh-server gnome-tweaks gnome-software-plugin-flatpak gnome-calendar gnome-clocks seahorse simple-scan file-roller nautilus-nextcloud gnome-sushi nautilus-image-converter nautilus-image-converter nautilus-admin gtkhash gnome-shell-extension-gsconnect gnome-shell-extension-appindicator gnome-shell-extension-arc-menu gnome-shell-extension-dash-to-panel gnome-shell-extension-desktop-icons-ng gnome-shell-extension-gamemode -y
    flatpak install flathub com.mattjakeman.ExtensionManager -y
fi
apt install flatpak dialog
chosen=(dialog --separate-output --checklist "checklist" 40 90 30 --output-fd 1)
options=(1 "Virt-manager" off
         2 "Virtualbox" off
         3 "Distrobox" off
         4 "Nix package manager" off
         5 "Sunshine / moonlight video streaming" off
         6 "Scrcpy" off
         7 "VSCodium" off
         8 "Wake on LAN" off
         9 "CD ripping software" off
         10 "Nextcloud desktop" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in
        1)
        echo "Virt-manager"
        apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager spice-vdagent -y 

        virsh net-autostart default
        usermod -aG libvirt $USER
        usermod -aG libvirt-qemu $USER
        usermod -aG kvm $USER
        usermod -aG input $USER
        usermod -aG disk $USER
        ;;
        2)
        echo "virtualbox"
        apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-x11 virtualbox-guest-utils -y
        usermod -aGvboxusers $USER
        ;;	
        3)
        echo "Distrobox"
        apt install podman distrobox -y
        flatpak install flathub io.github.dvlv.boxbuddyrs -y
        ;;
        4)
        echo "Nix package manager"
        sh <(curl -L https://nixos.org/nix/install) --daemon
        ;;
        5)
        echo "Sunshine / moonlight video streaming"
        flatpak install flathub dev.lizardbyte.app.Sunshine
        chown $USER /dev/uinput && echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/85-sunshine-input.rules
        flatpak override --talk-name=org.freedesktop.Flatpak dev.lizardbyte.app.Sunshine
        -i PULSE_SERVER=unix:$(pactl info | awk '/Server String/{print$3}') flatpak run dev.lizardbyte.sunshine
        ;;
        6)
        echo "Scrcpy"
        apt install scrcpy -y
        ;;
        7)
        echo "VSCodium"
        extrepo enable vscodium
        apt update
        apt install codium -y
        ;;
        8)
        echo "Wake on LAN" 
        apt install ethtool -y
        echo "ethernet-wol g" >> /etc/network/interfaces
        ;;
        9)
        echo "CD ripping software"
        apt install soundconverter brasero -y
        ;;
        10)
        echo "Nextcloud desktop"
        apt install nextcloud-desktop -y
        ;;
    esac
done
echo firefox-esr-l10n-en-gb thunderbird-l10n-en-gb gufw bleachbit tlp menulibre transmission