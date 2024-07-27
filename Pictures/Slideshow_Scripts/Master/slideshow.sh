#!/bin/bash
notify-send "Started Slideshow" -t 3000


timer=5 # seconds


# Arguments and directories setup
echo "current script path: $0"
echo "Slideshow directory: $1"
echo "Resized option: $2"
echo "print option (Empty = print): $3"
echo "first image of slideshow: $4" # will be chosen randomly otherwise


# Default directory containing original images (if no path provided)
default_image_dir="Cool Pictures"
resized_dir="${2:-resized}"
true_dir="$HOME/Pictures/Desktop Background Slideshow/${1:-$default_image_dir}/$resized_dir"


# Check if $4 is provided and not empty; otherwise, choose a random image from $true_dir
if [ -n "$4" ]; then
    default_picture="$4"
else
	default_picture=$(find "$true_dir" -type f -print0 | shuf -n 1 -z)
fi

echo "default picture: $default_picture"



# Initial setup or any other initialization logic can go here
printf "Reading from $true_dir \n\n"



shopt -s failglob

FIFO=test.FIFO  # can be changed to whatever

mkfifo "${FIFO}"         # create a fifo
trap 'rm "${FIFO}"' EXIT # clean fifo at end of script



# Function to change background using feh
change_background() {
	feh --bg-center --bg-fill --no-fehbg "$1"
	#echo swaybg -i "$1"
	#swaybg -i "$1"
}


# Function to handle signals and manage natural cycling
signal_handler() {
	case $1 in
		"next")
			#notify-send "going to next picture"
			echo "next" > "${FIFO}"
			printf "Received next signal\n\n"
			next_image=true
			;;
		"previous")
			#notify-send "going to previous picture"
			echo "previous" > "${FIFO}"
			printf "Received previous signal\n\n"
			prev_image=true
			;;
		"toggle")
			if [ $slideshow_playing = true ] ; then
				notify-send "Stopped playing slideshow"
				slideshow_playing=false
			else
				notify-send "Restarted playing slideshow"
				slideshow_playing=true
			fi
			printf "Received toggle signal\n"
			printf "The slideshow is playing? $slideshow_playing \n\n"
			;;

		"faster")
			printf "Recieved faster signal\n\n" -t 1000
			timer=$(echo "$timer / 1.1" | bc -l)
			notify-send "Faster | New timer is: $timer"
			;;

		"slower")
			echo "Recieved slower signal"
			timer=$(echo "$timer * 1.1" | bc -l)
			notify-send "Slower | New timer is $timer" -t 1000
			;;
		*)
			echo "Unknown signal: $1"
			;;
	esac
}




# Set up signal handlers
trap 'signal_handler "next"'     SIGRTMIN+1
trap 'signal_handler "previous"' SIGRTMIN+2
trap 'signal_handler "toggle"'   SIGRTMIN+3
trap 'signal_handler "faster"'   SIGRTMIN+4
trap 'signal_handler "slower"'   SIGRTMIN+5






shuffle_images() {
    local default_image="$1"  # Path to the default image

    # Find all images excluding the default image
    mapfile -d '' other_images < <(find "$true_dir" -type f ! -name "$(basename "$default_image")" -print0 | shuf -z)
    
    # Combine the default image with the shuffled images
    shuffled_images=("$default_image" "${other_images[@]}")
    total_images=${#shuffled_images[@]}
	
	printf "Inside shuffle: Default image= $default_image\n"
	printf "first image= ${shuffled_images[0]}\n"
	printf "second image= ${shuffled_images[1]}\n"
}





shuffle_images "$default_picture"
i=-1
slideshow_playing=true
next_image=false
prev_image=false
single_play=false

# Main loop for natural cycling
while true; do
	if [ "$next_image" == true ]; then
		next_image=false
		single_play=true
		((i++))
		if [ $i -ge $total_images ]; then
			i=0
			shuffle_images "$default_picture"  # a function call
			notify-send "Reshuffled images"
		fi
	elif [ "$prev_image" == true ]; then
		printf "Previous image received, i=$i\n"
		prev_image=false
		single_play=true
		((i--))
		if [ $i -lt 0 ]; then
			i=$((total_images - 1))
			shuffle_images "$default_picture"
			notify-send "Reshuffled images"
		fi
	elif [ $slideshow_playing = false ]; then
		#we pause here. double check to avoid indentation
		: # do nothing
	else
		((i++))
		if [ $i -ge $total_images ]; then
			i=0
		fi
	fi

	if [ $slideshow_playing = true ] || [ $single_play = true ] ; then
		image="${shuffled_images[$i]}"

		if [ "$3" == "none" ]; then
			printf "Setting background to: $image\n\n"
		fi
		change_background "$image"
		single_play=false
	fi 
	 # The timer part of the code
	 read -t $timer <> "${FIFO}"  || true 
done
