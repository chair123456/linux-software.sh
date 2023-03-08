#!/bin/bash
cat /etc/*release
echo distro ?
echo 1. debian
echo 2. fedora
distro=0
read distro


echo basic install?
echo 1. yes
echo 2. no, skip
option=0
read option
if [[ $distro -eq 1 && $option -eq 1 ]]
then
	echo debian https://www.debian.org/doc/
	sudo apt update
	cd /etc/apt/sources.list
	sudo echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> sources.list 
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" >> sources.list
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib" >> sources.list
	sudo apt install fasttrack-archive-keyring && sudo dpkg --add-architecture i386

	sudo apt update && sudo apt upgrade -y

	# ubuntu restricted extras 
	sudo apt install ttf-mscorefonts-installer rar unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi

	sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups flatpak && sudo dpkg-reconfigure libdvd-pkg && 
fi

if [ $distro -eq 2 && $option -eq 1 ]
then
	echo fedora https://docs.fedoraproject.org/en-US/quick-docs
	sudo dnf update
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	sudo dnf install rpmfusion-nonfree-release-tainted && sudo dnf install rpmfusion-free-release-tainted

	sudo dnf groupupdate core


	#firmware
	sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

	#fonts
	sudo dnf install fonts-crosextra-carlito fonts-crosextra-caladea && sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

	#media codecs
	sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin && sudo dnf groupupdate sound-and-video

	sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
	sudo dnf install lame\* --exclude=lame-devel
	sudo dnf group upgrade --with-optional Multimedia
	#dvd
	sudo dnf install libdvdcss

	#firefox openh264 
	sudo dnf config-manager --set-enabled fedora-cisco-openh264
	sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264

	#hardwarre
	echo sudo dnf install intel-media-driver
	echo sudo dnf install libva-intel-driver

	echo sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
	echo sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
fi

echo programs 
echo 1. yes
echo 2. no, skip
read option 
if [[ $distro -eq 1 && $option -eq 1 ]]
then
	echo apt ---  firefox-esr-l10n-en-gb thunderbird-l10n-en-gb chromium vlc clamtk libreoffice-l10n-en-gb keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds drawing virtualbox-guest-x11 virtualbox-guest-dkms

	echo hardware --- intel-microcode amd64-microcode

	echo apt gnome-shell --- gnome-core libreoffice-gnome nautilus-nextcloud gnome-tweaks

	echo apt firefox --- webext-ublock-origin-firefox webext-ublock-origin-chromium gnome-shell-extension-gsconnect-browsers

	echo sudo apt install -t bullseye-backports packagename
fi

if [[ $distro -eq 2 && $option -eq 1 ]]
then
	echo dnf chromium-freeworld thunderbird-langpack-en libreoffice-langpack-en vlc clamtk keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds drawing dolphin-emu drawubg
fi

if [[ $distro -eq 1 ]]
then
	sudo apt install dialog
	sudo apt install wget
fi
if [[ $distro -eq 2 ]]
then
	sudo dnf install dialog
	sudo dnf install wget
fi


chosen=(dialog --separate-output --checklist "checklist" 40 90 30 --output-fd 1)
options=(1 "Flatpak & flatseal" off    
         2 "Photo gimp" off
         3 "Firefox js & custom luncher & extensions" off
         4 "Vs codium" off
         5 "Gnome extensions" off
         6 "Libre office language tools" off
         7 "Config settings" off
         8 "Heroic game luncher" off
         9 "Scrcpy" off
         10 "Nix package manager" off
         11 "Virt_manager" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in
        1)
            echo "Flatpak & flatseal"
            if [[ $distro -eq 1 ]]
						then
							sudo apt install flatpak
						fi
						sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal
            ;;
        2)
            echo "Photo gimp"
            cd /home/$USER/
						git clone https://github.com/Diolinux/PhotoGIMP.git
						cd /home/$USER/PhotoGIMP/.var/app/org.gimp.GIMP/config/GIMP
						mv 2.10 /home/$USER/.config/GIMP
						cd /home/$USER/
						rm -rf PhotoGIMP
            ;;
        3)
            echo "Firefox js, custom luncher,extensions"
            mkdir .local/share/applications
						cd .local/share/applications
						
            ;;
        4)
            echo "Vs codium" 
            if [[ $distro -eq 1 ]]
            then
            	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    							| gpg --dearmor \
    							| sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
    					echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    							| sudo tee /etc/apt/sources.list.d/vscodium.list
    					sudo apt install codium
    				fi
    				if [[ $distro -eq 2 ]]
            then
            	sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
            	printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
            	sudo dnf install codium
            fi
            ;;
        5)	
        		echo "gnome extension"
        		if [[ $distro -eq 1 ]]
        		then
        			sudo apt install gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect gnome-tweaks
        		fi
        		if [[ $distro -eq 2 ]]
        		then
        			sudo dnf install gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch gnome-tweaks.noarch
        		fi
        		sudo flatpak install com.mattjakeman.ExtensionManager
        		;;
        6)
        		echo "Libre office language tools"
        		if [[ $distro -eq 1 ]]
        		then
        			sudo apt install libreoffice-lightproof-en hyphen-en-gb libreoffice-help-en-gb mythes-en-us openclipart-libreoffice 
        		fi	
        		wget https://extensions.libreoffice.org/assets/downloads/3710/1673297554/LanguageTool-6.0.oxt
        		;;
        7)
        		echo "Config settings"
        		;;
        8)
        		echo "Heroic game luncher"
        		if [[ $distro -eq 1 ]]        		
        		then
        			wget https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.6.1/heroic_2.6.1_amd64.deb
        			sudo dpkg -i heroic_2.6.1_amd64.deb
        			rm -rf heroic_2.6.1_amd64.deb 
        		fi
        		if [[ $distro -eq 2 ]]
        		then
        			sudo dnf copr enable atim/heroic-games-launcher && sudo dnf copr enable atim/heroic-games-launcher
        		fi
        		;;
        9)
        		echo "Scrcpy"
        		if [[ $distro -eq 1 ]]   	
        		then
        			sudo apt install scrcpy
        		fi
        		if [[ $distro -eq 2 ]]   	
        		then
        			sudo dnf copr enable zeno/scrcpy
							sudo dnf install scrcpy
						fi
        		;;
        10)
        		echo "Nix package manager"
        		sudo sh <(curl -L https://nixos.org/nix/install) --daemon
        		;;
        11)
        		echo "Virt_manager"
        		if [[ $distro -eq 1 ]]
        		then
        			sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
        		fi
						if [[ $distro -eq 2 ]]
						then
							sudo dnf install @virtualization
						fi
            echo sudo virsh net-autostart default
						echo sudo usermod -aG libvirt $USER 
						echo sudo usermod -aG libvirt-qemu $USER
						echo sudo usermod -aG kvm $USER
						echo sudo usermod -aG input $USER
						echo sudo usermod -aG disk $USER
        		;;
    esac
done

echo finished
