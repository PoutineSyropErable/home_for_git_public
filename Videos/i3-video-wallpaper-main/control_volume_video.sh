#!/bin/bash

if [ -z "$1" ]; then
  echo "ERROR: Requires volume adjustment"
  exit 1
fi

adjustment=$1

# Check if the adjustment is relative (+ or -) or absolute
if [[ $adjustment == +* || $adjustment == -* ]]; then
  # Relative adjustment
  echo "{ \"command\": [\"add\", \"volume\", ${adjustment#+}] }" | socat - /tmp/mpvsocket > /dev/null
else
  # Absolute adjustment
  echo "{ \"command\": [\"set_property\", \"volume\", $adjustment] }" | socat - /tmp/mpvsocket > /dev/null
fi
