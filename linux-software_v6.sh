#!/bin/bash
cat /etc/*release
echo distro ?
echo 1. debian
echo 2. fedora
distro=0
read distro


echo basic install?
echo 1. yes
echo 2. no
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

	#---------------------------
	echo sudo dnf install intel-media-driver
	echo sudo dnf install libva-intel-driver

	echo sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
	echo sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld


fi

echo programs 
echo 1. yes
echo 2. no
read option 
if [[ $distro -eq 1 && $option -eq 1 ]]
then
	echo apt ---  firefox-esr-l10n-en-gb thunderbird-l10n-en-gb chromium vlc clamtk libreoffice-l10n-en-gb  keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu drawing virtualbox-guest-x11 virtualbox-guest-dkms

	echo hardware --- intel-microcode amd64-microcode

	echo apt gnome-shell --- gnome-core  gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect libreoffice-gnome nautilus-nextcloud gnome-tweaks

	echo apt firefox --- webext-ublock-origin-firefox webext-ublock-origin-chromium gnome-shell-extension-gsconnect-browsers

	echo apt libreoffice --- libreoffice-lightproof-en hyphen-en-gb libreoffice-help-en-gb mythes-en-us openclipart-libreoffice 

	echo apt virtmanger --- sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
e-utils virtinst libvirt-daemon virt-manager -y

	echo sudo apt install -t bullseye-backports packagename
fi

if [[ $distro -eq 2 && $option -eq 1 ]]
then
	echo dnf chromium-freeworld thunderbird firefox vlc clamtk libreoffice keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds drawing
	echo dnf gnome-shell --- gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch gnome-tweaks.noarch
fi

echo flatpak ------------------ signal heroic Extension-Manager TLPUI gnome-feeds
echo install flatpak repo & flatseal?
echo 1. yes
echo 2. no
read option 
if [[ $option -eq 1 ]]
then
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal
fi
#--------------------------------------------------------------------------------------------
if [[ $distro -eq 1 ]]
then
sudo apt install dialog
fi
if [[ $distro -eq 2 ]]
then
sudo dnf install dialog
fi


options=(1 "photo gimp" off   
         2 "firefox js, custom luncher,extensions" off
         3 "vs codium" off
         4 "virt manager" off
         5 "virtualbox" off)
custom_script=$(dialog --separate-output --checklist "checklist" 15 90 30 --output-fd 1)
for loop in $custom_script
do
    case $loop in
        1)
            echo "Gimp"
  					cd /home/$USER/
						git clone https://github.com/Diolinux/PhotoGIMP.git
						cd /home/$USER/PhotoGIMP/.var/app/org.gimp.GIMP/config/GIMP
						mv 2.10 /home/$USER/.config/GIMP
						cd /home/$USER/
						rm PhotoGIMP
            ;;
        2)
            echo "firefox js, custom luncher,extensions"
            mkdir .local/share/applications
						cd .local/share/applications
						echo [Desktop Entry] >> Firefox.desktop
						echo Type=Application >> Firefox.desktop
						echo Name=Firefox Work >> Firefox.desktop
						echo GenericName=Web Browser >> Firefox.desktop
						echo Exec=firefox -P work >> Firefox.desktop
						echo Icon=firefox >> Firefox.desktop
						echo Terminal=false >> Firefox.desktop
						echo Categories=Network;WebBrowser; >> Firefox.desktop
						echo Keywords=web;browser;internet;firefox-work;firefoxwork; >> Firefox.desktop
						echo StartupWMClass=firefox; >> Firefox.desktop
						echo Actions=new-window;new-private-window;profile-manager-window; >> Firefox.desktop
						echo [Desktop Action new-window] >> Firefox.desktop
						echo Name=New window >> Firefox.desktop
						echo Exec=firefox -P work --new-window >> Firefox.desktop
						echo [Desktop Action new-private-window] >> Firefox.desktop
						echo Name=New Private Window >> Firefox.desktop
						echo Exec=firefox -P work -private-window >> Firefox.desktop
						echo [Desktop Action profile-manager-window] >> Firefox.desktop
						echo Exec=firefox -P >> Firefox.desktop
						echo Name=Open the Profile Manager >> Firefox.desktop
            ;;
        3)
            echo "vs codium"
            ;;
        4)
            echo "Fourth Option"
            echo sudo virsh net-autostart default
						echo sudo usermod -aG libvirt $USER 
						echo sudo usermod -aG libvirt-qemu $USER
						echo sudo usermod -aG kvm $USER
						echo sudo usermod -aG input $USER
						echo sudo usermod -aG disk $USER
            ;;
            
        5) 
        	echo "virtualbox"
        	sudo usermod -aG vboxuser $USER
        	;;
    esac
done


echo 1. photo gimp
echo 2. firefox js, custom luncher,extensions
echo 3. scrcpy
echo 4. vs codium
echo 5. gnome extensions
echo 6. language tool
echo 7. nix package manager
echo 8. config settings 
echo 9. heroic game luncher



echo finished
