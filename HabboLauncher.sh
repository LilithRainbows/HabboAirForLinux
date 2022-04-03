#!/bin/bash
cd "$(cd "$(dirname "$0")" && pwd)" #Set current path to script path
GREEN="\033[1;32m" #Green color
NOCOLOR='\033[0m' # No color
echo ${GREEN}"Checking dependencies ..."${NOCOLOR}
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
echo ${GREEN}Collecting client information ...${NOCOLOR}
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
    echo ${GREEN}Downloading client ...${NOCOLOR}
    wget $WinAirClientUrl -O HabboWin.zip
    echo ${GREEN}Extracting client ...${NOCOLOR}
    unzip -o HabboWin.zip -d "HabboClient" -x "Adobe AIR/*" "Habbo.exe"
    rm HabboWin.zip
    echo ${GREEN}Patching client ...${NOCOLOR}
    unzip -o HabboAirLinuxPatch.zip -d "HabboClient"
    chmod +x "HabboClient/Habbo"
fi
echo $WinAirClientVer > "$LocalClientVersionLoc"
echo ${GREEN}Launching Habbo client version "$WinAirClientVer" ...${NOCOLOR}
"HabboClient/Habbo"
