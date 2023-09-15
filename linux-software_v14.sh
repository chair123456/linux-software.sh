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
    sudo apt-add-repository --component contrib
    sudo apt-add-repository --component non-free-firmware
	sudo apt-add-repository --component non-free
    
    sudo echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" >> /etc/apt/sources.list
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib" >> /etc/apt/sources.list
	sudo apt update
	sudo apt install fasttrack-archive-keyring extrepo && sudo dpkg --add-architecture i386
	sudo apt update && sudo apt upgrade -y

	# ubuntu restricted extras 
	sudo apt install ttf-mscorefonts-installer libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi
	sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups ibus-typing-booster && sudo dpkg-reconfigure libdvd-pkg  

	echo sudo apt install -t bookworm-backports packagename
fi
echo "Gnome"? 
echo 1. yes
echo 2. no, skip
option=0
read option 
if [[ $option -eq 1 ]]
then
	sudo apt install gnome-core file-roller gtkhash seahorse gnome-tweaks nautilus-nextcloud gnome-clocks gnome-shell-extension-gsconnect apt install gnome-software-plugin-flatpak flatpak 
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install com.mattjakeman.ExtensionManager -y
fi


echo "Flatpak & flatseal"
sudo apt install flatpak dialog
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal re.sonny.Junction -y
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
        sudo flatpak install org.mozilla.firefox -y
        ;;
        2)
        echo "Chromium"
        sudo flatpak install flathub org.chromium.Chromium -y
        ;;	
        3)
        echo "Libre office"
        sudo flatpak install flathub org.libreoffice.LibreOffice -y    
        ;;
        4)
        echo "VLC"
        sudo flatpak install flathub org.videolan.VLC -y
        ;;
        5)
        echo "KeePassXC"
        sudo flatpak install flathub org.keepassxc.KeePassXC -y
        ;;
        6)
        echo "Thunderbird"
        sudo flatpak install flathub org.mozilla.Thunderbird -y
        ;;
        7)
        echo "Photo gimp"
        flatpak install org.gimp.GIMP -y        	
        ;;
        8)
        echo "Paint"
        sudo flatpak install flathub com.github.maoschanz.drawing -y
        ;;
        9)
        echo "Blender"
        sudo flatpak install flathub org.blender.Blender -y
        ;;
        10)
        echo "FreeCAD"
        sudo flatpak install flathub org.freecadweb.FreeCAD -y
        ;;
        11)
        echo "Cura"
        sudo flatpak install flathub com.ultimaker.cura -y
        ;;
        12)
        echo "Signal"
        sudo flatpak install flathub org.signal.Signal -y
        ;;
        13)
        echo "Raspberry pi imager"
        sudo flatpak install flathub org.raspberrypi.rpi-imager -y
        ;;
        14)
        echo "ClamTk"
        sudo flatpak install flathub com.gitlab.davem.ClamTk -y
        ;;
        15)
        echo "OBS"
        sudo flatpak install flathub com.obsproject.Studio -y
        ;;
        16)
        echo "Steam"
        sudo flatpak install flathub com.valvesoftware.Steam -y
        ;;
        17)
        echo "Aisleriot solitare"
        sudo flatpak install flathub org.gnome.Aisleriot -y
        ;;
        18)
        echo "Lutris"
        sudo flatpak install flathub net.lutris.Lutris -y
        ;;
        19)
        echo "Dolphin emulator"
        sudo flatpak install flathub org.DolphinEmu.dolphin-emu -y
        ;;
        20)
        echo "Remmina"
        sudo flatpak install flathub org.remmina.Remmina -y
        ;;
        21)
        echo "Piper mouse"
        sudo flatpak install flathub org.freedesktop.Piper -y
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
        sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager spice-vdagent -y 

        sudo virsh net-autostart default
        sudo usermod -aG libvirt $USER 
        sudo usermod -aG libvirt-qemu $USER
        sudo usermod -aG kvm $USER
        sudo usermod -aG input $USER
        sudo usermod -aG disk $USER
        ;;
        2)
        echo "virtualbox"
        sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-x11 virtualbox-guest-utils 
        sudo usermod -aGvboxusers $USER	
        ;;	
        3)
        echo "Distrobox"
        sudo apt install distrobox
        ;;
        4)
        echo "Nix package manager"
        sudo sh <(curl -L https://nixos.org/nix/install) --daemon
        ;;
        5)
        echo "Sunshine / moonlight video streaming"
        flatpak install flathub dev.lizardbyte.app.Sunshine
        flatpak run --command=additional-install.sh dev.lizardbyte.sunshine
        sudo -i PULSE_SERVER=unix:$(pactl info | awk '/Server String/{print$3}') flatpak run dev.lizardbyte.sunshine
        ;;
        6)
        echo "Scrcpy"
        sudo apt install scrcpy
        ;;
        7)
        echo "VSCodium" 
        sudo extrepo enable vscodium
        sudo apt update
        sudo apt install codium           	
        ;;
    esac
done
sudo apt remove dialog
echo Finished
echo flatpak
echo syncthing-gtk gitlab.newsflash Heroic-game-luncher org.prismlauncher.PrismLauncherecho 
echo firefox-esr-l10n-en-gb thunderbird-l10n-en-gb nemo gufw bleachbit tlp menulibre gnome-software transmission nextcloud-desktop gufw