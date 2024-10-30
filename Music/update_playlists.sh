#!/bin/bash

# Exit on first error, and show the line number of the error
set -e
set -o pipefail


# Trap to print the line number where the error occurred
trap 'echo "Error on line $LINENO"; exit 1;' ERR

# Base directories
music_dir="/home/francois/Music/My Music"
mpd_playlist_dir="/home/francois/Music/Playlist"

# Ensure the playlist directory exists
mkdir -p "$mpd_playlist_dir"

# Function to write sorted music files into the playlist file
write_playlist() {
    local dir_path="$1"
    local playlist_name="$2"
    
    printf -- "----------Reading the Files from $dir_path---------------------\n"
    
    # Playlist file path
    local playlist_file="$mpd_playlist_dir/$playlist_name.m3u"
    
    # Remove existing playlist file and create a new one
    rm -f "$playlist_file"
    touch "$playlist_file"

    # Find all music files (e.g., .mp3, .flac, .wav) in the given directory (max depth 1),
    # sort them alphabetically, and write to the playlist file
    find "$dir_path" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.opus" \) \
        | sort | while read -r music_file; do
            # Write the absolute path of each music file to the playlist file
            echo "$music_file" >> "$playlist_file"
            echo "$music_file"
        done

    printf "\nWritten sorted music files from $dir_path into $playlist_file \n\n\n"
}

# Arrays to store playlist names and their corresponding directories
playlist_names=()
playlist_directories=()

# Ensure the base music directory is included as a playlist
playlist_names+=("My Music")
playlist_directories+=("$music_dir")

# Find all directories with a max depth of 1 under the music directory
while IFS= read -r dir; do
    # Extract the relative path after the base music directory
    relative_path="${dir#$music_dir/}"

    # Replace slashes with " - " to create the playlist name
    playlist_name=$(echo "$relative_path" | sed 's/\// - /g')

    # If there is no relative path, it means it's the base directory
    if [ -z "$relative_path" ]; then
        playlist_name="My Music"
    fi

    # Append the playlist name and the directory to the arrays
    playlist_names+=("$playlist_name")
    playlist_directories+=("$dir")
done < <(find "$music_dir" -mindepth 1 -type d)

# Iterate through the playlist array and create playlist files
for i in "${!playlist_names[@]}"; do
    # Call the function to write the playlist
    write_playlist "${playlist_directories[i]}" "${playlist_names[i]}"
done


mpc update
printf -- "\n\n-------------------------------------------\nAll playlist files created and populated in $mpd_playlist_dir.\n\n"
