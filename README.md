# Scrcpy GUI

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub Releases](https://img.shields.io/github/v/release/pizi-0/flutter-scrcpygui?include_prereleases&style=flat-square)](https://github.com/pizi-0/flutter-scrcpygui/releases)

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

## 🖼️ Preview

### Video Demo

<!-- Add a link to your video demo here if you have one -->
<!-- [Watch the Video Demo](link-to-your-video) -->

### Screenshots

|                                    |                                   |
| :--------------------------------- | :-------------------------------- |
| Device List                        | Device Settings                   |
| <img src="screenshot/dark/1.dev-list.jpg" alt="Device List" width="400"/> | <img src="screenshot/dark/2.dev-settings.jpg" alt="Device Settings" width="400"/> |
| Wifi ADB Connection                | Wifi QR Pairing                   |
| <img src="screenshot/dark/3.connect.jpg" alt="Wifi ADB Connection" width="400"/> | <img src="screenshot/dark/4.pair.jpg" alt="Wifi QR Pairing" width="400"/> |
| Scrcpy Version Manager             | Settings                          |
| <img src="screenshot/dark/5.manager.jpg" alt="Scrcpy Version Manager" width="400"/> | <img src="screenshot/dark/6.settings.jpg" alt="Settings" width="400"/> |
| Config Small                       | Config Big                        |
| <img src="screenshot/dark/7.config-small.jpg" alt="Config Small" width="400"/> | <img src="screenshot/dark/8.config-big.jpg" alt="Config Big" width="400"/> |

## ⬇️ Get the App

### [Latest Releases](https://github.com/pizi-0/flutter-scrcpygui/releases)

Download the latest pre-built binaries from the releases page.

### Build from Source

For those who prefer to build from source, follow the instructions in the [Build Guide](doc/build.md).

## 🛠️ Building from Source

Here's a summary of the build process (see [doc/build.md](doc/build.md) for full details):

### Prerequisites

*   **Flutter:** Version 3.29.0 (recommended to use [fvm](https://fvm.app/documentation/getting-started/installation) for version management).
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
fvm install 3.29.0
fvm use 3.29.0
fvm flutter pub get
fvm flutter build linux/windows --release
