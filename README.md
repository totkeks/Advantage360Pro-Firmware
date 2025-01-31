# Custom firmware for [Kinesis Advantage 360 Pro](https://kinesis-ergo.com/keyboards/advantage360/) keyboard

This repository provides tools for customizing your keyboard through:

- Keymap modifications (layers, macros, combos)
- LED behavior configuration
- Bluetooth settings
- Firmware version tracking

The firmware uses [ZMK](https://zmk.dev/), based on [Zephyr](https://www.zephyrproject.org/).
It now also supports using [ZMK Studio](https://zmk.studio) to configure your keymaps.

## Quick Start & Build

1. Install requirements

   ```powershell
   winget install -e Microsoft.PowerShell
   winget install -e Git.Git
   winget install -e Redhat.Podman-Desktop (or Docker.DockerDesktop)
   ```

2. Setup and start container service ([Podman](https://podman.io/docs/installation) or [Docker](https://docs.docker.com/get-started/introduction/get-docker-desktop/))

3. Clone this repository

   ```powershell
   git clone https://github.com/totkeks/Advantage360Pro-Firmware.git
   cd Advantage360Pro-Firmware
   ```

4. Build and flash firmware

   ```powershell
   ./Build-Firmware.ps1
   ./Update-Firmware.ps1
   ```

During flashing, follow on-screen prompts to enter bootloader mode:

- Right half: `Mod + Macro3`
- Left half: `Mod + Macro1`

The build script creates a container with the ZMK build environment, generates a version identifier (based on timestamp, branch, and commit), builds firmware for both halves, and creates links to [left.uf2](firmware/left.uf2) and [right.uf2](firmware/right.uf2) files.

## Changing the Keyboard Layout

There are two ways to update your keyboard's keymap:

### 1. Using ZMK Studio

ZMK Studio is a web-based editor that provides a visual interface for designing and modifying your keymaps. To use it:

- Visit [ZMK Studio](https://zmk.studio)
- Press `Mod + S` to unlock for changes via Studio
- Follow the on-screen instructions to pair the keyboard with ZMK Studio
- Modify your keymap as needed

### 2. Editing the Local File

Alternatively, you can modify your keymap directly by editing the local configuration file:

- Open the file at [`config/adv360pro.keymap`](config/adv360pro.keymap) in your preferred editor
- Follow the [ZMK documentation](https://zmk.dev/docs/keymaps) for guidance on the keymap structure and available options
- Save your changes, build the firmware, and flash it to your keyboard
