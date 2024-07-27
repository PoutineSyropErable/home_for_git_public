#!/bin/bash

# Function to output menu items
output_menu_item() {
    local action=$1
    local icon=$2
    local command=$3
    
    echo "$action"
    echo "$icon"
    echo "$command"
    echo "---"  # Optional separator between items
}

# Define the menu items with their icons and corresponding scripts
declare -a menu_items=(
    "toggle;󰐎;/home/francois/Videos/i3-video-wallpaper-main/mpv-control.sh toggle"
    "seek -10;;/home/francois/Videos/i3-video-wallpaper-main/mpv-control.sh seek -10"
    "stop;󰓛;/home/francois/Videos/i3-video-wallpaper-main/control_stop_video.sh"
    "seek +10;;/home/francois/Videos/i3-video-wallpaper-main/mpv-control.sh seek +10"
    "volume -5;;/home/francois/Videos/i3-video-wallpaper-main/mpv-control.sh volume -5"
    "volume +5;;/home/francois/Videos/i3-video-wallpaper-main/mpv-control.sh volume +5"
)

# Output each menu item
for item in "${menu_items[@]}"; do
    IFS=';' read -r action icon command <<< "$item"
    output_menu_item "$action" "$icon" "$command"
done
