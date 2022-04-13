#!/bin/bash

cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path

ARCH=`dpkg --print-architecture`
if [ $ARCH != 'amd64' ]; then
	echo "Wrong architecture, only x64 is supported!"
    exit
fi

echo "[Checking dependencies]"
if type dpkg &>/dev/null; then pkgs='unzip wget libnss3'; else pkgs='unzip wget nss'; fi
for pkg in $pkgs; do
    if type dpkg &>/dev/null; then
        if [ -z "$(dpkg --list | grep "$pkg")" ]; then
            sudo apt install $pkg -y
        fi
    else
        if [ -z "$(pacman -Q | grep "$pkg")" ]; then
            sudo pacman -S $pkg --noconfirm
        fi
    fi
done

HabboAirForLinuxAppPath=~/.local/share/applications/HabboAirForLinux
#rm -r $HabboAirForLinuxAppPath
mkdir -p $HabboAirForLinuxAppPath
mkdir -p ~/.icons
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirLinuxPatch.zip -O $HabboAirForLinuxAppPath/HabboAirLinuxPatch.zip
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboLauncher.sh -O $HabboAirForLinuxAppPath/HabboLauncher.sh
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirForLinux.png -O ~/.icons/HabboAirForLinux.png
wget https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirForLinux.desktop -O $HabboAirForLinuxAppPath/../HabboAirForLinux.desktop
chmod +x $HabboAirForLinuxAppPath/HabboLauncher.sh
xdg-settings set default-url-scheme-handler habbo HabboAirForLinux.desktop

echo "[Installation finished]"
echo "Now you can use the Habbo Launch button from the web."
