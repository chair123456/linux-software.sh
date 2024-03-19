#!/bin/bash
echo basic install?
echo "yes = 1"
echo "no/skip = 2"
option=0
read option
if [[ $option -eq 1 ]]
then
	dnf upgrade
    dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	dnf install rpmfusion-nonfree-release-tainted rpmfusion-free-release-tainted -y

	dnf groupupdate core
    dnf config-manager --set-enabled fedora-cisco-openh264

	#firmware
	dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"
    fwupdmgr refresh --force
    fwupdmgr get-updates
    fwupdmgr update

	#windows fonts
	#dnf install fonts-crosextra-carlito fonts-crosextra-caladea && rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

	#media codecs
    dnf swap ffmpeg-free ffmpeg --allowerasing
	dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin && dnf groupupdate sound-and-video

	dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
	dnf install lame\* --exclude=lame-devel
	dnf group upgrade --with-optional Multimedia
	#dvd
	dnf install libdvdcss -y

	#firefox openh264 
	dnf install gstreamer1-plugin-openh264 mozilla-openh264 -y

	#hardwarre accerated video
    vendor_id=$(grep -m 1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
    if [ "$vendor_id" = "GenuineIntel" ]; then
        dnf install intel-media-driver
	    dnf install libva-intel-driver
    elif [ "$vendor_id" = "AuthenticAMD" ]; then
        dnf swap mesa-va-drivers mesa-va-drivers-freeworld
	    dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    else
        echo "Unknown CPU vendor."
    fi
    #dnf install nvidia-vaapi-driver
fi

echo "Gnome"?
echo "yes = 1"
echo "no/skip = 2"
option=0
read option 
if [[ $option -eq 1 ]]
then
	dnf install gnome-tweaks seahorse file-roller gtkhash gnome-shell-extension-gsconnect gnome-shell-extension-appindicator gnome-shell-extension-dash-to-panel gnome-shell-extension-gamemode -y
	flatpak install flathub com.mattjakeman.ExtensionManager -y
fi

dnf install dialog -y
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
        dnf install @virtualization -y 

        echo https://fedoramagazine.org/full-virtualization-system-on-fedora-workstation-30/
        ;;
        2)
        echo "virtualbox"
        dnf install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-x11 virtualbox-guest-utils -y
        usermod -aGvboxusers $USER
        ;;	
        3)
        echo "Distrobox"
        dnf install podman distrobox -y
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
        dnf install scrcpy -y
        ;;
        7)
        echo "VSCodium"
		dnf install codium
        ;;
        8)
        echo "Wake on LAN" 
        dnf install ethtool -y
        echo "ethernet-wol g" >> /etc/network/interfaces
        ;;
        9)
        echo "CD ripping software"
        dnf install soundconverter brasero -y
        ;;
        10)
        echo "Nextcloud desktop"
        dnf install nextcloud-desktop -y
        ;;
    esac
done