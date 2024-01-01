#!/usr/bin/env bash

set -eu

PWD=$(pwd)
( : $TIMESTAMP )
( : $COMMIT )

west build -s zmk/app -d build/left -b adv360_left -- -DZMK_CONFIG="${PWD}/config"
grep -vE '(^#|^$)' build/left/zephyr/.config
cp build/left/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-left.uf2"

west build -s zmk/app -d build/right -b adv360_right -- -DZMK_CONFIG="${PWD}/config"
grep -vE '(^#|^$)' build/right/zephyr/.config
cp build/right/zephyr/zmk.uf2 "./firmware/${TIMESTAMP}-${COMMIT}-right.uf2"
