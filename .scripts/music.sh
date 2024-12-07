#!/bin/bash

# Nama file untuk menyimpan PID proses mpv
PID_FILE="/tmp/mpv_music.pid"

if [[ $1 == "stop" ]]; then
    if [[ -f $PID_FILE ]]; then
        # Hentikan proses mpv menggunakan PID
        kill "$(cat $PID_FILE)" && rm -f $PID_FILE
        echo "Music player stopped."
    else
        echo "No music player is running."
    fi
else
    if [[ -f $PID_FILE ]]; then
        echo "Music player is already running."
        exit 1
    fi

    # Jalankan mpv dengan parameter yang diberikan, tanpa terikat terminal
    nohup mpv -v --ytdl-format=ba --loop "$1" > /dev/null 2>&1 &

    # Simpan PID dari proses mpv ke file
    echo $! > $PID_FILE
    echo "Music player started in the background."
fi

