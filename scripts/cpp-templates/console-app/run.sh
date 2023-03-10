#!/bin/bash

cd build
ninja
if [ -x "\$(command -v termux-elf-cleaner)" ]; then
    termux-elf-cleaner --quiet P_NAME
fi
./P_NAME
