#!/bin/bash

# Type your input file here :
input_file="20th.ts"

# Type your stream key here :
stream_key="your-stream-key"

ffmpeg -re -i ${input_file} \
  -c:v libx264 -preset veryfast -maxrate 4500k -bufsize 9000k \
  -c:a aac -b:a 128k \
  -f flv "rtmp://a.rtmp.youtube.com/live2/${stream_key}"
