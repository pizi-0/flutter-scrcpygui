# Flutter Scrcpy-GUI

A gui for [Scrcpy](https://github.com/Genymobile/scrcpy), made with Flutter.

## Note

- Beginner dev / messy code - this project was made as an effort for me to learn flutter.

- Some features may or may not work as intended on Mac/Windows as this project is developed and tested on Linux with my personal use in mind.

## Requirements

### Linux & MacOS

To be installed and be available in PATH.\
Refer [scrcpy](https://github.com/Genymobile/scrcpy?tab=readme-ov-file#get-the-app) for installation.

- scrcpy
- adb

### Windows

- Nothing

## Features

- Wireless ADB connect with history.
- Automatically set wireless device to listen to port 5555 on first connection.
- Ease of use for setting up and running scrcpy command.
- Save scrcpy config.
- List of running scrcpy instances. (only on Linux)
- Theming - dark/light + accent color.
- Tray support (start/stop servers)

## Preview

### Dark
| Device list  | Wifi ADB discovery | Wifi QR pairing | Scrcpy manager | Config (small) | Config (big) | Config (big, w info)
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
| ![alt text](screenshot/dark/1.dev-list.png)  | ![alt text](screenshot/dark/2.scan.png)  | ![alt text](screenshot/dark/3.pair.png) | ![alt text](screenshot/dark/4.manager.png) | ![alt text](screenshot/dark/5.config-small.png) | ![alt text](screenshot/dark/6.config-big.png) | ![alt text](screenshot/dark/7.config-big-info.png)

### Light

| Device list  | Wifi ADB discovery | Wifi QR pairing | Scrcpy manager | Config (small) | Config (big) | Config (big, w info)
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | -------------
| ![alt text](screenshot/light/1.dev-list.png)  | ![alt text](screenshot/light/2.scan.png)  | ![alt text](screenshot/light/3.pair.png) | ![alt text](screenshot/light/4.manager.png) | ![alt text](screenshot/light/5.config-small.png) | ![alt text](screenshot/light/6.config-big.png) | ![alt text](screenshot/light/7.config-big-info.png)

## License

GNU GPLv3

## Credits

- [scrcpy](https://github.com/Genymobile/scrcpy)
