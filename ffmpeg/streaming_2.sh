#!/bin/bash

input_file=" frequence_666Mzh_EclairTv.ts"

ffmpeg -re -stream_loop -1 -i ${input_file} \
-r 25 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 \
-vf scale=w=1280:h=720:force_original_aspect_ratio=decrease \
-c:v libx264 -b:v 2M -minrate 2M -maxrate 2M \
-c:a aac -b:a 192k -ar 48000 \
-mpegts_transport_stream_id 0x3344 -mpegts_service_id 0x5566 -metadata service_provider="Mediahub WS" -metadata service_name="Mediahub WS Channel" \
-f mpegts \
"udp://239.0.0.1:1234?pkt_size=1316&localaddr=192.168.1.51"

exit 0
