#!/bin/bash
# PORTMASTER: simplemusicplayer.zip, simplemusicplayer.sh
MUSIC_DIR="./simplemusicplayer/music"
PID_FILE="/tmp/mpg123_player.pid"
LOG_FILE="./simplemusicplayer/log.txt"

# Initialize log file (create if doesn't exist)
touch "$LOG_FILE"

# Logging function with timestamp
log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

log "The script has been ran."

# Get all MP3 files into an array
shopt -s nullglob
mp3_files=("$MUSIC_DIR"/*.mp3)
shopt -u nullglob

# Shuffle
shuffle_array() {
    local i j tmp
    for ((i=${#mp3_files[@]}-1; i>0; i--)); do
        j=$(( RANDOM % (i+1) ))
        tmp="${mp3_files[i]}"
        mp3_files[i]="${mp3_files[j]}"
        mp3_files[j]="$tmp"
    done
    log "Playlist reshuffled (${#mp3_files[@]} songs)."
}

# Stop if running
if [[ -f "$PID_FILE" ]]; then
    pid=$(< "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        kill -9 "$pid"
        pkill -f mpg123
        rm -f "$PID_FILE"
        log "Playback stopped."
        echo "Music stopped. Log: $LOG_FILE"
        exit 0
    else
        rm -f "$PID_FILE"
    fi
fi

# Check if no MP3s exist
if [[ ${#mp3_files[@]} -eq 0 ]]; then
    log "ERROR: No MP3 files in $MUSIC_DIR"
    echo "Error: No MP3 files found. See logs: $LOG_FILE"
    exit 1
fi

shuffle_array

# Start playback in a fully detached subshell
(
    current_index=0
    while true; do
        if (( current_index >= ${#mp3_files[@]} )); then
            shuffle_array
            current_index=0
        fi

        song_name="$(basename "${mp3_files[current_index]}")"
        log "Now playing: $song_name"
        mpg123 -q "${mp3_files[current_index]}" 2>> "$LOG_FILE"
        ((current_index++))
    done
) &> /dev/null &  # Detach from terminal

# Save PID and disown the process (so it survives terminal exit)
echo $! > "$PID_FILE"
disown $!

log "Playback started (${#mp3_files[@]} songs)."
echo "Music started. Logs: $LOG_FILE"
exit 0  # Return the control to user immediately
