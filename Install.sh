#!/bin/bash

function ChangeToScriptDirectory() {
    cd "$(cd "$(dirname "$0")" && pwd)" 
}

function DownloadLocales() {
	true
}

function CheckLocales() {
	if [ -e ./locale_install ]; then
		Locale=$(echo $LANG | sed 's/\(..\).*/\1/')
	#	if [ -e ./locale_install/$Locale ]; then
		#	echo $(sed -n '1p' ./locale_install/$Locale)
		#else
		#	echo "Using default locale"
	#	fi
	#else
	#	echo "Using default locale"
	fi
	}

function CheckMultipleArguments() {
    if [ "$#" -gt 1 ]; then
        echo "Please use one argument."
        exit 1 
    fi
}


function CheckArchitecture() { #erased dpkg dependency
	SystemArchitecture=$HOSTTYPE
	if [ "$Locale" != default ]; then
		echo -e "\e[36m$(sed -n '2p' ./locale_install/$Locale)\e[0m"
	else
		echo -e "\e[36m[Checking System Architecture]\e[0m"
	fi
    if [ $SystemArchitecture != 'x86_64' ] && [ $SystemArchitecture != 'aarch64' ]; then
    	if [ "$Locale" != default ]; then
			echo $(sed -n '3p' ./locale_install/$Locale)
		else
    		echo "Wrong architecture, only x86_64 and aarch64 is supported!"
    	fi
    	exit 1
    elif [ "$SystemArchitecture" = 'x86_64' ]; then
    	if [ "$Locale" != default ]; then
			echo $(sed -n '4p' ./locale_install/$Locale)
		else
    		echo "Found x86_64 Linux."
    	fi
    elif [ "$SystemArchitecture" = 'aarch64' ]; then
    	if [ "$Locale" != default ]; then
			echo $(sed -n '25p' ./locale_install/$Locale)
		else
    		echo "Found Arm64 Linux."
    	fi
    fi
}

function CheckLibC() {
        if ldd --version 2>&1 | grep -iq "GNU" || ldd --version 2>&1 | grep -iq "Gentoo" || ldd --version 2>&1 | grep -iq "GLIBC" ; then
        	if [ "$Locale" != default ]; then
				echo $(sed -n '5p' ./locale_install/$Locale)
			else
        		echo "Gnu libc is found."
        	fi
        elif ldd --version 2>&1 | grep -q "musl" ; then
        	if [ "$Locale" != default ]; then
				echo $(sed -n '22p' ./locale_install/$Locale)
			else
        		echo "Musl libc is found. HabboAirForLinux isn't compatible with this library."
        	fi
        else
        	if [ "$Locale" != default ]; then
				echo $(sed -n '6p' ./locale_install/$Locale)
			else
        		echo "No glibc based linux"
        	fi 
        	exit 1
        fi
        }

function TestWGET() { #defines the downloader application.
    if command -v wget >/dev/null 2>&1; then
        if [ "$Locale" != default ]; then
				echo $(sed -n '7p' ./locale_install/$Locale)
			else
        	echo "Wget is installed. Procedding"
        fi 
        Downloader=wget
    else
        if command -v curl >/dev/null 2>&1; then
        	if [ "$Locale" != default ]; then
				echo $(sed -n '8p' ./locale_install/$Locale)
			else
        	echo "Curl is installed. Procedding"
        	fi 
        	Downloader=curl
        else
        	if [ "$Locale" != default ]; then
				echo $(sed -n '9p' ./locale_install/$Locale)
			else
        		echo "The script wouldn't download files. Wget or Curl is not installed."
        	fi 
        	exit 1
        fi
    fi
}


