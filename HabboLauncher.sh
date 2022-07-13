#!/bin/sh

# Colours
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
PURPLE="\e[1;35m"
CYAN="\e[1;36m"
RESET_COLOUR="\e[0m"

cd "$(cd "$(dirname "$0")" && pwd)" # Set current path to script path

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

printf "$BLUE""[Collecting client information]""$RESET_COLOUR""\n"
printf "\n"
ClientUrls=$(wget https://habbo.com/gamedata/clienturls -q -O -)
if [ -z "$ClientUrls" ]; then
    printf "$RED""ERROR: Something happened and the request could not be received. Check the internet connection. Closing...""$RESET_COLOUR""\n"
    exit 1
else
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
        printf "$BLUE""[Downloading client]""$RESET_COLOUR""\n"
        printf "\n"
        wget $WinAirClientUrl -O HabboWin.zip
        printf "\n"
        printf "$BLUE""[Extracting client]""$RESET_COLOUR""\n"
        printf "\n"
        unzip -o HabboWin.zip -d "HabboClient" -x "Adobe AIR/*" "Habbo.exe"
        rm HabboWin.zip
        printf "\n"
        printf "$BLUE""[Patching client]""$RESET_COLOUR""\n"
        printf "\n"
        unzip -o HabboAirLinuxPatch.zip -d "HabboClient"
        chmod +x "HabboClient/Habbo"
        printf "\n"
    fi
    printf "$WinAirClientVer\n" > "$LocalClientVersionLoc"
fi

printf "$GREEN""[Launching Habbo client version $WinAirClientVer]""$RESET_COLOUR""\n"
nohup sh -c "'HabboClient/Habbo' ${LauncherFinalArg} &"
