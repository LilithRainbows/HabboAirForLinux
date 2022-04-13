#!/bin/bash

cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path

ARCH=`dpkg --print-architecture`
if [ $ARCH != 'amd64' ]; then
	echo "Wrong architecture, only x64 is supported!"
    exit
fi

echo "[Checking dependencies]"
if type dpkg &>/dev/null; then pkgs='tar unzip wget libnss3'; else pkgs='tar unzip wget nss'; fi
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
mkdir -vp $HabboAirForLinuxAppPath
mkdir -vp ~/.icons
wget -O HabboLauncher.tar.gz https://github.com/LilithRainbows/HabboAirForLinux/tarball/master
tar -xvf HabboLauncher.tar.gz
mv -v *LilithRainbows-HabboAirForLinux* HabboAirForLinux
chown -vR $USER:$USER HabboAirForLinux # Use sudo if this don't work?
mv -v HabboAirForLinux/HabboAirLinuxPatch.zip $HabboAirForLinuxAppPath
mv -v HabboAirForLinux/HabboLauncher.sh $HabboAirForLinuxAppPath
mv -v HabboAirForLinux/HabboAirForLinux.png ~/.icons
mv -v HabboAirForLinux/HabboAirForLinux.desktop $HabboAirForLinuxAppPath/..
chmod -v +x $HabboAirForLinuxAppPath/HabboLauncher.sh
xdg-settings set default-url-scheme-handler habbo HabboAirForLinux.desktop

echo "[Installation finished]"
echo "Now you can use the HabboAirForLinux system shortcut or the Habbo Launch button from the web if your browser and system are compatible."
