# Custom configuration for [Kinesis](https://kinesis-ergo.com) [Advantage 360 Pro](https://kinesis-ergo.com/keyboards/advantage360/) keyboard

This repository enables you to customize the behavior of the keyboard.
You can make simple changes to the keymaps of each layer, add layers, create macros, and even change the LED colors.
For advanced users, there are even more possibilities to explore.

Once you have finished customizing, you can build your own firmware and flash it to your keyboard.
The firmware is built using [ZMK](https://zmk.dev/), which is a keyboard firmware based on [Zephyr](https://www.zephyrproject.org/).

## Modifying the keymap

Two methods are available for modifying the keymap: using the Kinesis GUI or directly editing the relevant files.

### Using the Kinesis GUI

There is a [web based GUI](https://kinesiscorporation.github.io/Adv360-Pro-GUI) available for editing the keymap.

### Editing the files

[The ZMK documentation](https://zmk.dev/docs) covers both basic and advanced functionality.
The keymap is defined in [adv360.keymap](config/adv360.keymap).

![The key positions on the Advantage 360](assets/key-positions.png)

## Building the firmware

Two methods are available for building the firmware: using GitHub Actions or building locally.

### Github Actions

TODO

### Building locally

- Requires Podman or Docker to be installed, with a preference for Podman.
- Requires WSL2 on Windows.
- Requires PowerShell

Run `Build-Firmware.ps1` to build the firmware.
The first run will take a long time as it will download the ZMK Docker image and other dependencies.
Subsequent runs will be much faster.

The finished firmware can be found in the `firmware` directory, named `left.uf2` and `right.uf2` respectively.

## Flashing firmware

Run `Update-Firmware.ps1` to flash the firmware.
