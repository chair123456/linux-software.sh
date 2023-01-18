#!/bin/bash
echo base 
﻿
sudo apt update && sudo apt upgrade && sudo apt install fasttrack-archive-keyring && sudo nano /etc/apt/sources.list && sudo dpkg --add-architecture i386

echo core 

sudo apt install ttf-mscorefonts-installer unrar libavcodec-extra gstreamer1.0-libav gstreamer1.0-plugins-ugly gstreamer1.0-vaapi amd64-microcode fonts-crosextra-carlito fonts-crosextra-caladea libdvd-pkg printer-driver-all cups flatpak && sudo dpkg-reconfigure libdvd-pkg && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo flatpak --- signal heroic Extension-Manager TLPUI 
flatpak install flatseal

echo ------------------------------------------------------------------------------------------------

echo apt --- firefox-esr-l10n-en-gb thunderbird-l10n-en-gb chromium vlc clamtk libreoffice-l10n-en-gb nautilus-nextcloud keepassxc menulibre tlp syncthing-gtk nemo gnome-software lollypop obs gufw blender gimp freecad steam lutris cura obs lutris aisleriot-solitaire steam lmms bleachbit distrobox dolphin-emu gnome-feeds

echo ------------------------------------------------------------------------------------------------

echo apt gnome-shell --- gnome-shell-extension-desktop-icons-ng gnome-shell-extension-dash-to-panel gnome-shell-extension-arc-menu gnome-shell-extension-appindicator gnome-tweaks gnome-shell-extension-gsconnect libreoffice-gnome

echo dnf gnome-shell --- gnome-shell-extension-appindicator.noarch gnome-shell-extension-gsconnect.x86_64 gnome-shell-extension-drive-menu.noarch

echo apt firefox --- webext-ublock-origin-firefox webext-ublock-origin-chromium gnome-shell-extension-gsconnect-browsers https://github.com/pyllyukko/user.js https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections

echo apt libreoffice --- libreoffice-lightproof-en hyphen-en-gb libreoffice-help-en-gb mythes-en-us openclipart-libreoffice https://extensions.libreoffice.org/en/extensions/show/languagetool https://github.com/Diolinux/PhotoGIMP

echo ------------------------------------------------------------------------------------------------

echo virtualbox usb --- sudo usermod -aG vboxuser $USER 

echo apt virtmanger --- sudo apt install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y

echo sudo virsh net-autostart default
echo sudo usermod -aG libvirt $USER 
echo sudo usermod -aG libvirt-qemu $USER
echo sudo usermod -aG kvm $USER
echo sudo usermod -aG input $USER
echo sudo usermod -aG disk $USER

echo sudo apt install -t bullseye-backports packagename

echo ------------------------------------------------------------------------------------------------

echo finished

[Desktop Entry]
Type=Application
Name=Firefox Work
GenericName=Web Browser
Exec=firefox -P work
Icon=firefox
Terminal=false
Categories=Network;WebBrowser;
Keywords=web;browser;internet;firefox-work;firefoxwork;
StartupWMClass=firefox;
Actions=new-window;new-private-window;profile-manager-window;

[Desktop Action new-window]
Name=New window
Exec=firefox -P work --new-window

[Desktop Action new-private-window]
Name=New Private Window
Exec=firefox -P work -private-window 

[Desktop Action profile-manager-window]
Exec=firefox -P
Name=Open the Profile Manager

