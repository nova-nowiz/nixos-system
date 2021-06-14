#!/usr/bin/env bash

## Auto-Nitro is a script to automatically change the wallpaper with Nitrogenium

# Config
DELAY=600

while true; do
    # run nitrogen and sleep
    nitrogen --set-zoom-fill --random $HOME/.config/background/3440x1440
    sleep $DELAY
done
