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

## 🖼️ Preview

### Video Demo

<!-- Add a link to your video demo here if you have one -->
<!-- [Watch the Video Demo](link-to-your-video) -->

### Screenshots

|                                    |                                   |
| :--------------------------------- | :-------------------------------- |
| Device List                        | Device Settings                   |
| <img src="https://private-user-images.githubusercontent.com/180246423/427031560-dd71be6b-1bd3-4046-bb4b-8eb9771c4faa.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTYwLWRkNzFiZTZiLTFiZDMtNDA0Ni1iYjRiLThlYjk3NzFjNGZhYS5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hNjZlZTdhYTFlNDcwYjcxYTRiNWNiMGZlNjlmY2E2ZTA1MTRkYThhODYxZGEwM2I3MjBhYzEzMDk0ODYzOTE2JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.hdr-pFyfiH2PmoLjvLWr_jZxMmJjTO1ai1XwtEotSNU" alt="Device List" width="400"/> | <img src="https://private-user-images.githubusercontent.com/180246423/427031557-b5212343-625b-48ba-abbd-d071b9c03f44.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTU3LWI1MjEyMzQzLTYyNWItNDhiYS1hYmJkLWQwNzFiOWMwM2Y0NC5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0wZWZmOWQzYWY3OWM3OGZlNzJhYThiMjFiMTBlNWJkNzhlODVhNzc5M2ViYjE3N2FjYzA2MzE2MmVhNmM1Y2Y5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.hqJrKf1VCA4a0E8Zy5-zo9clETibOBFkElDJwQ9VSkc" alt="Device Settings" width="400"/> |
| Wifi ADB Connection                | Wifi QR Pairing                   |
| <img src="https://private-user-images.githubusercontent.com/180246423/427031556-95f29e1b-05b5-48d6-a578-fa0055d0e160.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTU2LTk1ZjI5ZTFiLTA1YjUtNDhkNi1hNTc4LWZhMDA1NWQwZTE2MC5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jZmFhMjZkNTM2YTBmYTRmNjVmMWFmOTkzYjUwNGE2NWEzYWJjMzFlYjYwYzFjOTFkNzFiODc4NDcyNmEzY2ZjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.7pmZVjYzPQ9rlIr-8NS4J3ynBQ7YzPEg4Q3ZMS7Z2sI" alt="Wifi ADB Connection" width="400"/> | <img src="https://private-user-images.githubusercontent.com/180246423/427031555-1eb59543-f6a2-48f3-8b74-a870d766e912.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTU1LTFlYjU5NTQzLWY2YTItNDhmMy04Yjc0LWE4NzBkNzY2ZTkxMi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT04ZjA0YjRiNzZhZDllZjA1ZDVmODkyNjg0ZWZlZDFmMWQ5NWJkNGUxNjQzNGRmMzJkNDYyYWIxOTg3OTFlYjQyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.Do3_qxUGGfWgHIext8EiFTi-5pJYo63hIruYpJNKfHw" alt="Wifi QR Pairing" width="400"/> |
| Scrcpy Version Manager             | Settings                          |
| <img src="https://private-user-images.githubusercontent.com/180246423/427031561-0f5d6b7e-5ec8-41ee-935d-cb859ec07033.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTYxLTBmNWQ2YjdlLTVlYzgtNDFlZS05MzVkLWNiODU5ZWMwNzAzMy5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yMGNhNTBkZDMyYjY5ZjRlNTAzZjAwY2Q5MTFmMTcyOTNmODQyMzNhMWVhODRkOWNlYWE3YmZlZjFiZWIyNDQxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.JtwkUOYK4SdSZA1Dn5nO6MYw48Tc_uuNGqcrm4P4hj4" alt="Scrcpy Version Manager" width="400"/> | <img src="https://private-user-images.githubusercontent.com/180246423/427031558-57b3131d-1a91-4737-9401-c8aeb40d27cb.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTU4LTU3YjMxMzFkLTFhOTEtNDczNy05NDAxLWM4YWViNDBkMjdjYi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0wMTYwMTZhMjA4ZGY1OGVlZDc0NjU0NDUzMjQxYjRiMTM4MzJiNzFkN2UyMTkyODkxN2Q3NTVmMjExNzg4ZDc1JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ZCZFILln5D0-ssjzvL05QGaac_F4u262ya3YMG7yKB8" alt="Settings" width="400"/> |
| Config Small                       | Config Big                        |
| <img src="https://private-user-images.githubusercontent.com/180246423/427031559-0c58f381-4a3b-4471-8c7e-c485e7b2e007.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTU5LTBjNThmMzgxLTRhM2ItNDQ3MS04YzdlLWM0ODVlN2IyZTAwNy5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1iN2NhMzM0MmZkZDRkYjZlNGY3YTI4MTA3NjRlMWYwZjgzYjUxMzE1MDEzZjhkYjQxYjRmMmRhZTI3YmViMzYzJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.K5SVY4EwWJdWOw0mZLidHr7DU5Vkq_gpsX6bZmFjozg" alt="Config Small" width="400"/> | <img src="https://private-user-images.githubusercontent.com/180246423/427031562-9f7fb704-ae95-4f5f-85a4-e62e6ae6cb18.jpg?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDI5OTg1ODYsIm5iZiI6MTc0Mjk5ODI4NiwicGF0aCI6Ii8xODAyNDY0MjMvNDI3MDMxNTYyLTlmN2ZiNzA0LWFlOTUtNGY1Zi04NWE0LWU2MmU2YWU2Y2IxOC5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzI2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMyNlQxNDExMjZaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0yZWFmMWUzYTNmZDEzZTUzZGI2YjhjODU2NTRlNzM0NGQwMDMwN2FkMjc1OGVjOWFmMzBiZWRkMTk2ZGY2MDFiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.ZIrHIbV55VOY4EKdvJtiQ4bmUhU6LVFegzp8ah8ve-o" alt="Config Big" width="400"/> |

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
