# Build scrcpygui

## Requirements
- flutter 3.32.4, use [fvm](https://fvm.app/documentation/getting-started/installation) to install specific version, and the associated flutter requirements for desktop development
- requirements for [tray_manager](https://pub.dev/packages/tray_manager#quick-start) plugin (linux)
    - linux: 
    ayatana-appindicator3-0.1 or appindicator3-0.1

- requirements for [bonsoir](https://bonsoir.skyost.eu/docs#installation) plugin
    - windows: Win 10 (19H1/1903) (Mai 2019 Update) minimum
    - linux: avahi-daemon

## Steps

```bash
git clone https://github.com/pizi-0/flutter-scrcpygui.git
cd flutter-scrcpygui
fvm install 3.32.4
fvm use 3.32.4
fvm flutter pub get
fvm flutter build linux/windows/mac --release
```

## Built exec location
- linux
```
build/linux/x64/release/bundle
```
- windows
```
build\windows\x64\runner\release
```
- mac
```
build/macos/Build/Products/Release/Scrcpy GUI.app
```