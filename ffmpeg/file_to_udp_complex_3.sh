#!/bin/bash

#Type your input file here :
input_file="par2-sentry-06-Port5-TF1HD+-TriggeredByUser-20240718-095210-00-c2.ts"

# Step 1 : Analyse the incoming signal with ffprobe and send the result to service_info.json
ffprobe -v quiet -print_format json -show_streams -show_format -show_programs ${input_file} > service_info.json

# Step 2 : Read the json and create the variables
read -r service_name service_provider service_id_hex <<- EOM
$(python3 -c "
import json
import re
with open('service_info.json', 'r') as f:
    data = json.load(f)
programs = data.get('programs', [])

if programs:
    service_name = programs[0].get('tags', {}).get('service_name', 'DefaultService')
    service_provider = programs[0].get('tags', {}).get('service_provider', 'DefaultProvider')
    service_id = programs[0].get('program_id', 1)
else:
    service_name = 'DefaultService'
    service_provider = 'DefaultProvider'
    service_id_hex = "0x1"  # Service Id by default

service_name = re.sub(r'[^a-zA-Z0-9 ]', '', service_name)
service_id_hex = hex(service_id)

print(service_name)
print(service_provider)
print(service_id_hex)
")
EOM

# Display the service_name, service_provider and service_id_hex values
echo "Service Name: ${service_name}"
echo "Provider Name: ${service_provider}"
echo "Service Id Hex: ${service_id_hex}"

# Ã‰tape 3 : Commande ffmpeg
ffmpeg -re -stream_loop -1 \
-fflags +genpts -copyts -fflags +flush_packets \
-i ${input_file} \
-c copy -muxrate 15950k \
-mpegts_transport_stream_id 0x1 -mpegts_service_id ${service_id_hex} -metadata service_provider="${service_provider}" -metadata service_name="${service_name}" \
-f mpegts \
"udp://239.0.0.1:1234?pkt_size=1316&localaddr=172.121.1.51"

