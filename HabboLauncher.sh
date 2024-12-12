#!/bin/bash

LauncherArguments=$1
HabboLinuxAppPath="$HOME/.local/share/applications/HabboAirForLinux"
ClassicArm64Link="https://github.com/LilithRainbows/HabboAirForLinux/releases/download/beta/HabboAirForLinux_BetaRelease_arm64.zip"
PlusArm64Link="https://github.com/LilithRainbows/HabboAirPlus/releases/download/latest/HabboAirPlus_Linux_arm64.zip"

if ! [ -d $HabboLinuxAppPath ]; then
	mkdir "$HabboLinuxAppPath"
fi
Locale=default
cd "$HabboLinuxAppPath" 

function CheckMultipleArguments() {
    if [ "$#" -gt 1 ]; then
	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '3p' "$HabboLinuxAppPath/locale_launcher/$Locale")
	else
        	echo "Please use one argument."
	fi        
	exit 1 
    fi
}

function CheckHelp() {
    if [ "$1" = "help" ] || [ "$1" = "--help" ]; then
	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo  "$(sed -n '4p' "$HabboLinuxAppPath/locale_launcher/$Locale")"
		echo -e "\e[3m$(sed -n '5p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
		echo "  " $(sed -n '6p' "$HabboLinuxAppPath/locale_launcher/$Locale")
		echo "  " $(sed -n '7p' "$HabboLinuxAppPath/locale_launcher/$Locale")
		echo "  " $(sed -n '8p' "$HabboLinuxAppPath/locale_launcher/$Locale")
	else        
		echo "HabboLauncher is a script for Habbo Client, that works as wrapper to download and patch the Habbo Client version for Windows for making it work on GNU/Linux."
        	echo -e "\e[3mArguments\e0m"
        	echo "  --classic: Forces the download of the official HabboClient and patches it"
        	echo "  --plus: Patch the client to get the LilithRainbow's Habbo Air Plus client"
        	echo "  --remove: Removes the script, the client, and the desktop icons."
	fi        
	exit  
    fi
}



function DownloadLocales() {
	true
}

function CheckLocales() {
	if [ -e "$HabboLinuxAppPath/locale_launcher" ]; then
		Locale=$(echo $LANG | sed 's/\(..\).*/\1/')
		if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			#echo $(sed -n '1p' "$HabboLinuxAppPath/locale_launcher/$Locale")
			true
		else
			#echo "Using default locale"
			true
		fi
	else
		true
		# echo "Using default locale"
	fi
	}


function CheckArchitecture() { #erased dpkg dependency
    SystemArchitecture=$HOSTTYPE
    if [ "$SystemArchitecture" != 'x86_64' ] && [ "$SystemArchitecture" != 'aarch64' ]; then
        if [ "$Locale" != default ]; then
            echo $(sed -n '2p' ./locale_launcher/$Locale)
        else
            echo "Wrong architecture, only x86_64 and aarch64 are supported!"
        fi
        exit 1
    elif [ "$SystemArchitecture" = 'x86_64' ]; then
        if [ "$Locale" != default ]; then
            echo $(sed -n '31p' ./locale_launcher/$Locale)
        else
            echo "Found x86_64 Linux."
        fi
        Architecture='x86_64'
    elif [ "$SystemArchitecture" = 'aarch64' ]; then
        if [ "$Locale" != default ]; then
            echo $(sed -n '32p' ./locale_launcher/$Locale)
        else
            echo "Found Arm64 Linux."
        fi
        Architecture='arm64'
    fi
}

function CheckLibC() {
        if ldd --version 2>&1 | grep -qi "GNU" || ldd --version 2>&1 | grep -qi "Gentoo" || ldd --version 2>&1 | grep -qi "GLIBC" ; then
	 	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '10p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
		else		
			echo "Glibc recognized"
		fi
        else
		if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '11p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
		else		
		echo "No glibc based linux recognized" 
		fi        	
        	exit 1
        fi
        }

