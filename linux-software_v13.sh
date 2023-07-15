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
	
    sudo rm -r /etc/apt/source.list
	mv /home/$USER/linux-software.sh/source.list /etc/apt/source.list 
	sudo apt update
	sudo apt install fasttrack-archive-keyring extrepo && sudo dpkg --add-architecture i386
	sudo apt update && sudo apt upgrade -y

	# ubuntu restricted extras 
	sudo apt install ttf-mscorefonts-installer libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi

	sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups ibus-typing-booster && sudo dpkg-reconfigure libdvd-pkg  
	
	echo apt ---  firefox-esr-l10n-en-gb thunderbird-l10n-en-gb file-roller-nautilus gtkhash nemo gufw bleachbit tlp menulibre gnome-software

	echo sudo apt install -t bullseye-backports packagename
	
	sudo apt install dialog wget

fi

if [[ $distro -eq 2 && $option -eq 1 ]]
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
	echo dnf --- chromium-freeworld firefox-langpack-en thunderbird-langpack-en file-roller-nautilus gtkhash nemo gufw bleachbit tlp menulibre gnome-software
	sudo dnf install dialog wget
fi

echo "Flatpak & flatseal"? 
echo 1. yes
echo 2. no, skip
read option 
if [[$option -eq 1]]
then
	echo "Flatpak & flatseal"
	if [[ $distro -eq 1 ]]
	then
		sudo apt install flatpak
	fi
	echo raspberrypi-imager signal vlc clamtk keepassxc syncthing-gtk obs blender gimp freecad steam lutris cura aisleriot-solitaire steam lmms dolphin-emu com.gitlab.newsflash drawing remmina piper ExtensionManager Junction Heroic-game-luncher
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal
	chosen=(dialog --separate-output --checklist "checklist" 40 90 30 --output-fd 1)
	options=(1 "Firefox & custom luncher & extensions" off    
    2 "chromium" off
    3 "Libre office & language tools" off
    4 "vlc" off
    5 "keepassxc" off
    6 "Thunderbird"
    7 "Photo gimp" off
    8 "drawing" off
    9 "blender" off
    10 "freecad" off
    11 "cura" off
    12 "signal" off
    13 "raspberrypi imager" off
    14 "clamtk" off
    15 "obs" off
    16 "steam" off
    17 "aisleriot-solitaire" off
    18 "lutris" off
    19 "dolphin-emu" off
    20 "remmina" off
    21 "piper" off)
	choices=$("${chosen[@]}" "${options[@]}")
	for choice in $choices
	do
    	case $choice in
        1)
        echo "Firefox & custom luncher & extensions"
        mv /home/$USER/linux-software.sh/Firefox.desktop /home/$USER/.local/share/applications
        	
		flatpak run org.mozilla.firefox -CreateProfile work
						
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3343599/cookie_quick_manager-0.5rc2.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3902154/decentraleyes-2.0.17.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3009842/enhanced_h264ify-2.1.0.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4024031/facebook_container-2.3.9.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4058426/multi_account_containers-8.1.2.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3990496/get_rss_feed_url-2.2.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3626312/gsconnect-8.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4071150/i_dont_care_about_cookies-3.4.6.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4078287/keepassxc_browser-1.8.5.1.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4072734/return_youtube_dislikes-3.0.0.8.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4002882/tab_session_manager-6.12.1.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4079064/ublock_origin-1.47.4.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/3816853/unpaywall-3.98.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4047133/user_agent_string_switcher-0.4.9.xpi
		flatpak run org.mozilla.firefox https://addons.mozilla.org/firefox/downloads/file/4067111/youtube_high_definition-109.0.0.xpi
					
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"
      	;;
      	2)
        sudo flatpak install flathub com.github.Eloston.UngoogledChromium
        ;;
        3)
        echo "Libre office & language tools"
        sudo flatpak install flathub org.libreoffice.LibreOffice      			
        wget -P /home/$USER/linux-software.sh https://extensions.libreoffice.org/assets/downloads/3710/1673297554/LanguageTool-6.0.oxt
        ;;
        4)
        sudo flatpak install flathub org.videolan.VLC
        ;;
        5)
        sudo flatpak install flathub org.keepassxc.KeePassXC
        ;;
        6)
        echo "Thunderbird"
        sudo flatpak install flathub org.mozilla.Thunderbird
        ;;
        7)
        echo "Photo gimp"
        flatpak install gimp
        flatpak run org.gimp.GIMP
	    git clone https://github.com/Diolinux/PhotoGIMP.git /.var/wpp/org.gimp.GIMP/config/IMP/2.10
	    mv 2.10 /home/$USER/.config/GIMP/
        ;;
        8)
        sudo flatpak install flathub com.github.maoschanz.drawing
        ;;
        9)
        sudo flatpak install flathub org.blender.Blender
        ;;
        10)
        sudo flatpak install flathub org.freecadweb.FreeCAD
        ;;
        11)
        sudo flatpak install flathub com.ultimaker.cura
        ;;
        12)
        sudo flatpak install flathub org.signal.Signal
        ;;
        13)
        sudo flatpak install flathub org.raspberrypi.rpi-imager
        ;;
        14)
        sudo flatpak install flathub com.gitlab.davem.ClamTk
        ;;
        15)
        sudo flatpak install flathub com.obsproject.Studio
        ;;
        16)
        sudo flatpak install flathub com.valvesoftware.Steam
        ;;
        17)
        sudo flatpak install flathub org.gnome.Aisleriot
        ;;
        18)
        sudo flatpak install flathub net.lutris.Lutris
        ;;
        19)
        sudo flatpak install flathub org.DolphinEmu.dolphin-emu
        ;;
        20)
        sudo flatpak install flathub org.remmina.Remmina
        ;;
        21)
        sudo flatpak install flathub org.freedesktop.Piper
        ;;
	    esac
    done
