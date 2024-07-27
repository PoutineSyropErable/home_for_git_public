#!/bin/bash

# Check if an argument (seek time) is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <seek_time>"
    exit 1
fi

seek_time="$1"

# Determine if seek time is relative or absolute
if [[ "$seek_time" =~ ^[+-]?[0-9]+(\.[0-9]+)?$ ]]; then
    # If the seek time starts with + or -, treat it as relative seeking
    if [[ "$seek_time" =~ ^[+-] ]]; then
        command="{ \"command\": [\"seek\", \"$seek_time\", \"relative\"] }"
    else
        command="{ \"command\": [\"seek\", \"$seek_time\", \"absolute\"] }"
    fi
else
    echo "Invalid seek time: $seek_time"
    exit 1
fi

# Send the seek command to mpv using socat
echo "$command" | socat - /tmp/mpvsocket > /dev/null
