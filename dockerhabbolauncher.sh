#!/bin/sh
Container='HabboLauncher/1'

createshortcutsandfiles() {
		if ! [ -d $HOME/.local/share/applications ]; then
			mkdir $HOME/.local/share/applications
		fi
		if ! [ -d $HOME/.local/share/applications/HabboLauncher ]; then
			mkdir $HOME/.local/share/applications/HabboLauncher
		fi
		cp $0 $HOME/.local/share/applications/HabboLauncher >/dev/null 2>&1
		if  ! [ -e $HOME/.local/share/applications/HabboLauncher.desktop ]; then
			touch $HOME/.local/share/applications/HabboLauncher.desktop #create desktop entry
			echo "[Desktop Entry]" > $HOME/.local/share/applications/HabboLauncher.desktop
			echo "Name=Habbo Client" >>  $HOME/.local/share/applications/HabboLauncher.desktop
			echo "Exec=$HOME/.local/share/applications/HabboLauncher/$(basename "$0")" >> $HOME/.local/share/applications/HabboLauncher.desktop
			echo "Type=Application" >>  $HOME/.local/share/applications/HabboLauncher.desktop
			echo "Terminal=true" >>  $HOME/.local/share/applications/HabboLauncher.desktop
		fi
		if  ! [ -e $HOME./local/share/applications/UpdateHabboLauncher.desktop ]; then
			touch $HOME/.local/share/applications/UpdateHabboLauncher.desktop #create desktop entry
			echo "[Desktop Entry]" > $HOME/.local/share/applications/UpdateHabboLauncher.desktop
			echo "Name=Update Habbo Launcher" >>  $HOME/.local/share/applications/UpdateHabboLauncher.desktop
			echo "Exec=sudo docker run $Container /app/home/update.sh" >> $HOME/.local/share/applications/UpdateHabboLauncher.desktop
			echo "Type=Application" >>  $HOME/.local/share/applications/UpdateHabboLauncher.desktop
			echo "Terminal=true" >>  $HOME/.local/share/applications/UpdateHabboLauncher.desktop
		fi
		if  ! [ -e $HOME./local/share/applications/RemoveHabboLauncher.desktop ]; then
			touch $HOME/.local/share/applications/RemoveHabboLauncher.desktop #create desktop entry
			echo "[Desktop Entry]" > $HOME/.local/share/applications/RemoveHabboLauncher.desktop
			echo "Name=Remove Habbo Launcher" >>  $HOME/.local/share/applications/RemoveHabboLauncher.desktop
			echo "Exec=sh -c \"sudo docker ps -a | grep $Container | awk '{print \$1}\' | xargs -I {} sudo docker rm -f {} ; sudo docker image remove $Container --force ; rm -rf $HOME/.local/share/applications/HabboLauncher; rm -rf  $HOME/.local/share/applications/HabboLauncher.desktop $HOME/.local/share/applications/UpdateHabboLauncher.desktop $HOME/.local/share/applications/RemoveHabboLauncher.desktop\"" >> $HOME/.local/share/applications/RemoveHabboLauncher.desktop
			echo "Type=Application" >>  $HOME/.local/share/applications/RemoveHabboLauncher.desktop
			echo "Terminal=true" >>  $HOME/.local/share/applications/RemoveHabboLauncher.desktop
		fi
}

generatedockerfile() {
	echo 'FROM debian' > dockerfile
	echo 'WORKDIR /app' >> dockerfile
	echo 'RUN apt-get -qq update' >> dockerfile
	echo 'RUN apt-get -qqqq install -y unzip libnss3 gtk+2.0 xorg xterm wget' >> dockerfile
	echo 'ENV HOME=/app/home' >> dockerfile
	echo 'RUN echo [Installing Habbo Launcher]' >> dockerfile
	echo 'RUN bash -c "$(wget -q -O- https://github.com/LilithRainbows/HabboAirForLinux/raw/main/Install.sh)"'  >> dockerfile
	echo 'RUN ["/app/home/.local/share/applications/HabboAirForLinux/HabboLauncher.sh"]'  >> dockerfile
	echo 'RUN echo "#!/bin/sh" > /app/home/update.sh && echo "/app/home/.local/share/applications/HabboAirForLinux/HabboLauncher.sh" >> /app/home/update.sh'  >> dockerfile
	echo 'RUN chmod +x /app/home/update.sh'  >> dockerfile
	echo 'CMD ["/app/home/.local/share/applications/HabboAirForLinux/HabboClient/Habbo"]'  >> dockerfile
}


cd $(cd "$(dirname "$0")" && pwd) #Change to script directory
if ! [ -z "$(command -v docker)" ] && ! [ -z "$(command -v xhost)" ]; then #Detect if dockerfile and docker container is on the machine. If can't find files, dowload the dockerfile or create the docker container.
	if sudo docker images | grep -q ^$Container; then
	        sudo xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $(docker run -d HabboLauncher/1)`
		createshortcutsandfiles
		sudo docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY HabboLauncher/1 
	else
		generatedockerfile 
		sudo docker build -t HabboLauncher/1  .	
		sudo xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $(docker run -d HabboLauncher/1)`
		rm dockerfile
		createshortcutsandfiles
		sudo docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY HabboLauncher/1 
	fi
else
 	echo "Please install docker and xhost for install Habbo Launcher on a docker container"
	exit 1
fi