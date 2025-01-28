#!/usr/bin/env bash

set -eu

PWD=$(pwd)
( : $TIMESTAMP )
( : $COMMIT )

build_firmware() {
	side=$1
	west build -s zmk/app -d build/${side} -b adv360pro_${side} -S studio-rpc-usb-uart -- -DZMK_CONFIG="${PWD}/config"
	grep -vE '(^#|^$)' build/${side}/zephyr/.config
	cp build/${side}/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-${side}.uf2"
}

build_firmware left
build_firmware right
