# HabboAirForLinux

HabboAIR native client implementation for Linux with auto-updater.

# Instructions

Some distributions have their own default packages. Choose the package according which is installed in your system.

### Automatic install

- wget:
```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/LilithRainbows/HabboAirForLinux/master/install.sh)"
```
- curl:
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/LilithRainbows/HabboAirForLinux/master/install.sh)"
```
- fetch:
```sh
sh -c "$(fetch -o - https://raw.githubusercontent.com/LilithRainbows/HabboAirForLinux/master/install.sh)"
```

Force Launch:
```sh
cd ~/.local/share/applications/HabboAirForLinux && sh HabboLauncher.sh
```

# Warning

The HabboAirForLinux supports 64-bits processors at the moment.
