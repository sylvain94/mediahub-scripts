#!/bin/bash

input_file="06_10_2016_15_46_24833441.ts"
#input_file="par2-sentry-06-Port5-TF1HD+-TriggeredByUser-20240718-095210-00-c2.ts"

# Ã‰tape 1 : Analysing of the incoming signal with ffprobe
ffprobe -v quiet -print_format json -show_streams -show_format -show_programs ${input_file} > service_info.json

# Step 2 : Read the information of the incoming signal
read -r service_name provider_name <<- EOM
$(python3 -c "
import json
with open('service_info.json', 'r') as f:
    data = json.load(f)
programs = data.get('programs', [])
if programs:
    service_name = programs[0].get('tags', {}).get('service_name', 'DefaultService')
    service_provider = programs[0].get('tags', {}).get('service_provider', 'DefaultProvider')
else:
    service_name = 'DefaultService'
    service_provider = 'DefaultProvider'
print(service_name)
print(service_provider)
")
EOM

# Display the value of the service_name and service_provider
echo "Service Name: ${service_name}"
echo "Provider Name: ${service_provider}"

# Step 3 : ffmpeg command
ffmpeg -re -stream_loop -1 \
-fflags +genpts -copyts -fflags +flush_packets \
-i ${input_file} \
-c copy -muxrate 15950k \
-mpegts_service_id 1 -mpegts_service_type digital_tv -metadata service_name "${service_name}" -metadata service_provider "${service_provider}" \
-f mpegts "udp://239.0.0.1:1234?pkt_size=1316&localaddr=172.121.1.51"
