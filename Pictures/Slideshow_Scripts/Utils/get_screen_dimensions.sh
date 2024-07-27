#!/bin/bash

# Initialize variables
screen_width=""
screen_height=""

# Manually defined default screen dimensions
default_screen_width=1920
default_screen_height=1200

# Function to get screen dimensions using xdpyinfo
get_screen_dimensions_xdpyinfo() {
    dimensions=$(xdpyinfo | grep dimensions) || return 1
    screen_width=$(echo "$dimensions" | awk '{print $2}' | cut -d 'x' -f 1)
    screen_height=$(echo "$dimensions" | awk '{print $2}' | cut -d 'x' -f 2)
    echo "xdpyinfo() worked 0" >&2
    return 0
}

# Function to get screen dimensions using xrandr
get_screen_dimensions_xrandr() {
    resolution=$(xrandr | grep '*' | awk '{print $1}') || return 1
    screen_width=$(echo "$resolution" | cut -d 'x' -f 1)
    screen_height=$(echo "$resolution" | cut -d 'x' -f 2)
    echo "xrandr() worked 1" >&2
    return 1
}

# Attempt to get screen dimensions using xdpyinfo
get_screen_dimensions_xdpyinfo || {
    # Fallback to default dimensions if xdpyinfo fails
    screen_width=$default_screen_width
    screen_height=$default_screen_height
}

# If screen dimensions were not retrieved successfully using xdpyinfo, try xrandr
if [ -z "$screen_width" ] || [ -z "$screen_height" ]; then
    get_screen_dimensions_xrandr || {
        # Fallback to default dimensions if xrandr also fails
        screen_width=$default_screen_width
        screen_height=$default_screen_height
        echo "default value used 2" >&2
        return 2
    }
fi

# Output screen dimensions
echo "$screen_width $screen_height"

