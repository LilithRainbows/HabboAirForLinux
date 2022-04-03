#!/bin/bash

ARCH=`dpkg --print-architecture`
if [ $ARCH != 'amd64' ]; then
	echo "Wrong architecture, only x64 is supported!"
    exit
fi

echo "[Checking dependencies]"
pkgs='unzip wget'
install=false
for pkg in $pkgs; do
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
        install=true
        break
    fi
done
if "$install"; then
    sudo apt install $pkgs --assume-yes
fi  

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
