#!/bin/bash
echo 1. debian
echo 2. fedora
option=0
read option
if [ $option -eq 1 ]
then
	sudo apt update
	cd /etc/apt/sources.list
	sudo echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> sources.list 
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-fasttrack main contrib" >> sources.list
	sudo echo "deb https://fasttrack.debian.net/debian-fasttrack/ bullseye-backports-staging main contrib" >> sources.list
	sudo apt install fasttrack-archive-keyring && sudo dpkg --add-architecture i386

	sudo apt update && sudo apt upgrade -y

	echo ubuntu restricted extras 
	sudo apt install ttf-mscorefonts-installer rar unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi

	sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups flatpak && sudo dpkg-reconfigure libdvd-pkg && 


	echo ------------------------------------------------------------------------------------------------

	echo apt --- intel-microcode amd64-microcode firefox-esr-l10n-en-gb thunderbird-l10n-en-gb chromium vlc clamtk libreoffice-l10n-en-gb  keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu 

	echo apt gnome-shell --- gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect libreoffice-gnome nautilus-nextcloud gnome-tweaks

	echo apt firefox --- webext-ublock-origin-firefox webext-ublock-origin-chromium gnome-shell-extension-gsconnect-browsers

	echo apt libreoffice --- libreoffice-lightproof-en hyphen-en-gb libreoffice-help-en-gb mythes-en-us openclipart-libreoffice https://extensions.libreoffice.org/en/extensions/show/languagetool https://github.com/Diolinux/PhotoGIMP

	echo apt virtmanger --- sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
e-utils virtinst libvirt-daemon virt-manager -y

	echo sudo apt install -t bullseye-backports packagename
fi
if [ $option -eq 2 ]
then
	echo fedora -------------------------------------------------------------------------------
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

	echo dnf chromium-freeworld thunderbird firefox vlc clamtk libreoffice keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds
	echo dnf gnome-shell --- gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch gnome-tweaks.noarch
fi


#--------------------------------------------------------------------------------------------
echo flatpak ------------------ signal heroic Extension-Manager TLPUI gnome-feeds
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && sudo flatpak install --system com.github.tchx84.Flatseal

echo virtualbox usb --- sudo usermod -aG vboxuser $USER 


echo sudo virsh net-autostart default
echo sudo usermod -aG libvirt $USER 
echo sudo usermod -aG libvirt-qemu $USER
echo sudo usermod -aG kvm $USER
echo sudo usermod -aG input $USER
echo sudo usermod -aG disk $USER
#----------------------
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
echo ------------------------------------------------------------------------------------------------

echo finished