function InstallHabboLauncher() {
    if [ "$Locale" != default ]; then
		echo -e "\e[36m$(sed -n '12p' ./locale_install/$Locale)\e[0m"
	else
   		echo -e "\e[36m[Installing Habbo Launcher]\e[0m"
    fi
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
            if [ "$Locale" != default ]; then
            	echo $(sed -n '13p' ./locale_install/$Locale) ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}
            else
            	echo "Copying: ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
            fi
    		cp -rf "${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" "${HabboLinuxDepsDestinations[$HabboLinuxDepIndex]}/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
    	else
    		if [ "$Locale" != default ]; then
            	echo $(sed -n '14p' ./locale_install/$Locale) ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}
    		else
            	echo "Downloading: ${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
            fi
	    		if [ "$Downloader" = "wget" ]; then #if wget is installed.
	    			wget -q "https://github.com/LilithRainbows/HabboAirForLinux/raw/refs/heads/gabo/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" -O "${HabboLinuxDepsDestinations[$HabboLinuxDepIndex]}/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
	    		elif [ "$Downloader" = "curl" ]; then #if only curl is present.
	    			curl -sL "https://github.com/LilithRainbows/HabboAirForLinux/raw/refs/heads/gabo/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}" -o "${HabboLinuxDepsDestinations[$HabboLinuxDepIndex]}/${HabboLinuxDepsFilenames[$HabboLinuxDepIndex]}"
	    		fi 
	    fi
    done
    chmod +x "${HabboLinuxDepsDestinations[1]}/${HabboLinuxDepsFilenames[1]}"
    chmod +x "${HabboLinuxDepsDestinations[3]}/${HabboLinuxDepsFilenames[3]}"
    if command -v xdg-user-dir >/dev/null 2>&1; then
        LinuxDesktopPath="$(xdg-user-dir DESKTOP)"
        if [ "$Locale" != default ]; then
            	echo -e "\e[36m$(sed -n '15p' ./locale_install/$Locale)\e[0m"
    	else
        	echo -e "\e[36m[Creating desktop shortcut]\e[0m"
        fi
        cp -rf "${HabboLinuxDepsDestinations[3]}/${HabboLinuxDepsFilenames[3]}" "$LinuxDesktopPath"
        chmod +x "$LinuxDesktopPath/${HabboLinuxDepsFilenames[3]}"
    else
    	if [ "$Locale" != default ]; then
            	echo $(sed -n '16p' ./locale_install/$Locale)
    	else
        	echo "Error: unable to create desktop shortcut."
        fi
    fi
    if command -v xdg-settings >/dev/null 2>&1; then
    	if [ "$Locale" != default ]; then
            echo -e "\e[36m$(sed -n '17p' ./locale_install/$Locale)\e[0m"
    	else
        	echo -e "\e[36m[Registering habbo protocol]\e[0m"
        fi
        xdg-settings set default-url-scheme-handler habbo ${HabboLinuxDepsFilenames[3]}
    else
        if [ "$Locale" != default ]; then
            echo $(sed -n '18p' ./locale_install/$Locale)
    	else
       		echo "Error: unable to register habbo protocol"
       	fi
    fi
    if [ "$Locale" != default ]; then
            echo $(sed -n '23p' ./locale_install/$Locale)
    	else
        	echo "Do you like to add a symlink to HabboLauncher in PATH to launcher it from terminal? (yes/no)"
        fi
    read Answer
    if [ "$Answer" = "yes" ]; then
    	rm -rf $HOME/.local/bin/HabboLauncher > /dev/null
    	if ! [ -d $HOME/.local/bin ]; then
    		mkdir -p $HOME/.local/bin
   	 fi
    	if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then #Adds $HOME/bin to the user's PATH
	   	 echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        fi
    ln -s $HabboLinuxAppPath/HabboLauncher.sh $HOME/.local/bin/HabboLauncher #Creates symlink to the Launcher on $HOME/bin
    chmod +x $HOME/.local/bin/HabboLauncher
    if [ "$Locale" != default ]; then
            echo $(sed -n '24p' ./locale_install/$Locale)
    	else
   		echo 'Now you can launch "HabboLauncher" typing it on the terminal.'
        fi 

    fi
}

function CreatingPlusFlag () { #creates a helper file to define the version of Habbo that the launcher will download.
    if [ "$1" = "plus" ] || [ "$1" = "--plus" ]; then
    	if [ "$Locale" != default ]; then
            echo -e "\e[36m$(sed -n '19p' ./locale_install/$Locale)\e[0m"
    	else
    		echo -e "\e[36m[Preparing patch for Habbo Air Plus]\e[0m"
    	fi
        touch "$HabboLinuxAppPath/plus_flag"
	rm "$HabboLinuxAppPath/plus_installed" &> /dev/null        
	rm "$HabboLinuxAppPath/first_download" &> /dev/null
    elif [ "$1" = "classic" ] || [ "$1" = "--classic" ] ; then
        if [ -e "$HabboLinuxAppPath/plus_flag" ]; then
            rm "$HabboLinuxAppPath/plus_flag"
        fi
	rm "$HabboLinuxAppPath/plus_installed" &> /dev/null
        touch "$HabboLinuxAppPath/first_download"
    else
        if [ -e "$HabboLinuxAppPath/plus_flag" ]; then
            rm "$HabboLinuxAppPath/plus_flag"
        fi
        touch "$HabboLinuxAppPath/first_download"
	rm "$HabboLinuxAppPath/plus_installed" &> /dev/null
    fi
}

function Finished () { 
    if [ "$Locale" != default ]; then
        echo -e "\e[36m$(sed -n '20p' ./locale_install/$Locale)\e[0m"
        echo $(sed -n '21p' ./locale_install/$Locale)
    else
    	echo -e "\e[36m[Installation finished]\e[0m"
    	echo "Now you can use the Habbo Launcher system shortcut or the Habbo Launch button from the web if your browser and system are compatible."
    fi
}


#Main script
Locale=default
CheckMultipleArguments "$#"
ChangeToScriptDirectory
DownloadLocales
CheckLocales
CheckArchitecture
CheckLibC
TestWGET
InstallHabboLauncher
CreatingPlusFlag "$1"
Finished


