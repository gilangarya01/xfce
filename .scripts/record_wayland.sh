#!/bin/bash

# Nama perangkat mikrofon (audio eksternal)
AUDIO_MICROPHONE="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"
#AUDIO_MICROPHONE="NoiseTorch Microphone for Tiger Lake-LP Smart Sound Technology Audio Controller"

# Nama file output
VIDEO_OUTPUT="/home/gilang/Videos/Recording/video_$(date +%Y%m%d_%H%M%S).mp4"
AUDIO_OUTPUT="/home/gilang/Videos/Recording/audio_$(date +%Y%m%d_%H%M%S).mp3"

# Start recording function
start_recording() {
    echo "Starting recording..."

    # Video and internal audio
	gpu-screen-recorder -w screen -f 60 -a default_output -o "$VIDEO_OUTPUT" > /dev/null 2>&1 &

    # External microphone audio
    ffmpeg -loglevel quiet -y -f pulse -ac 2 -i "$AUDIO_MICROPHONE" \
           -c:a libmp3lame "$AUDIO_OUTPUT" &

    echo "Recording started."
}

# Stop recording function
stop_recording() {
    echo "Stopping recording..."
	killall -SIGINT gpu-screen-recorder
    pkill -INT -x ffmpeg
    #noisetorch -u
    echo "Recording stopped."
}

case "$1" in
    start)
        start_recording
        ;;
    stop)
        stop_recording
        ;;
    *)
        echo "Usage: $0 {start|stop|pause|resume}"
        ;;
esac
