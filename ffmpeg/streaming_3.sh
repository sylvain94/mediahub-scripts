ffmpeg -stream_loop -1 \
-i 20th.mkv \
-filter_complex \
"[0:v]split=1[v1]; \
[v1]scale=w=1280:h=720[v1out]" \
-map "[v1out]" -c:v:0 libx264 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v:0 5M -maxrate:v:0 5M -minrate:v:0 5M -bufsize:v:0 10M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 \
-map a:0 -c:a:0 aac -b:a:0 96k -ac 2 \
-mpegts_transport_stream_id 0x3344 -mpegts_service_id 0x5566 -metadata service_provider="Mediahub WS" \
-f mpegts \
"udp://239.0.0.1:1234?pkt_size=1316&localaddr=172.121.1.51"

