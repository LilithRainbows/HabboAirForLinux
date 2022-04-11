#!/bin/bash

cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path

ARCH=`dpkg --print-architecture`
if [ $ARCH != 'amd64' ]; then
	echo "Wrong architecture, only x64 is supported!"
    exit
fi

echo "[Checking dependencies]"
current_linux=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
pkgs='unzip wget'
for pkg in $pkgs; do
    if [ $current_linux == "debian" ] || [ $current_linux == "ubuntu" ] || [ $current_linux == "linuxmint" ]; then
        status=$(dpkg --list | grep "$pkg")
        install_type=0
    elif [ $current_linux == "arch" ]; then
        status=$(pacman -Q | grep "$pkg")
        install_type=1
    else
        echo="Distribution not recognized. Skipping..."
        break
    fi
    if [ -z "$status" ]; then
        case $install_type in
        0)
            sudo apt install $pkg -y
            ;;
        1)
            sudo pacman -S $pkg --noconfirm
            ;;
        esac
        break
    fi
done

HabboAirForLinuxAppPath=~/.local/share/applications/HabboAirForLinux
#rm -r $HabboAirForLinuxAppPath
mkdir -p $HabboAirForLinuxAppPath
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirLinuxPatch.zip -O $HabboAirForLinuxAppPath/HabboAirLinuxPatch.zip
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboLauncher.sh -O $HabboAirForLinuxAppPath/HabboLauncher.sh
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirForLinux.png -O ~/.icons/HabboAirForLinux.png
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirForLinux.desktop -O $HabboAirForLinuxAppPath/../HabboAirForLinux.desktop
chmod +x $HabboAirForLinuxAppPath/HabboLauncher.sh
xdg-settings set default-url-scheme-handler habbo HabboAirForLinux.desktop

echo "[Installation finished]"
echo "Now you can use the Habbo Launch button from the web."
