#!/bin/bash
cat /etc/*release
path="$(pwd)"
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    case "$ID" in
        ubuntu|debian)
            path+="/debian_software.sh"
            bash $path
            ;;
        centos|rhel)
            # Add your CentOS/RHEL commands here
            ;;
        fedora)
            epath+="/fedora_software.sh"
            bash $path
            ;;
        *)
            echo "Unknown distribution: $ID"
            ;;
    esac
else
    echo "Unable to determine the distribution."
fi

echo "Flatpak & flatseal"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install --system com.github.tchx84.Flatseal
chosen=(dialog --separate-output --checklist "checklist" 40 160 30 --output-fd 1)
options=(1 "Libre office" off
         2 "KeePassXC" off
         3 "Freecad" off
         4 "Cura" off
         5 "Raspberrypi imager" off
         6 "Clamtk" off
         7 "OBS" off
         8 "Piper" off
         9 "Pika Backup" off
         10 "Resources" off
         11 "Bottles" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in   
        1)
        echo "Libre office"
        flatpak install flathub org.libreoffice.LibreOffice -y
        ;;
        2)
        echo "KeePassXC"
        flatpak install flathub org.keepassxc.KeePassXC -y
        ;;
        3)
        echo "FreeCAD"
        flatpak install flathub org.freecadweb.FreeCAD -y
        ;;
        4)
        echo "Cura"
        flatpak install flathub com.ultimaker.cura -y
        ;;
        5)
        echo "Raspberry pi imager"
        flatpak install flathub org.raspberrypi.rpi-imager -y
        ;;
        6)
        echo "ClamTk"
        flatpak install flathub com.gitlab.davem.ClamTk -y
        ;;
        7)
        echo "OBS"
        flatpak install flathub com.obsproject.Studio -y
        ;;
        8)
        echo "Piper mouse"
        flatpak install flathub org.freedesktop.Piper -y
        ;;
        9)
        echo "Pika Backup"
        flatpak install flathub org.gnome.World.PikaBackup -y
        ;;
        10)
        echo "Resources"
        flatpak install flathub net.nokyan.Resources -y
        ;;
        11)
        echo "Bottles"
        flatpak install flathub com.usebottles.bottles -y
        ;;
    esac
done
echo "Internet"
chosen=(dialog --separate-output --checklist "checklist" 40 160 30 --output-fd 1)
options=(1 "Junction" off
         2 "Firefox" off
         3 "Chromium" off
         4 "Thunderbird" off
         5 "Signal" off
         6 "Remmina" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in
        1)
        echo "Junction"
        flatpak install --system re.sonny.Junction -y
        ;;   
        2)
        echo "Firefox"
        flatpak install org.mozilla.firefox -y
        ;;
        3)
        echo "Chromium"
        flatpak install flathub org.chromium.Chromium -y
        ;;
        4)
        echo "Thunderbird"
        flatpak install flathub org.mozilla.Thunderbird -y
        ;;
        5)
        echo "Signal"
        flatpak install flathub org.signal.Signal -y
        ;;
        6)
        echo "Remmina"
        flatpak install flathub org.remmina.Remmina -y
        ;;
    esac
done
echo "Graphics"
chosen=(dialog --separate-output --checklist "checklist" 40 160 30 --output-fd 1)
options=(1 "Paint" off
         2 "Photo gimp" off
         3 "Blender" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in   
        1)
        echo "Paint"
        flatpak install flathub com.github.maoschanz.drawing -y
        ;;
        2)
        echo "Photo gimp"
        flatpak install org.gimp.GIMP -y
        flatpak run org.gimp.GIMP
        wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.1/PhotoGIMP.zip
        unzip PhotoGIMP.zip
        mv PhotoGIMP-master/.var /.var
        mv /home/$USER/PhotoGIMP-master/.var /home/$USER/.var/app/org.gimp.GIMP
        mv --backup=t /home/$USER/PhotoGIMP-master/.var /home/$USER
        rm -r PhotoGIMP-master
        rm -f PhotoGIMP.zip
        ;;
        3)
        echo "Blender"
        flatpak install flathub org.blender.Blender -y
        ;;
    esac
done
echo "Games"
chosen=(dialog --separate-output --checklist "checklist" 40 160 30 --output-fd 1)
options=(1 "Steam" off
         2 "Heroic games launcher" off
         3 "Prism Launcher" off
         4 "Lutris" off
         5 "Aisleriot solitare" off
         6 "Dolphin emulator" off
         7 "RPCS3" off
         8 "ares" off)
choices=$("${chosen[@]}" "${options[@]}")
for choice in $choices
do
    case $choice in   
        1)
        echo "Steam"
        flatpak install flathub com.valvesoftware.Steam -y
        sed -i '/^# en_US.UTF-8 UTF-8/s/^# //' "/etc/locale.gen"
        locale-gen
        ;;
        2)
        echo "Heroic games launcher"
        flatpak install com.heroicgameslauncher.hgl -y
        ;;
        3)
        echo "Prism Launcher"
        flatpak install org.prismlauncher.PrismLauncher -y
        ;;
        4)
        echo "Lutris"
        flatpak install flathub net.lutris.Lutris -y
        ;;
        5)
        echo "Aisleriot solitare"
        flatpak install flathub org.gnome.Aisleriot -y
        ;;
        6)
        echo "Dolphin emulator"
        flatpak install flathub org.DolphinEmu.dolphin-emu -y
        ;;
        7)
        echo "RPCS3"
        flatpak install flathub net.rpcs3.RPCS3 -y
        ;;
        7)
        echo "ares"
        flatpak install flathub dev.ares.ares -y
        ;;
    esac
done
echo me.kozec.syncthingtk gitlab.newsflash
echo Finished 