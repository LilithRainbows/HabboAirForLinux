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
nohup sh -c "'HabboClient/Habbo' ${LauncherFinalArg} &"