fi
 
chosen=(dialog --separate-output --checklist "checklist" 40 90 30 --output-fd 1)
options=(1 "Virt-manager" off
         2 "Virtualbox" off     
         3 "Distrobox" off        
         4 "Nix package manager" off        
         5 "Sunshine / moonlight video streaming" off
         6 "Scrcpy" off 
         7 "Gnome extensions" off   
         8 "VSCodium" off
         9 "VM Guest Additions Linux" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in   
        1)
        echo "Virt-manager"
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
        2)
        echo "virtualbox"
        sudo apt install virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso
        sudo usermod -aGvboxusers $USER	
        ;;	
        3)
        echo "Distrobox"
        if [[ $distro -eq 1 ]]
        then
        	sudo apt install distrobox
        fi
		if [[ $distro -eq 2 ]]
		then
			sudo dnf install distrobox
		fi
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
        mv /home/$USER/linux-software.sh/sunshine.desktop /home/$USER/.local/share/applications
        ;;
        6)
        echo "Scrcpy"
        if [[ $distro -eq 1 ]]
        then
        	sudo apt install scrcpy
        fi
        if [[ $distro -eq 2 ]]   	
        then
        	sudo dnf copr enable zeno/scrcpy
        	sudo dnf update
			sudo dnf install scrcpy
		fi
        mv /home/$USER/linux-software.sh/scrcpy.desktop /home/$USER/.local/share/applications
        ;;
        7)
        echo "Gnome extensions"
        if [[ $distro -eq 1 ]]
        then
        	sudo apt install gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect nautilus-nextcloud file-roller ibus-typing-booster gnomtware-plugin-flatpak
        fi
        if [[ $distro -eq 2 ]]
        then
			sudo dnf install gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch gnome-tweaks.noarch gnome-tweaks gnome-shell-extension-gsconnect nautilus-nextcloud file-roller ibus-typing-booster document-scanner
        fi      	
        ;;
        8)
        echo "VSCodium" 
        if [[ $distro -eq 1 ]]
        then
			sudo extrepo enable vscodium
			sudo apt update
			sudo apt install codium           	
    	fi
    	if [[ $distro -eq 2 ]]
        then
            sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
			printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo
			sudo dnf update
			sudo dnf install codium
        fi
        ;;
        9)
        echo "VM Guest Additions Linux"       
        
	if [[ $distro -eq 1 ]]
        then
		sudo apt install virtualbox-guest-x11 virtualbox-guest-utils sudo apt install spice-vdagent       	
    	fi
        ;;
    esac
done
echo finished
