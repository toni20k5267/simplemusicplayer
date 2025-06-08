# simplemusicplayer
A simple music player, made in mind for linux handheld consoles that support detecting .sh scripts.

## Simple, easy to understand, supports mp3s, what's the catch?
The music player has no gui, nor does it have any control. It automatically shuffles songs using the bag shuffling method.

## How do you start/stop the music?
Running(opening) the file should toggle the music.

# Oh no! The music doesn't play and the logs say `No such file or directory` multiple times! What do I do?
If that happens, you have to manually change the MUSIC_DIR, LOG_FILE to full paths(eg: /userdata/roms/ports/simplemusicplayer/log.txt). You can find the full path using the command "realpath [file name/folder name]".
If the same issue happens with mpg123, in the [simplemusicplayer.sh file, line 70](https://github.com/toni20k5267/simplemusicplayer/blob/7748d6327ca8227e1c0ac5054555ac943abfed5b/simplemusicplayer.sh#L70 to the full path using `realpath [where the mpg123 is located(by default it is in /mpg123/bin/mpg123).
