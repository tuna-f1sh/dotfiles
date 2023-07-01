#!/bin/sh

script_path=$(dirname `which $0`)

py3=`which python3`
if [ $? -ne 0 ]; then
    # If it's not in the PATH, assume it's in /usr/local/bin
    py3="/usr/local/bin/python3"
fi

$py3 $script_path/nrf_sniffer_ble.py "$@"

