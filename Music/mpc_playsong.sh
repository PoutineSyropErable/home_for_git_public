#!/bin/bash

# Check if a song path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <song_path>"
    exit 1
fi

# Convert to an absolute path
SONG_PATH=$(realpath "$1")

printf -- "\nSong Path: '$SONG_PATH'\n\n"

# Extract the file name (song title) from the path
SONG_TITLE=$(basename "$SONG_PATH" .mp3)

# Extract the previous directory name (the directory where the song is located)
PREV_DIR=$(basename "$(dirname "$SONG_PATH")")

printf -- "Song Title: '$SONG_TITLE'\n"
printf -- "Previous Directory: '$PREV_DIR'\n\n"

# Check if the previous directory is "My Music"
if [ "$PREV_DIR" == "My Music" ]; then
    # Use just the filename for insertion
    mpc insert "$SONG_TITLE.mp3"
else
    # Use the directory and filename for insertion
    mpc insert "$PREV_DIR/$SONG_TITLE.mp3"
fi

# Check if the song was added successfully
if [ $? -eq 0 ]; then
    echo "Inserted '$SONG_TITLE.mp3' into the playlist. Now playing next..."
    # Play the next song in the queue
    mpc next
else
    echo "Failed to insert '$SONG_TITLE.mp3' into the playlist. Please check the song title and directory."
    exit 1
fi

