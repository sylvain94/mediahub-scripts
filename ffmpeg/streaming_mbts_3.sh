#!/bin/bash

SERVICE_ID="service01"

echo "##########################"
echo "## Encodage OTT en cours ##"
echo "##########################"

ffmpeg -re -stream_loop -1 -i 20th.ts \
-filter_complex \
"[0:v]split=2[v1][v2]; \
[v1]scale=w=1280:h=720[v1out]; \
[v2]scale=w=640:h=360[v2out]" \
-map "[v1out]" -map a:0 -c:v libx264 -profile:v high -level 4.1 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v 3M -maxrate 2M -minrate 2M -bufsize 4M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 -c:a aac -b:a 96k -ac 2 -f mpegts "udp://239.0.0.1:2001?pkt_size=1316&localaddr=192.168.1.102" \
-map "[v2out]" -map a:0 -c:v libx264 -profile:v main -level 3.1 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v 1M -maxrate 1M -minrate 1M -bufsize 2M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 -c:a aac -b:a 48k -ac 2 -f mpegts "udp://239.0.0.1:2002?pkt_size=1316&localaddr=192.168.1.102"

