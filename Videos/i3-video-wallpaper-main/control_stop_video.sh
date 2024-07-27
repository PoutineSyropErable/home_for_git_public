#!/bin/bash

# Send the stop command to mpv
echo '{ "command": ["stop"] }' | socat - /tmp/mpvsocket > /dev/null