function TestWGET() { #defines the downloader application.
    if command -v wget >/dev/null 2>&1; then
       if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '13p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
	else
		echo "Wget is installed. Procedding"
	fi
        Downloader=wget
    else
            if command -v curl >/dev/null 2>&1; then
			if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
				echo $(sed -n '14p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
			else
        			echo "Curl is installed. Procedding"
			fi        		
			Downloader=curl
        	else
			if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
				echo $(sed -n '15p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
			else
	        		echo "Can't download. Wget or Curl is not installed."
			fi
        		exit 1
        	fi
    fi
}

function DetectPatch() {
	if ! [ -e ./HabboAirLinuxPatch.zip ]; then
		if [ "$Downloader" = "wget" ]; then
			wget -q "https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirLinuxPatch.zip" -O $HabboLinuxAppPath/HabboAirLinuxPatch.zip
		elif [ "$Downloader" = "curl" ]; then
			curl -sL "https://github.com/LilithRainbows/HabboAirForLinux/raw/main/HabboAirLinuxPatch.zip" -o $HabboLinuxAppPath/HabboAirLinuxPatch.zip
		else
			if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
				echo $(sed -n '16p' "$HabboLinuxAppPath/locale_launcher/$Locale")       	
			else		     
				echo "Can't find patch or can't download it. Wget or Curl is not installed."
			fi		
		fi
	else
		true
	fi
	}

function CheckSystemDependencies() { #removed only wget dependency
     if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
	echo -e "\e[36m$(sed -n '17p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"       	
     else	 
	echo -e "\e[36m[Checking system dependencies]\e[0m"
    fi
    if command -v dpkg >/dev/null 2>&1 && command -v apt-get && [ -z "$(command -v pacman)" ] && [ -z "$(command -v xbps-install)" ] >/dev/null 2>&1; then
        #Debian based distro
        if [ "$(cat /etc/os-release | grep -i "^ID=")" = "ID=ubuntu" ]; then
       	 SystemDeps='unzip libnss3 libgtk2.0-bin libgtk2.0-common'
       	else 
		SystemDeps='unzip libnss3 gtk+2.0'
       	fi
        for SystemDep in $SystemDeps; do
            if ! dpkg -S $SystemDep &> /dev/null; then
                if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     		else	 
			echo "Trying to install: $SystemDep"
		fi
                sudo apt-get install -y -qq $SystemDep
            fi
        done
    elif command -v pacman && [ -z "$(command -v xbps-install)" ] && [ -z "$(command -v apt)" ] && [ -z "$(command -v yum)" ] >/dev/null 2>&1; then
        #Arch based distro
        SystemDeps='unzip nss gtk2'
        for SystemDep in $SystemDeps; do
            if [[ $(pacman -Qq "$SystemDep" 2>/dev/null) != "$SystemDep" ]]; then
                 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     		else	 
			echo "Trying to install: $SystemDep"
		fi
                sudo pacman -q --noconfirm -Sy $SystemDep
            fi
        done
    elif command -v zypper >/dev/null 2>&1; then
        #Suse based distro
        SystemDeps='unzip mozilla-nss gtk2'
        for SystemDep in $SystemDeps; do
            if ! zypper se -i -x $SystemDep >/dev/null 2>&1; then
                 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     		else	 
			echo "Trying to install: $SystemDep"
		fi
                sudo zypper -n -q install $SystemDep
            fi
        done
    elif command -v yum >/dev/null 2>&1; then
        #RedHat based distro
        SystemDeps='unzip nss gtk2'
        for SystemDep in $SystemDeps; do
            if ! yum list installed $SystemDep &> /dev/null; then
                 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     		else	 
			echo "Trying to install: $SystemDep"
		fi
                sudo yum install -y -q $SystemDep
            fi
        done
    elif command -v xbps-install && [ -z "$(command -v pacman)" ] && [ -z "$(command -v apt)" ] && [ -z "$(command -v yum)" ]>/dev/null 2>&1; then
        #Added Void based distro
        if ldd --version 2>&1 | grep -q "GNU"; then
  		echo "Void with Glib-c detected. Proceed"
		SystemDeps='libpoppler unzip gtk+ nss'
       		for SystemDep in $SystemDeps; do
          		if [ -z "$(xbps-query -s "$SystemDep"-)" ]; then
                		 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
					echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     				else	 
					echo "Trying to install: $SystemDep"
				fi
				sudo xbps-install -SAyu xbps
               	 		sudo xbps-install -SAy $SystemDep
               		 fi
            	done
        else #exclude the void linux version based on musl libc
            echo "Another libc detected. Can't procceed with installation."
            exit 1
        fi
    elif command -v emerge >/dev/null 2>&1; then
        #Gentoo based distro
        SystemDeps='app-arch/unzip dev-libs/nss dev-perl/Gtk2'
        for SystemDep in $SystemDeps; do
            if [ -z "$(equery l $SystemDep 2> /dev/null | grep $SystemDep 2> /dev/null )" ]; then
                 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
			echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     		else	 
			echo "Trying to install: $SystemDep"
		fi
                sudo emerge --ask $SystemDep
            fi
        done
    elif [ -f /etc/slackware-version ]; then
    #Slackware needs root elevation, sudo don't work
        if [[ $EUID -ne 0 ]]; then
            # If not running as root, execute the script with sudo
            if command -v sudo >/dev/null 2>&1; then
                echo "This script requires root privileges. Elevating..."
                sudo -i "$(readlink -f $0)" "$@"
                exit $?

            else
                echo "This script must be run as root. Please use sudo or switch to root user."
                exit 1
            fi
        fi

    # Slackware installer
        if command -v slackpkg >/dev/null 2>&1; then
            # Slackware
            SystemDeps='infozip mozilla-nss'
            SystemDeps2='gtk+'
            for SystemDep in $SystemDeps; do
                if [ -n "$(slackpkg search "$SystemDep" | grep -w "$SystemDep" | grep -E "uninstalled|No package")" ] ; then
                     if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
				echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep       	
     			else	 
				echo "Trying to install: $SystemDep"
			fi
                    sudo rm -rf /var/lock/slackpkg.*  &> /dev/null
                    slackpkg install $SystemDep 2> /dev/null
                fi
            done
            for SystemDep2 in $SystemDeps2; do # makes explicitly install gtk2
                if [ -n "$(slackpkg search "$SystemDep2" | grep -w "gtk+2" | grep -E "uninstalled|No package")" ] ; then
			 if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
				echo $(sed -n '18p' "$HabboLinuxAppPath/locale_launcher/$Locale") $SystemDep2     	
     			else	 
				echo "Trying to install: $SystemDep2"
			fi                    
                    sudo rm -rf /var/lock/slackpkg.*  &> /dev/null
                    slackpkg install gtk+2 2> /dev/null
                fi
            done
        fi
   else
       if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '21p' "$HabboLinuxAppPath/locale_launcher/$Locale")        	
     	else	 
      	  	echo "Error: could not detect dependencies! Please, try to install gtk2, nss, unzip and wget"
	fi
   fi
}


function TestUnzip() {
    if command -v unzip >/dev/null 2>&1; then
	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '19p' "$HabboLinuxAppPath/locale_launcher/$Locale")        	
     	else	 
      	  echo "Unzip is installed. Procedding"
	fi

    else
	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '20p' "$HabboLinuxAppPath/locale_launcher/$Locale")      	
     	else	 
       		 echo "Can't extract. Unzip is not installed."
	fi
        exit 1
    fi
}

