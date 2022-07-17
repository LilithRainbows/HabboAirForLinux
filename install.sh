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

printf "$BLUE""[Checking architecture]""$RESET_COLOUR""\n"
printf "\n"
ARCH="$(uname -m)"
if [ $ARCH != 'x86_64' ]; then
	printf "$RED""ERROR: Wrong architecture, only 64-Bit architectures are supported!""$RESET_COLOUR""\n"
    exit 1
else
    printf "$YELLOW""64-Bit architecture detected!""$RESET_COLOUR""\n"
fi
printf "\n"

printf "$BLUE""[Checking dependencies]""$RESET_COLOUR""\n"
read -p "Install XTerm? [Y/n]" install_xterm
if [ "$install_xterm" == "" ]; then
    install_xterm="Yes"
fi
case $install_xterm in
    "Y"|"y"|"Yes"|"yes")
        packages="xterm"
        ;;
    "N"|"n"|"No"|"no")
        packages=""
        ;;
    *)
        printf "$RED""ERROR: This is not an option! Considering as yes...""$RESET_COLOUR""\n"
        packages="xterm"
esac
if type dpkg &>/dev/null; then
    packages="tar unzip wget libnss3 $packages"
else
    packages="tar unzip wget nss $packages"
fi
printf "\n"

for package in $packages; do
    if type dpkg &>/dev/null; then
        if [ -z "$(dpkg --list | grep "$package")" ]; then
            if ! sudo apt install $package -y 2&>/dev/null; then
                printf "$RED""ERROR: ""$PURPLE""$package""$RED"" failed to install! Closing...""$RESET_COLOUR""\n"
                exit 1
            else
                printf "$GREEN""$PURPLE""$package""$GREEN"" has been installed!""$RESET_COLOUR""\n"
            fi
        else
            printf "$PURPLE""$package""$RESET_COLOUR"" has already been satisfied!\n"
        fi
    else
        if [ -z "$(pacman -Q | grep "$package")" ]; then
            if ! sudo pacman -S --needed --noconfirm $package 2&>/dev/null; then
                printf "$RED""ERROR: ""$PURPLE""$package""$RED"" failed to install! Closing...""$RESET_COLOUR""\n"
                exit 1
            else
                printf "$GREEN""$PURPLE""$package""$GREEN"" has been installed!""$RESET_COLOUR""\n"
            fi
        else
            printf "$PURPLE""$package""$RESET_COLOUR"" has already been satisfied!\n"
        fi
    fi
done
printf "\n"

HabboAirForLinuxAppPath=$HOME/.local/share/applications/HabboAirForLinux
#rm -r $HabboAirForLinuxAppPath
mkdir -vp $HabboAirForLinuxAppPath
mkdir -vp $HOME/.icons
wget -O HabboAirForLinux.tar.gz https://github.com/LilithRainbows/HabboAirForLinux/tarball/master
tar -xvf HabboAirForLinux.tar.gz
mv -v *-HabboAirForLinux-* HabboAirForLinux
chown -vR $USER:$USER HabboAirForLinux # Use sudo if this don't work?
mv -v HabboAirForLinux/HabboAirLinuxPatch.zip $HabboAirForLinuxAppPath
mv -v HabboAirForLinux/HabboLauncher.sh $HabboAirForLinuxAppPath
mv -v HabboAirForLinux/HabboAirForLinux.png $HOME/.icons
mv -v HabboAirForLinux/HabboAirForLinux.desktop $HabboAirForLinuxAppPath/..
chmod -v +x $HabboAirForLinuxAppPath/HabboLauncher.sh
rm -vr HabboAirForLinux
rm -vr HabboAirForLinux.tar.gz
xdg-settings set default-url-scheme-handler habbo HabboAirForLinux.desktop

printf "$GREEN""[Installation finished]""$RESET_COLOUR""\n"
printf "\n"
printf "$GREEN""\tNow you can use the "$PURPLE"HabboAirForLinux"$GREEN" system shortcut\n\t\tor the "$PURPLE"Habbo Launch"$GREEN" button from the web\n\t     if your browser and system are compatible.""$RESET_COLOUR""\n"
