#!/bin/bash

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
            if ! pacman -Qs $SystemDep >/dev/null 2>&1; then
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

function InstallHabboLauncher() {
    echo "[Installing Habbo Launcher]"
    HabboLinuxAppPath="$HOME/.local/share/applications/HabboAirForLinux"
    LinuxIconPath="$HOME/.icons"
    rm -f -r $HabboLinuxAppPath
    mkdir -p $HabboLinuxAppPath
    mkdir -p $LinuxIconPath
    HabboLinuxDepsFilenames=(HabboAirLinuxPatch.zip HabboLauncher.sh HabboAirForLinux.png HabboAirForLinux.desktop)
    HabboLinuxDepsDestinations=($HabboLinuxAppPath $HabboLinuxAppPath $LinuxIconPath "$HabboLinuxAppPath/..")
    for HabboLinuxDepIndex in "${!HabboLinuxDepsFilenames[@]}"
    do
    	if [ -f "${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" ]; then
            echo "Copying: ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
    		cp -rf "${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" "${HabboLinuxDepsDestinations[$HabboLinuxDepIndex]}/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
    	else
            echo "Downloading: ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
	    	wget -q "https://github.com/LilithRainbows/HabboAirForLinux/raw/main/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" -O "${HabboLinuxDepsDestinations[$HabboLinuxDepIndex]}/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
	    fi
    done
    chmod +x "${HabboLinuxDepsDestinations[1]}/${HabboLinuxDepsFilenames[1]}"
    chmod +x "${HabboLinuxDepsDestinations[3]}/${HabboLinuxDepsFilenames[3]}"
    if command -v xdg-user-dir >/dev/null 2>&1; then
        LinuxDesktopPath="$(xdg-user-dir DESKTOP)"
        echo "Creating desktop shortcut"
        cp -rf "${HabboLinuxDepsDestinations[3]}/${HabboLinuxDepsFilenames[3]}" "$LinuxDesktopPath"
        chmod +x "$LinuxDesktopPath/${HabboLinuxDepsFilenames[3]}"
    else
        echo "Error: unable to create desktop shortcut"
    fi
    if command -v xdg-settings >/dev/null 2>&1; then
        echo "Registering habbo protocol"
        xdg-settings set default-url-scheme-handler habbo ${HabboLinuxDepsFilenames[3]}
    else
        echo "Error: unable to register habbo protocol"
    fi
    echo "[Installation finished]"
    echo "Now you can use the Habbo Launcher system shortcut or the Habbo Launch button from the web if your browser and system are compatible."
}

#Main script
ChangeToScriptDirectory
CheckArchitecture
CheckSystemDependencies
InstallHabboLauncher


