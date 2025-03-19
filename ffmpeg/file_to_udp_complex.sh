#!/bin/bash
clear

#Declare here the input file
input_file="06_10_2016_15_46_24833441.ts"

# Step 1 : Extraire les informations de service avec ffprobe
ffprobe -v quiet -print_format json -show_streams -show_format -show_programs ${input_file} > service_info.json

# Ã‰tape 2 : Lire les informations de service
service_name=$(python3 -c "
import json
with open('service_info.json', 'r') as f:
    data = json.load(f)
programs = data.get('programs', [])
if programs:
    service_name = programs[0].get('tags', {}).get('service_name', 'DefaultService')
    provider_name = programs[0].get('tags', {}).get('service_provider', 'DefaultProvider')
print(service_name)
")

provider_name=$(python3 -c "
import json
with open('service_info.json', 'r') as f:
    data = json.load(f)
programs = data.get('programs', [])
if programs:
    service_name = programs[0].get('tags', {}).get('service_name', 'DefaultService')
    provider_name = programs[0].get('tags', {}).get('service_provider', 'DefaultProvider')
print(provider_name)
")

#Afficher les velrus du service_name et du provider_name
#echo ${service_name}
#echo ${provider_name}

Ã‰tape 3 : Utiliser les informations extraites dans la commande ffmpeg
ffmpeg -re -stream_loop -1 \
-fflags +genpts -copyts -fflags +flush_packets \
-i ${input_file} \
-c copy -muxrate 15950k \
-mpegts_service_id 1 -mpegts_service_type digital_tv -metadata service_provider="${provider_name}" -metadata service_name="${service_name}" \
-f mpegts "udp://239.0.0.1:1234?pkt_size=1316&localaddr=172.121.1.51"
