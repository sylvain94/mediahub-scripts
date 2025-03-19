SERVICE_ID=service01


echo ##########################
echo ##Encodage OTT en cours###
echo ##########################

##Preset OTT premium - 4 to 6 profiles , p1 5mbs 1920x1080, p2 3mbs 1280x720, p3 1,2mbs 640x360, p4 416kbps 400x224
preset_ott_premium=""
##Preset OTT standard - 3 profiles , p1 2,1mbs 1024x576, p2 1,2mbs 640x360, p3 416kbps 400x224
preset_ott_standard=""
##Preset OTT basic - 1 profile , p1 5mbs 1920x1080
preset_ott_basic=""


ffmpeg -i 20th.mkv \
-filter_complex \
"[0:v]split=3[v1][v2][v3]; \
[v1]copy[v1out]; [v2]scale=w=1280:h=720[v2out]; [v3]scale=w=640:h=360[v3out]" \
-map "[v1out]" -c:v:0 libx264 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v:0 5M -maxrate:v:0 5M -minrate:v:0 5M -bufsize:v:0 10M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 \
-map "[v2out]" -c:v:1 libx264 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v:1 3M -maxrate:v:1 3M -minrate:v:1 3M -bufsize:v:1 3M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 \
-map "[v3out]" -c:v:2 libx264 -x264-params "nal-hrd=cbr:force-cfr=1" -b:v:2 1M -maxrate:v:2 1M -minrate:v:2 1M -bufsize:v:2 1M -preset slow -g 48 -sc_threshold 0 -keyint_min 48 \
-map a:0 -c:a:0 aac -b:a:0 96k -ac 2 \
-map a:0 -c:a:1 aac -b:a:1 96k -ac 2 \
-map a:0 -c:a:2 aac -b:a:2 48k -ac 2 \
-f mpegts udp://239.0.0.1:2001?pkt_size=1316&localaddr=192.168.1.51 \
-f mpegts udp://239.0.0.1:2002?pkt_size=1316&localaddr=192.168.1.51
