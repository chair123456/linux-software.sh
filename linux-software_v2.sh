#!/bin/bash

echo debian 

sudo apt update && sudo apt upgrade && sudo apt install fasttrack-archive-keyring && sudo dpkg --add-architecture i386

echo ubuntu restricted extras 
sudo apt install ttf-mscorefonts-installer rar unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi

sudo apt install fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups flatpak && sudo dpkg-reconfigure libdvd-pkg && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


echo ------------------------------------------------------------------------------------------------

echo apt --- intel-microcode amd64-microcode firefox-esr-l10n-en-gb thunderbird-l10n-en-gb chromium vlc clamtk libreoffice-l10n-en-gb nautilus-nextcloud keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds

echo apt gnome-shell --- gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect libreoffice-gnome

echo apt firefox --- webext-ublock-origin-firefox webext-ublock-origin-chromium gnome-shell-extension-gsconnect-browsers

echo apt libreoffice --- libreoffice-lightproof-en hyphen-en-gb libreoffice-help-en-gb mythes-en-us openclipart-libreoffice https://extensions.libreoffice.org/en/extensions/show/languagetool https://github.com/Diolinux/PhotoGIMP

echo apt virtmanger --- sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
e-utils virtinst libvirt-daemon virt-manager -y

echo sudo apt install -t bullseye-backports packagename


echo fedora -------------------------------------------------------------------------------
echo https://rpmfusion.org/Howto/Multimedia
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core

echo sudo dnf install intel-media-driver
echo sudo dnf install libva-intel-driver

echo sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
echo sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

sudo dnf install rpmfusion-free-release-tainted
sudo dnf install libdvdcss

sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

echo https://docs.fedoraproject.org/en-US

sudo dnf config-manager --set-enabled fedora-cisco-openh264
sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264

sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia

sudo dnf install fonts-crosextra-carlito fonts-crosextra-caladea

echo dnf chromium-freeworld thunderbird firefox vlc clamtk libreoffice keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds
echo dnf gnome-shell --- gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch

echo sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
echo flatpak ------------------ signal heroic Extension-Manager TLPUI 
flatpak install flatseal

echo virtualbox usb --- sudo usermod -aG vboxuser $USER ------------------------------------------------------------------------------------------------


echo sudo virsh net-autostart default
echo sudo usermod -aG libvirt $USER 
echo sudo usermod -aG libvirt-qemu $USER
echo sudo usermod -aG kvm $USER
echo sudo usermod -aG input $USER
echo sudo usermod -aG disk $USER

/home/.local/share/applications
echo ------------------------------------------------------------------------------------------------

echo finished

