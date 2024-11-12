#!/bin/bash

# Nama perangkat monitor (audio internal)
AUDIO_INTERNAL="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink.monitor"

# Nama perangkat mikrofon (audio eksternal)
#AUDIO_MICROPHONE="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"
AUDIO_MICROPHONE="easyeffects_source"

# Nama file output
VIDEO_OUTPUT="/home/gilang/Videos/Recording/video_$(date +%Y%m%d_%H%M%S).mp4"
AUDIO_OUTPUT="/home/gilang/Videos/Recording/audio_$(date +%Y%m%d_%H%M%S).mp3"

# Start recording function
start_recording() {
    echo "Starting recording..."

    # Video and internal audio
    ffmpeg -loglevel quiet -y -f x11grab -s 1366x768 -r 25 -i :0.0 \
           -f pulse -ac 2 -i "$AUDIO_INTERNAL" \
           -c:v libx264 -preset ultrafast -c:a aac "$VIDEO_OUTPUT" &

    # External microphone audio
    ffmpeg -loglevel quiet -y -f pulse -ac 2 -i "$AUDIO_MICROPHONE" \
           -c:a libmp3lame "$AUDIO_OUTPUT" &

    echo "Recording started."
}

# Stop recording function
stop_recording() {
    echo "Stopping recording..."
    pkill -INT -x ffmpeg
    echo "Recording stopped."
}

# Pause function (use SIGSTOP to pause ffmpeg processes)
pause_recording() {
    echo "Pausing recording..."
    pkill -STOP -x ffmpeg
    echo "Recording paused."
}

# Resume function (use SIGCONT to resume ffmpeg processes)
resume_recording() {
    echo "Resuming recording..."
    pkill -CONT -x ffmpeg
    echo "Recording resumed."
}

case "$1" in
    start)
        start_recording
        ;;
    stop)
        stop_recording
        ;;
    pause)
        pause_recording
        ;;
    resume)
        resume_recording
        ;;
    *)
        echo "Usage: $0 {start|stop|pause|resume}"
        ;;
esac
