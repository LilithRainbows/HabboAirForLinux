#!/bin/bash

LauncherArguments=$1

function ChangeToScriptDirectory() {
    cd "$(cd "$(dirname "$0")" && pwd)" 
}

function CheckArchitecture() {
SystemArchitecture=$(dpkg --print-architecture)
    if [ $SystemArchitecture != 'amd64' ]; then
    	echo "Wrong architecture, only x64 is supported!"
        exit
    fi
}

function CheckSystemDependencies() {
    echo "[Checking system dependencies]"
    if command -v dpkg >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
        #Debian based distro
        SystemDeps='unzip wget libnss3'
        for SystemDep in $SystemDeps; do
            if ! dpkg -S $SystemDep &> /dev/null; then
                echo "Trying to install: $SystemDep"
                sudo apt-get install -y -qq $SystemDep
            fi
        done
    elif command -v pacman >/dev/null 2>&1; then
        #Arch based distro
        SystemDeps='unzip wget nss'
        for SystemDep in $SystemDeps; do
            if ! pacman -Qs '$SystemDep' >/dev/null 2>&1; then
                echo "Trying to install: $SystemDep"
                sudo pacman -q --noconfirm -S $SystemDep
            fi
        done
    elif command -v zypper >/dev/null 2>&1; then
        #Suse based distro
        SystemDeps='unzip wget mozilla-nss'
        for SystemDep in $SystemDeps; do
            if ! zypper se -i -x $SystemDep >/dev/null 2>&1; then
                echo "Trying to install: $SystemDep"
                sudo zypper -n -q install $SystemDep
            fi
        done
    elif command -v yum >/dev/null 2>&1; then
        #RedHat based distro
        SystemDeps='unzip wget nss'
        for SystemDep in $SystemDeps; do
            if ! yum list installed $SystemDep &> /dev/null; then
                echo "Trying to install: $SystemDep"
                sudo yum install -y -q $SystemDep
            fi
        done
    else
        echo "Error: could not detect dependencies!"
    fi
}

function CheckClientUpdate() {
    echo "[Checking for client update]"
    RemoteClientData=$(wget https://habbo.com/gamedata/clienturls -q -O -)
    RemoteClientVersion=$RemoteClientData
    RemoteClientVersion=${RemoteClientVersion#*'"flash-windows-version":"'}
    RemoteClientVersion=${RemoteClientVersion%%'"'*}
    RemoteClientUrl=$RemoteClientData
    RemoteClientUrl=${RemoteClientUrl#*'"flash-windows":"'}
    RemoteClientUrl=${RemoteClientUrl%%'"'*}
    LocalClientVersionFile="HabboClient/VERSION.txt"
    LocalClientVersion="0"
    if test -f "$LocalClientVersionFile"; then
        LocalClientVersion=$(cat "$LocalClientVersionFile")
    fi
    if [ "$RemoteClientVersion" != "$LocalClientVersion" ]; then
        echo "Downloading client"
        wget -q $RemoteClientUrl -O HabboWin.zip
        echo "Extracting client"
        unzip -q -o HabboWin.zip -d "HabboClient" -x "Adobe AIR/*" "META-INF/signatures.xml" "META-INF/AIR/hash" "Habbo.exe"
        rm HabboWin.zip
        echo "Patching client"
        unzip -q -o HabboAirLinuxPatch.zip -d "HabboClient"
        chmod +x "HabboClient/Habbo"
        NewXmlClientVersion=$(cat "HabboClient/META-INF/AIR/application.xml")
        NewXmlClientVersion=${NewXmlClientVersion#*"<versionLabel>"}
        NewXmlClientVersion=${NewXmlClientVersion%%"</versionLabel>"*}
        SafeXmlClientApplication=$(cat "HabboClient/application.xml")
        SafeXmlClientApplication=${SafeXmlClientApplication//XML_CLIENT_VERSION/$NewXmlClientVersion}
        rm -f "HabboClient/application.xml"
        echo "$SafeXmlClientApplication">"HabboClient/META-INF/AIR/application.xml"
        echo $RemoteClientVersion > "$LocalClientVersionFile"
    else
        echo "Already using the latest version!"
    fi
}

function LaunchClient() {
    if [[ "$LauncherArguments" == *"token="* ]]; then
        LauncherServer=$LauncherArguments
        LauncherServer=${LauncherServer#*'server='}
        LauncherServer=${LauncherServer%%'&'*}
        LauncherTicket=$LauncherArguments
        LauncherTicket=${LauncherTicket#*'token='}
        LauncherTicket=${LauncherTicket%%'&'*}
        LauncherArguments="-server $LauncherServer -ticket $LauncherTicket"
    fi
    echo "[Launching Habbo Client]"
    setsid -f "HabboClient/Habbo" ${LauncherArguments} >/dev/null 2>&1;
}

#Main script
ChangeToScriptDirectory
CheckArchitecture
CheckSystemDependencies
CheckClientUpdate
LaunchClient
