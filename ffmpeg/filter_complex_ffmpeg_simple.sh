#!/bin/bash

#Define input_id (begin at 0, autoincrement if there are several inputs)
input_id="0"

#Define Input signal
input_signal="frequence_666Mzh_EclairTv.ts"

#Define service_id in decimal
service_id=8706

#Output Choice Menu
echo -e "1(File output- output_file.ts) "
echo -e "2(Multicast Output - 239.0.0.1:1234) "
echo -e "3(Exit) "
echo -e "Choice : \c "
read choice

#If the choice is not 1 or 2, then exit
if [[ "$choice" != [1-3] ]]
then
	echo "Invalid argument"
	exit 1
fi

case "$choice" in
#If the choice is 1
1)	if [[ "$choice" = 1 ]]
	then 
		output_signal="output_file.ts"
fi
;;
#if the choice is 2
2)	if [[ "$choice" = 2 ]]
	then 
		output_signal="udp://239.0.0.1:1234?pkt_size=1316"
fi
;;
#If the choice is 3
3)	if [[ "$choice" = 3 ]]
	then 
		echo "Goodbye"
		exit 1
fi
;;
esac

echo ${output_signal}
#output_signal="output_file.ts"

#ffmpeg command
ffmpeg -stream_loop 100 -i ${input_signal} \
-filter_complex \
"[${input_id}:p:${service_id}]split=1[v0]; \
[v0]scale=w=1280:h=720[v0_out]" \
-map [v0_out] -c:v libx264 -x264opts nal-hrd=cbr:force-cfr=1 -b:v 5M -minrate 5M -maxrate 5M -bufsize 1M -muxrate 10M \
-map 0:a -c:a aac -b:a 192k \
-mpegts_transport_stream_id 0x3344 -mpegts_service_id 0x5566 -metadata service_provider="Mediahub WS" -metadata service_name="Mediahub WS Channel" \
-f mpegts ${output_signal}

exit 0
