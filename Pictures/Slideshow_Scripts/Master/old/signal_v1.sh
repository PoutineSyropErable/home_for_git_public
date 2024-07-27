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
        "toggle")
            echo "Received toggle signal"
            slideshow_playing=!slideshow_playing
            ;;
        *)
            echo "Unknown signal: $1"
            ;;
    esac
}

# Set up signal handlers
trap 'signal_handler "next"' SIGRTMIN+1
trap 'signal_handler "previous"' SIGRTMIN+2
trap 'signal_handler "toggle"' SIGRTMIN+3

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
shuffle_images() {
    mapfile -d '' shuffled_images < <(find "$true_dir" -type f -print0 | shuf -z)
    total_images=${#shuffled_images[@]}
}

shuffle_images
i=0
slideshow_playing=true

# Main loop for natural cycling
while true; do
    if $slideshow_playing; then
        printf "\n\nStart of while loop, i=$i\n"
        
        if [ "$next_image" == true ]; then
            printf "Next image received, i=$i\n"
            next_image=false
            ((i++))
            if [ $i -ge $total_images ]; then
                i=0
            fi
        elif [ "$prev_image" == true ]; then
            printf "Previous image received, i=$i\n"
            prev_image=false
            ((i--))
            if [ $i -lt 0 ]; then
                i=$((total_images - 1))
            fi
        else
            ((i++))
            if [ $i -ge $total_images ]; then
                i=0
            fi
        fi
        
        image="${shuffled_images[$i]}"
        printf "The chosen image is: i=$i, img=$image\n"
        
        if [ "$3" == "none" ]; then
            echo "Setting background to: $image"
        fi
        change_background "$image"
    fi

    # Use read with timeout for natural cycling and signal interruption
    read -t $timer signal_received
done
