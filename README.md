# Scrcpy GUI

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub Releases](https://img.shields.io/github/v/release/pizi-0/flutter-scrcpygui?include_prereleases&style=flat)](https://github.com/pizi-0/flutter-scrcpygui/releases)
[![Discord](https://img.shields.io/badge/scrcpygui-white?logo=discord&style=flat)](https://discord.gg/ZdV5DAxd8Y)


> A user-friendly graphical interface for [Scrcpy](https://github.com/Genymobile/scrcpy), built with Flutter.

**Scrcpy GUI** simplifies the process of using Scrcpy, allowing you to control your Android device from your computer with ease. It provides a clean and intuitive interface, eliminating the need to memorize complex command-line arguments.

## ✨ Key Features

*   **Effortless Scrcpy Setup:** Easily configure and launch Scrcpy with a few clicks.
*   **Config Management:** Save and manage multiple Scrcpy configurations for different devices or use cases.
*   **Comprehensive Flag Support:** Access most Scrcpy flags, including custom user-defined options.
*   **Wireless ADB Connection:** Connect to your device wirelessly via ADB, including QR code pairing for quick setup.
*   **Scrcpy Version Management:** Stay up-to-date with the latest Scrcpy releases.
*   **Instance Monitoring:** View a list of currently running Scrcpy instances.
*   **Customizable Themes:** Choose between dark and light themes, along with customizable accent colors.
*   **Tray Integration:** Start and stop Scrcpy directly from the system tray.

## 🖥️ Supported Platforms

*   Windows (64-bit)
*   Linux (64-bit)
*   MacOS (64-bit) - Intel / Apple Silicon



## 🖼️ Preview

### Video Demo

<!-- Add a link to your video demo here if you have one -->
* [v0.9.40 - Video demo](https://youtu.be/y-2TdCh-nfg)
* [v1.2.0 - New app launcher demo](https://youtu.be/_7CimVn0VoA)

### Screenshots

|                                    |                                   |
| :--------------------------------- | :-------------------------------- |
| Device List                        | Device Settings                   |
| <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/1.dev-list.jpg?raw=true" alt="Device List" width="400"/> | <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/2.dev-settings.jpg?raw=true" alt="Device Settings" width="400"/> |
| Wifi ADB Connection                | Wifi QR Pairing                   |
| <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/3.connect.jpg?raw=true" alt="Wifi ADB Connection" width="400"/> | <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/5.pair.jpg?raw=true" alt="Wifi QR Pairing" width="400"/> |
| Scrcpy Version Manager             | Settings                          |
| <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/4.manager.jpg?raw=true" alt="Scrcpy Version Manager" width="400"/> | <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/6.settings.jpg?raw=true" alt="Settings" width="400"/> |
| Config Small                       | Config Big                        |
| <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/7.config-small.jpg?raw=true" alt="Config Small" width="400"/> | <img src="https://github.com/pizi-0/img-collection/blob/main/flutter-scrcpygui/8.config-big.jpg?raw=true" alt="Config Big" width="400"/> |

## ⬇️ Get the App

### [Latest Releases](https://github.com/pizi-0/flutter-scrcpygui/releases)

Download the latest pre-built binaries from the releases page.

### Build from Source

For those who prefer to build from source, follow the instructions in the [Build Guide](doc/build.md).

## 🛠️ Building from Source

Here's a summary of the build process (see [doc/build.md](doc/build.md) for full details):

### Prerequisites

*   **Flutter:** Version 3.32.4 (recommended to use [fvm](https://fvm.app/documentation/getting-started/installation) for version management).
*   **Desktop Development Requirements:** Ensure you have the necessary Flutter dependencies for desktop development.
*   **Tray Manager (Linux):**
    *   `ayatana-appindicator3-0.1` or `appindicator3-0.1`
*   **Bonsoir:**
    *   **Windows:** Windows 10 (19H1/1903) (May 2019 Update) or later.
    *   **Linux:** `avahi-daemon`

### Build Steps

```bash
git clone https://github.com/pizi-0/flutter-scrcpygui.git
cd flutter-scrcpygui
fvm install 3.32.4
fvm use 3.32.4
fvm flutter pub get
fvm flutter build linux/windows/mac --release