function CheckClientUpdate() {
    if ! [ -e $HabboLinuxAppPath/plus_flag ] && [ "$Architecture" = "x86_64" ]; then
        if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
            echo -e "\e[36m$(sed -n '23p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
        else
            echo -e "\e[36m[Checking for client update]\e[0m"
        fi
        
        if [ "$Downloader" = "wget" ]; then
            RemoteClientData=$(wget https://habbo.com/gamedata/clienturls -q -O -)
        elif [ "$Downloader" = "curl" ]; then
            RemoteClientData=$(curl -sL https://habbo.com/gamedata/clienturls)
        else
            if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
                echo $(sed -n '24p' "$HabboLinuxAppPath/locale_launcher/$Locale")
            else
                echo "Wget/curl error."
                exit 1
            fi
        fi
        
        RemoteClientVersion=$RemoteClientData
        RemoteClientVersion=${RemoteClientVersion#*'"flash-windows-version":"'}
        RemoteClientVersion=${RemoteClientVersion%%'"'*}
        RemoteClientUrl=$RemoteClientData
        RemoteClientUrl=${RemoteClientUrl#*'"flash-windows":"'}
        RemoteClientUrl=${RemoteClientUrl%%'"'*}
        LocalClientVersionFile="$HabboLinuxAppPath/HabboClient/VERSION.txt"
        LocalClientVersion="0"
        
        if test -f "$LocalClientVersionFile"; then
            LocalClientVersion=$(cat "$LocalClientVersionFile")
        fi
        
        if [ "$RemoteClientVersion" != "$LocalClientVersion" ] || [ -e "$HabboLinuxAppPath/first_download" ]; then
            if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
               	 	echo $(sed -n '25p' "$HabboLinuxAppPath/locale_launcher/$Locale")
         	   else
               		 echo "Downloading client"
            fi
            
            if [ "$Downloader" = "wget" ]; then
                	rm "$HabboLinuxAppPath/HabboWin.zip" &> /dev/null
               		 wget -q "$RemoteClientUrl" -O "$HabboLinuxAppPath/HabboWin.zip"
           	 elif [ "$Downloader" = "curl" ]; then
                	rm "$HabboLinuxAppPath/HabboWin.zip" &> /dev/null
                	curl -sL "$RemoteClientUrl" -o "$HabboLinuxAppPath/HabboWin.zip"
            else
                if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
                    echo $(sed -n '24p' "$HabboLinuxAppPath/locale_launcher/$Locale")
                else
                    echo "Wget/curl error."
                    exit 1
                fi
            fi
            
            if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
               	 	echo $(sed -n '26p' "$HabboLinuxAppPath/locale_launcher/$Locale")
           	 else
               	 	echo "Extracting client"
            fi
            
            unzip -q -o $HabboLinuxAppPath/HabboWin.zip -d "$HabboLinuxAppPath/HabboClient" -x "Adobe AIR/*" "META-INF/signatures.xml" "META-INF/AIR/hash" "Habbo.exe"
            
            if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
                	echo $(sed -n '27p' "$HabboLinuxAppPath/locale_launcher/$Locale")
            	else
                	echo "Patching client"
            fi
            
            unzip -q -o $HabboLinuxAppPath/HabboAirLinuxPatch.zip -d "$HabboLinuxAppPath/HabboClient"
            chmod +x "$HabboLinuxAppPath/HabboClient/Habbo"
            NewXmlClientVersion=$(cat "$HabboLinuxAppPath/HabboClient/META-INF/AIR/application.xml")
            NewXmlClientVersion=${NewXmlClientVersion#*"<versionLabel>"}
            NewXmlClientVersion=${NewXmlClientVersion%%"</versionLabel>"*}
            SafeXmlClientApplication=$(cat "$HabboLinuxAppPath/HabboClient/application.xml")
            SafeXmlClientApplication=${SafeXmlClientApplication//XML_CLIENT_VERSION/$NewXmlClientVersion}
            rm -f "$HabboLinuxAppPath/HabboClient/application.xml"  &> /dev/null
            echo "$SafeXmlClientApplication" > "$HabboLinuxAppPath/HabboClient/META-INF/AIR/application.xml"
            echo $RemoteClientVersion > "$LocalClientVersionFile"
            rm -rf $HabboLinuxAppPath/first_download &> /dev/null
        else
            if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
                echo $(sed -n '28p' "$HabboLinuxAppPath/locale_launcher/$Locale")
            else
                echo "Already using the latest version!"
            fi
        fi
    elif ! [ -e $HabboLinuxAppPath/plus_flag ] && [ "$Architecture" = "arm64" ]; then # install habbo classic port to arm64 linux

	date_check="$(date "+%Y-%m-%d")"
	actual_commit="$(head -n 1 $HabboLinuxAppPath/classic_installed)"
	date_commit="$(tail -n 1 $HabboLinuxAppPath/classic_installed)" 
		if  [[ "$date_check" != "$date_commit" ]]; then
			if [ "$Downloader" = "wget" ] && [ "$date_commit" != "$date_check" ]; then
				commit_version="$(wget -q -O - "https://api.github.com/repos/LilithRainbows/HabboAirForLinux/commits?per_page=1" | grep sha | head -n 1 | cut -d"\"" -f4 )"
			elif [ "$Downloader" = "curl" ] && [ "$date_commit" != "$date_check" ]; then
				commit_version="$(curl -s "https://api.github.com/repos/LilithRainbows/HabboAirForLinux/commits?per_page=1" | grep sha | head -n 1 | cut -d"\"" -f4 )"
			fi
			if [ "$Locale" != default ]; then
        	    		echo -e "\e[36m$(sed -n '23p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
    			else
    				echo -e "\e[36m[Checking Habbo Air For Linux updates]\e[0m"
    			fi 
		if ! [ "$actual_commit" = "$commit_version" ]; then	
		        if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
           			 echo $(sed -n '25p' "$HabboLinuxAppPath/locale_launcher/$Locale")
        		else
          		 	 echo "Downloading client"
       			 fi
       			if [ "$Downloader" = "wget" ]; then
            				wget -q $ClassicArm64Link -O "$HabboLinuxAppPath/HabboAirarm64.zip"
        			elif [ "$Downloader" = "curl" ]; then
           	 			curl -sL $ClassicArm64Link -o "$HabboLinuxAppPath/HabboAirarm64.zip"
        		fi
        		if [ -d $HabboLinuxAppPath/HabboClient ]; then
        			rm -rf $HabboLinuxAppPath/HabboClient  &> /dev/null
        		fi
      		  		unzip -q -o "$HabboLinuxAppPath/HabboAirarm64.zip" -d "$HabboLinuxAppPath/HabboClient"
        			mv -f "$HabboLinuxAppPath/HabboClient/HabboAirForLinux_BetaRelease_arm64/"* "$HabboLinuxAppPath/HabboClient" && rm -rf $HabboLinuxAppPath/HabboClient/HabboAirForLinux_BetaRelease_arm64 && chmod +x "$HabboLinuxAppPath/HabboClient/Habbo"
        			echo "$commit_version" > "$HabboLinuxAppPath/classic_installed"
        			date "+%Y-%m-%d" >> "$HabboLinuxAppPath/classic_installed"
        			rm $HabboLinuxAppPath/plus_flag  &> /dev/null; rm $HabboLinuxAppPath/plus_installed  &> /dev/null; rm $HabboLinuxAppPath/first_download  &> /dev/null
        		fi
        	fi
  	 fi
   
   
}

function CheckPlusUpdate() { #to fetch plus versions
if [ -e $HabboLinuxAppPath/plus_flag ]; then
	date_check="$(date "+%Y-%m-%d")"
	if [ -e "$HabboLinuxAppPath/plus_installed" ]; then
  		date_commit="$(tail -n 1 $HabboLinuxAppPath/plus_installed)" 
		actual_commit="$(head -n 1 $HabboLinuxAppPath/plus_installed)"
		if  [[ "$date_check" != "$date_commit" ]]; then
			if [ "$Locale" != default ]; then
        	    			echo -e "\e[36m$(sed -n '29p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
    				else
    					echo -e "\e[36m[Checking Habbo Air Plus updates]\e[0m"
    			fi 
	fi		 
		if [ "$Downloader" = "wget" ]; then	
			commit_version="$(wget -q -O - "https://api.github.com/repos/LilithRainbows/HabboAirPlus/commits?per_page=1" | grep sha | head -n 1 | cut -d"\"" -f4 )"
			if  [[ "$actual_commit" != "$commit_version" ]]; then
				if [ "$Locale" != default ]; then
        	    			echo $(sed -n '30p' "$HabboLinuxAppPath/locale_launcher/$Locale")
    				else
					echo "Updating Habbo Air Plus"
				fi
				rm -rf $HabboLinuxAppPath/HabboClient/ $HabboLinuxAppPath/plus_installed  &> /dev/null $HabboLinuxAppPath/HabboAirPlus_Linux.zip
				if [ "$Architecture" = "x86_64" ]; then
					wget -q https://github.com/LilithRainbows/HabboAirPlus/releases/download/latest/HabboAirPlus_Linux_x64.zip -O $HabboLinuxAppPath/HabboAirPlus_Linux.zip
					unzip -q -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip && mkdir $HabboLinuxAppPath/HabboClient && mv $HabboLinuxAppPath/HabboAirPlus_Linux_x64/* $HabboLinuxAppPath/HabboClient/ && rm $HabboLinuxAppPath/HabboAirPlus_Linux_x64/  &> /dev/null
				elif [ "$Architecture" = "arm64" ]; then
					wget -q $PlusArm64Link -O $HabboLinuxAppPath/HabboAirPlus_Linux.zip
					unzip -q -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip && mkdir $HabboLinuxAppPath/HabboClient && mv $HabboLinuxAppPath/HabboAirPlus_Linux_arm64/* $HabboLinuxAppPath/HabboClient/  &> /dev/null && rm -rf $HabboLinuxAppPath/HabboAirPlus_Linux_arm64  &> /dev/null
				fi

				chmod +x  $HabboLinuxAppPath/HabboClient/Habbo
				echo "$commit_version" > "$HabboLinuxAppPath/plus_installed"
			else
				echo "$actual_commit" > "$HabboLinuxAppPath/plus_installed"
			fi
		elif [ "$Downloader" = "curl" ]; then
			commit_version="$(curl -s "https://api.github.com/repos/LilithRainbows/HabboAirPlus/commits?per_page=1" | grep sha | head -n 1 | cut -d"\"" -f4 )"
			if  [[ "$actual_commit" != "$commit_version" ]]; then
				if [ "$Locale" != default ]; then
        	    			echo $(sed -n '30p' "$HabboLinuxAppPath/locale_launcher/$Locale")
    				else
					echo "Updating Habbo Air Plus"
				fi
				rm -rf $HabboLinuxAppPath/HabboClient/ $HabboLinuxAppPath/plus_installed  &> /dev/null $HabboLinuxAppPath/HabboAirPlus_Linux.zip
				if [ "$Architecture" = "x86_64" ]; then
					curl -sL https://github.com/LilithRainbows/HabboAirPlus/releases/download/latest/HabboAirPlus_Linux_x64.zip -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip
				unzip -q -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip && mkdir $HabboLinuxAppPath/HabboClient && mv $HabboLinuxAppPath/HabboAirPlus_Linux_x64/* $HabboLinuxAppPath/HabboClient/  &> /dev/null && rm -rf $HabboLinuxAppPath/HabboAirPlusLinux/HabboAirPlus_Linux_x64  &> /dev/null
				elif [ "$Architecture" = "arm64" ]; then
					curl -sL $PlusArm64Link -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip
					unzip -q -o $HabboLinuxAppPath/HabboAirPlus_Linux.zip && mkdir $HabboLinuxAppPath/HabboClient && mv $HabboLinuxAppPath/HabboAirPlus_Linux_arm64/* $HabboLinuxAppPath/HabboClient/  &> /dev/null && rm $HabboLinuxAppPath/HabboAirPlusLinux/HabboAirPlus_Linux_arm64/ &> /dev/null
				fi
				chmod +x  $HabboLinuxAppPath/HabboClient/Habbo
				echo "$commit_version" > "$HabboLinuxAppPath/plus_installed"
			else
				echo "$actual_commit" > "$HabboLinuxAppPath/plus_installed"
			fi
		fi
			date "+%Y-%m-%d" >> "$HabboLinuxAppPath/plus_installed"
 		
	
fi
			rm "$HabboLinuxAppPath/first_download"  &> /dev/null && rm "$HabboLinuxAppPath/classic_installed" &> /dev/null
fi
}


function CreatingPlusFlag () { #creates a helper file to define the version of Habbo that the launcher will download.
    if [ "$1" = "plus" ] || [ "$1" = "--plus" ]; then
    	if [ "$Locale" != default ]; then
            echo -e "\e[36m$(sed -n '12p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
    	else
    		echo -e "\e[36m[Preparing patch for Habbo Air Plus]\e[0m"
    	fi
        touch "$HabboLinuxAppPath/plus_flag"
	touch "$HabboLinuxAppPath/plus_installed" 
        rm "$HabboLinuxAppPath/first_download" &> /dev/null
        rm "$HabboLinuxAppPath/classic_installed" &> /dev/null
    elif [ "$1" = "classic" ] || [ "$1" = "--classic" ] ; then
        if [ -e "$HabboLinuxAppPath/plus_flag" ]; then
            rm "$HabboLinuxAppPath/plus_flag"  &> /dev/null
        fi
        rm -rf "$HabboLinuxAppPath/classic_installed" &> /dev/null
        touch "$HabboLinuxAppPath/first_download"
	rm -rf "$HabboLinuxAppPath/plus_installed" &> /dev/null
    fi
}

function CheckRemoveFlag () { #removes HabboLauncher using "remove" argument
    if [ "$1" = "remove" ] || [ "$1" = "--remove" ]; then
    	rm -rf "$HabboLinuxAppPath" &> /dev/null
    	rm -rf "$HOME/.local/bin/HabboLauncher" &> /dev/null
    	rm -rf "$LinuxDesktopPath/HabboAirForLinux.desktop" &> /dev/null
	rm -rf "$LinuxLinuxAppPath/../HabboAirForLinux.desktop" &> /dev/null
    	rm -rf "$LinuxIconPath/HabboAirForLinux.png" &> /dev/null
	rm -rf "$HabboLinuxAppPath/plus_installed" &> /dev/null
	if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
		echo $(sed -n '9p' "$HabboLinuxAppPath/locale_launcher/$Locale")
	else
		echo "Successfully removed HabboLauncher."
	fi            	
    	exit 0
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
    if [ -e "$HabboLinuxAppPath/locale_launcher/$Locale" ]; then
	echo -e "\e[36m$(sed -n '22p' "$HabboLinuxAppPath/locale_launcher/$Locale")\e[0m"
    else
   	 echo -e "\e[36m[Launching Habbo Client]\e[0m"
    fi
    nohup bash -c "$HabboLinuxAppPath/HabboClient/Habbo ${LauncherArguments} &" >/dev/null 2>&1;
    exit 0
}

#Main script
DownloadLocales
CheckLocales
CheckMultipleArguments "$#"
CheckHelp "$1"
CheckRemoveFlag "$1"
CheckArchitecture
CheckLibC
TestWGET
CreatingPlusFlag "$1"
if [ -e "$HabboLinuxAppPath/first_download" ]; then 
	rm -rf "$HabboLinuxAppPath/HabboClient" &> /dev/null
	rm -rf "$HabboLinuxAppPath/classic_installed" &> /dev/null
fi
DetectPatch
CheckSystemDependencies
TestUnzip
CheckClientUpdate
CheckPlusUpdate
LaunchClient

