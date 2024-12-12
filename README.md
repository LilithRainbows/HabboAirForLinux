# Instructions
### Automatic installation

-Open a Terminal window and paste this command:
```sh
bash -c "$(wget -q -O- https://github.com/LilithRainbows/HabboAirForLinux/raw/gabo/Install.sh)"
```
If for some reason the Habbo Launcher shortcut doesn't work on your system you can manually run it with this command:
```sh
bash $HOME/.local/share/applications/HabboAirForLinux/HabboLauncher.sh
```

or if you generate a symlink:

```
HabboLauncher
```

Also you can install Habbo Air Plus only by running this command:

```sh
bash -c "$(wget -q -O- https://github.com/LilithRainbows/HabboAirForLinux/raw/gabo/Install.sh)" - plus
```

or if you have instaled the launcher

```
HabboLauncher --plus
```

Also you can revert to Habbo Air Classic:

```
HabboLauncher --classic
```

### Uninstalling

You can remove Habbo with this command:

```
HabboLauncher --remove
```

<br>

### Manual installation

-Download repository as zip clicking [here](https://github.com/LilithRainbows/HabboAirForLinux/archive/refs/heads/main.zip)<br>
-Extract whole zip folder<br>
-Open a Terminal window and type ```bash ``` (without pressing enter and leaving the space character at the end)<br>
-Drag&Drop the desired script (located on extracted folder) to Terminal window and press enter<br>

<br>

### Script list
```Install.sh``` (To install Habbo Launcher)<br>
```HabboLauncher.sh``` (To run Habbo Launcher without installing it)

### Docker files

x64 and arm64 architectures with glib-c are primarily supported, but we have dockers files for x64 and arm64 systems based on musl lib-c.

For classic Habbo, run:

```
bash -c "$(wget -q -O- https://github.com/LilithRainbows/HabboAirForLinux/raw/gabo/DockerHabboAirForLinux.sh)"
```

For Plus, run:

```
bash -c "$(wget -q -O- https://github.com/LilithRainbows/HabboAirForLinux/raw/gabo/DockerHabboAirPlus.sh)"
```
