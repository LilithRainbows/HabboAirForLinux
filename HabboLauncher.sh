#!/bin/bash

cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path

LauncherArg=$1
LauncherFinalArg=""

if [[ "$LauncherArg" == *"token="* ]]; then
    LauncherServer=$LauncherArg
    LauncherServer=${LauncherServer#*'server='}
    LauncherServer=${LauncherServer%%'&'*}
    LauncherTicket=$LauncherArg
    LauncherTicket=${LauncherTicket#*'token='}
    LauncherTicket=${LauncherTicket%%'&'*}
    LauncherFinalArg="-server $LauncherServer -ticket $LauncherTicket"
fi

echo "[Checking dependencies]"
pkgs='unzip wget libnss3'
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

echo "[Collecting client information]"
ClientUrls=$(wget https://habbo.com/gamedata/clienturls -q -O -)
WinAirClientVer=$ClientUrls
WinAirClientVer=${WinAirClientVer#*'"flash-windows-version":"'}
WinAirClientVer=${WinAirClientVer%%'"'*}
WinAirClientUrl=$ClientUrls
WinAirClientUrl=${WinAirClientUrl#*'"flash-windows":"'}
WinAirClientUrl=${WinAirClientUrl%%'"'*}
LocalClientVersionLoc="HabboClient/VERSION.txt"
LocalClientVersion="0"
if test -f "$LocalClientVersionLoc"; then
    LocalClientVersion=$(cat "$LocalClientVersionLoc")
fi
if [ "$WinAirClientVer" != "$LocalClientVersion" ]; then
    echo "[Downloading client]"
    wget $WinAirClientUrl -O HabboWin.zip
    echo "[Extracting client]"
    unzip -o HabboWin.zip -d "HabboClient" -x "Adobe AIR/*" "Habbo.exe"
    rm HabboWin.zip
    echo "[Patching client]"
    unzip -o HabboAirLinuxPatch.zip -d "HabboClient"
    chmod +x "HabboClient/Habbo"
fi
echo $WinAirClientVer > "$LocalClientVersionLoc"

echo "[Launching Habbo client version $WinAirClientVer]"
nohup bash -c "'HabboClient/Habbo' ${LauncherFinalArg} &"
