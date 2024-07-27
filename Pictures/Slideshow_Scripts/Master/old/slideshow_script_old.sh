#!/bin/bash

# this changes the actual desktop and takes the directory of the slideshow as input and if the second argument is 
# left empty, then echo every time the background change

echo "arg 0: $0"
echo "arg 1: $1"
echo "arg 2: $2"
echo "arg 3: $3"


# Default directory containing original images (if no path provided)
default_image_dir="Cool Pictures"
#options: "Actual Pictures" "Desktop Background Slideshow"  "Hot Girls"  "Screenshots"


resized_dir=$2

# Directory containing original images (use default if not provided)
true_dir="$HOME/Pictures/Desktop Background Slideshow/${1:-$default_image_dir}/$resized_dir"
timer=5 # seconds


#printf "\nReading from $true_dir\n"

while true; do
    # Use find to get a list of files and shuffle them with shuf
    find "$true_dir" -type f -print0 | shuf -z | while IFS= read -r -d '' f; do
		if [ "$3" == "none" ]; then
        	echo "Setting background to: $f"
		fi
        feh  --bg-center --bg-fill --no-fehbg "$f"
        sleep $timer
    done
done

