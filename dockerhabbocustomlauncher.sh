#!/bin/sh
Container='HabboCustomLauncher/1'

createshortcutsandfiles() {
		if ! [ -d $HOME/.local/share/applications ]; then
			mkdir $HOME/.local/share/applications
		fi
		if ! [ -d $HOME/.local/share/applications/HabboCustomLauncher ]; then
			mkdir $HOME/.local/share/applications/HabboCustomLauncher
		fi
		cp $0 $HOME/.local/share/applications/HabboCustomLauncher >/dev/null 2>&1
		if  ! [ -e $HOME/.local/share/applications/HabboCustomLauncher.desktop ]; then
			touch $HOME/.local/share/applications/HabboCustomLauncher.desktop #create desktop entry
			echo "[Desktop Entry]" > $HOME/.local/share/applications/HabboCustomLauncher.desktop
			echo "Name=Habbo Custom Launcher" >>  $HOME/.local/share/applications/HabboCustomLauncher.desktop
			echo "Exec=$HOME/.local/share/applications/HabboCustomLauncher/$(basename "$0")" >> $HOME/.local/share/applications/HabboCustomLauncher.desktop
			echo "Type=Application" >>  $HOME/.local/share/applications/HabboCustomLauncher.desktop
			echo "Terminal=false" >>  $HOME/.local/share/applications/HabboCustomLauncher.desktop
		fi
		if  ! [ -e $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop ]; then
			touch $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop #create desktop entry
			echo "[Desktop Entry]" > $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop
			echo "Name=Remove Habbo Custom Launcher" >>  $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop
			echo "Exec=sh -c \"sudo docker ps -a | grep $Container | awk '{print \$1}\' | xargs -I {} sudo docker rm -f {} ; sudo docker image remove $Container --force ; rm -rf $HOME/.local/share/applications/HabboCustomLauncher; rm -rf  $HOME/.local/share/applications/HabboCustomLauncher.desktop $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop\"" >> $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop
			echo "Type=Application" >>  $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop
			echo "Terminal=true" >>  $HOME/.local/share/applications/RemoveHabboCustomLauncher.desktop
		fi
}

generatedockerfile() {
	echo 'FROM debian' > dockerfile
	echo 'WORKDIR /app' >> dockerfile
	echo 'RUN apt-get -qq update' >> dockerfile
	echo 'RUN apt-get -qqqq install -y apt-utils unzip libnss3 xorg xterm wget gtk+2.0  ' >> dockerfile
	echo 'ENV HOME=/app/home' >> dockerfile
	echo 'RUN echo [Installing Habbo Launcher]' >> dockerfile
	echo 'RUN wget -q https://github.com/LilithRainbows/HabboCustomLauncherBeta/releases/download/beta_latest/HabboCustomLauncher_Linux_x64'  >> dockerfile
	echo 'RUN ls -lh'  >> dockerfile
	echo 'RUN chmod +rwx $(pwd)'  >> dockerfile
	echo 'RUN chmod +rwx $(pwd)/*'  >> dockerfile
	echo 'RUN chmod +rwx ./HabboCustomLauncher_Linux_x64'  >> dockerfile
	echo 'ENV DOTNET_BUNDLE_EXTRACT_BASE_DIR=$(pwd)' >> dockerfile
	echo 'CMD ["./HabboCustomLauncher_Linux_x64"]'  >> dockerfile
}


cd $(cd "$(dirname "$0")" && pwd) #Change to script directory
if ! [ -z "$(command -v docker)" ] && ! [ -z "$(command -v xhost)" ]; then #Detect if dockerfile and docker container is on the machine. If can't find files, dowload the dockerfile or create the docker container.
	if docker images | grep -q ^$Container ; then
	     xhost +local:$(docker inspect --format='{{ .Config.Hostname }}' $(docker run -d $Container))
		createshortcutsandfiles
		docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY $Container
		exit 0
	else
		generatedockerfile 
	        sudo docker build -t $Container  .	
		sudo xhost +local:$(sudo docker inspect --format='{{ .Config.Hostname }}' $(sudo docker run -d $Container))
		rm dockerfile
		createshortcutsandfiles
		sudo docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY $Container
		exit 0
	fi
else
 	echo "Please install docker and xhost for install Habbo Custom Launcher on a docker container"
	exit 1
fi