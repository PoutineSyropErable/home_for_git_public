#!/bin/bash

# Function to change background using feh
change_background() {
    feh --bg-center --bg-fill --no-fehbg "$1"
}

# Default directory containing original images (if no path provided)
default_image_dir="Cool Pictures"

# Function to handle signals and manage natural cycling
signal_handler() {
    case $1 in
        "next")
            echo "Received next signal"
            next_image=true
            ;;
        "previous")
            echo "Received previous signal"
            prev_image=true
            ;;
        *)
            echo "Unknown signal: $1"
            ;;
    esac
}

# Set up signal handlers
trap 'signal_handler "next"' SIGRTMIN+1
trap 'signal_handler "previous"' SIGRTMIN+2

# Arguments and directories setup
echo "arg 0: $0"
echo "arg 1: $1"
echo "arg 2: $2"
echo "arg 3: $3"

resized_dir=$2
true_dir="$HOME/Pictures/Desktop Background Slideshow/${1:-$default_image_dir}/$resized_dir"
timer=5 # seconds

# Initial setup or any other initialization logic can go here
echo "Reading from $true_dir"

# Shuffle images and store in an array
mapfile -d '' images < <(find "$true_dir" -type f -print0 | shuf -z)
total_images=${#images[@]}
current_index=0

# Function to get the next image
get_next_image() {
    ((current_index++))
    if [ $current_index -ge $total_images ]; then
        current_index=0
        mapfile -d '' images < <(find "$true_dir" -type f -print0 | shuf -z)
    fi
    echo "${images[$current_index]}"
}

# Function to get the previous image
get_prev_image() {
    ((current_index--))
    if [ $current_index -lt 0 ]; then
        current_index=$((total_images - 1))
    fi
    echo "${images[$current_index]}"
}

# Main loop for natural cycling
while true; do
    if [ "$next_image" == true ]; then
        next_image=false
        image=$(get_next_image)
    elif [ "$prev_image" == true ]; then
        prev_image=false
        image=$(get_prev_image)
    else
        image=$(get_next_image)
    fi

    if [ "$3" == "none" ]; then
        echo "Setting background to: $image"
    fi
    change_background "$image"

    # Sleep for the timer duration and allow signal interruption
    for ((i=0; i<$timer; i++)); do
        sleep 1 &
        wait $!
        if [[ $next_image == true || $prev_image == true ]]; then
            break
        fi
    done
done
