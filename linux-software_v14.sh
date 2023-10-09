#!/bin/bash
cat /etc/*release


echo basic install?
echo 1. yes
echo 2. no, skip
option=0
read option
if [[ $option -eq 1 ]]
then
	echo debian https://www.debian.org/doc/
	apt-add-repository --component contrib
	apt-add-repository --component non-free-firmware
	apt-add-repository --component non-free
    
	echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free" >> /etc/apt/sources.list
	echo "deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-fasttrack main contrib" >> /etc/apt/sources.list
 
 	echo "deb https://fasttrack.debian.net/debian-fasttrack/ bookworm-backports-staging main contrib" >> /etc/apt/sources.list
	apt update
	apt install fasttrack-archive-keyring extrepo && dpkg --add-architecture i386
	apt update && sudo apt upgrade -y

	# ubuntu restricted extras 
	apt install ttf-mscorefonts-installer libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi
	apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups ibus-typing-booster && sudo dpkg-reconfigure libdvd-pkg

	echo sudo apt install -t bookworm-backports packagename
fi
echo "Gnome"?
echo 1. yes
echo 2. no, skip
option=0
read option 
if [[ $option -eq 1 ]]
then
	apt install gnome-core gnome-tweaks gnome-software-plugin-flatpak gnome-clocks seahorse file-roller nautilus-nextcloud gtkhash gnome-shell-extension-manager gnome-shell-extension-gsconnect gnome-shell-extension-appindicator gnome-shell-extension-arc-menu gnome-shell-extension-dash-to-panel gnome-shell-extension-desktop-icons-ng gnome-shell-extension-gamemode
fi


echo "Flatpak & flatseal"
apt install flatpak dialog
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal re.sonny.Junction -y
chosen=(dialog --separate-output --checklist "checklist" 40 160 30 --output-fd 1)
options=(1 "Firefox" off
         2 "Chromium" off
         3 "Libre office" off
         4 "VLC" off
         5 "KeePassXC" off
         6 "Thunderbird" off
         7 "Photo gimp" off
         8 "Drawing" off
         9 "Blender" off
         10 "Freecad" off
         11 "Cura" off
         12 "Signal" off
         13 "Raspberrypi imager" off
         14 "Clamtk" off
         15 "OBS" off
         16 "Steam" off
         17 "Aisleriot-solitaire" off
         18 "Lutris" off
         19 "Dolphin-emu" off
         20 "Remmina" off
         21 "Piper" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in   
        1)
        echo "Firefox"
        flatpak install org.mozilla.firefox -y
        ;;
        2)
        echo "Chromium"
        flatpak install flathub org.chromium.Chromium -y
        ;;	
        3)
        echo "Libre office"
        flatpak install flathub org.libreoffice.LibreOffice -y
        ;;
        4)
        echo "VLC"
        flatpak install flathub org.videolan.VLC -y
        ;;
        5)
        echo "KeePassXC"
        flatpak install flathub org.keepassxc.KeePassXC -y
        ;;
        6)
        echo "Thunderbird"
        flatpak install flathub org.mozilla.Thunderbird -y
        ;;
        7)
        echo "Photo gimp"
        flatpak install org.gimp.GIMP -y
        ;;
        8)
        echo "Paint"
        flatpak install flathub com.github.maoschanz.drawing -y
        ;;
        9)
        echo "Blender"
        flatpak install flathub org.blender.Blender -y
        ;;
        10)
        echo "FreeCAD"
        flatpak install flathub org.freecadweb.FreeCAD -y
        ;;
        11)
        echo "Cura"
        flatpak install flathub com.ultimaker.cura -y
        ;;
        12)
        echo "Signal"
        flatpak install flathub org.signal.Signal -y
        ;;
        13)
        echo "Raspberry pi imager"
        flatpak install flathub org.raspberrypi.rpi-imager -y
        ;;
        14)
        echo "ClamTk"
        flatpak install flathub com.gitlab.davem.ClamTk -y
        ;;
        15)
        echo "OBS"
        flatpak install flathub com.obsproject.Studio -y
        ;;
        16)
        echo "Steam"
        flatpak install flathub com.valvesoftware.Steam -y
        ;;
        17)
        echo "Aisleriot solitare"
        flatpak install flathub org.gnome.Aisleriot -y
        ;;
        18)
        echo "Lutris"
        flatpak install flathub net.lutris.Lutris -y
        ;;
        19)
        echo "Dolphin emulator"
        flatpak install flathub org.DolphinEmu.dolphin-emu -y
        ;;
        20)
        echo "Remmina"
        flatpak install flathub org.remmina.Remmina -y
        ;;
        21)
        echo "Piper mouse"
        flatpak install flathub org.freedesktop.Piper -y
        ;;
    esac
done

 
chosen=(dialog --separate-output --checklist "checklist" 40 90 30 --output-fd 1)
options=(1 "Virt-manager" off
         2 "Virtualbox" off
         3 "Distrobox" off
         4 "Nix package manager" off
         5 "Sunshine / moonlight video streaming" off
         6 "Scrcpy" off
         7 "VSCodium" off)
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
        apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-x11 virtualbox-guest-utils
        usermod -aGvboxusers $USER
        ;;	
        3)
        echo "Distrobox"
        apt install distrobox
        ;;
        4)
        echo "Nix package manager"
        sh <(curl -L https://nixos.org/nix/install) --daemon
        ;;
        5)
        echo "Sunshine / moonlight video streaming"
        flatpak install flathub dev.lizardbyte.app.Sunshine
        flatpak run --command=additional-install.sh dev.lizardbyte.sunshine
        -i PULSE_SERVER=unix:$(pactl info | awk '/Server String/{print$3}') flatpak run dev.lizardbyte.sunshine
        ;;
        6)
        echo "Scrcpy"
        apt install scrcpy
        ;;
        7)
        echo "VSCodium" 
        extrepo enable vscodium
        apt update
        apt install codium
        ;;
    esac
done
apt remove dialog
echo Finished
echo me.kozec.syncthingtk gitlab.newsflash com.heroicgameslauncher.hgl org.prismlauncher.PrismLauncherecho
echo firefox-esr-l10n-en-gb thunderbird-l10n-en-gb nemo gufw bleachbit tlp menulibre gnome-software transmission nextcloud-desktop gufw
