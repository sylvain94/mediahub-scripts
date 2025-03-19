#Type your input file here :
input_file="par2-sentry-06-Port5-TF1HD+-TriggeredByUser-20240718-095210-00-c2.ts"

# Step 1 : Analyze the incoming signal with ffprobe and send the result to service_info.json
ffprobe -v quiet -print_format json -show_streams -show_format -show_programs ${input_file} > service_info.json

# Step 2 : Read the json and create the variables
output=$(python3 -c "
import json
import re
with open('service_info.json', 'r') as f:
    data = json.load(f)
programs = data.get('programs', [])

if programs:
    service_name = programs[0].get('tags', {}).get('service_name', 'DefaultService')
    service_provider = programs[0].get('tags', {}).get('service_provider', 'DefaultProvider')
    service_id = programs[0].get('program_id', 1)
    pmt_pid = programs[0].get('pmt_pid', 4096)
else:
    service_name = 'DefaultService'
    service_provider = 'DefaultProvider'
    service_id = 1  # default service_id
    pmt_pid = 4096 # default pmt_id

service_name = re.sub(r'[^a-zA-Z0-9 ]', '', service_name)
service_id_hex = hex(service_id)
pmt_pid_hex = hex(pmt_pid)

print(service_name)
print(service_provider)
print(service_id_hex)
print(pmt_pid_hex)
")

# Assigning the variables
service_name=$(echo "$output" | sed -n '1p')
service_provider=$(echo "$output" | sed -n '2p')
service_id_hex=$(echo "$output" | sed -n '3p')
pmt_pid_hex=$(echo "$output" | sed -n '4p')

# Display the service_name, service_provider and service_id_hex, pmt_pid_hex values
echo "Service Name: ${service_name}"
echo "Provider Name: ${service_provider}"
echo "Service Id Hex: ${service_id_hex}"
echo "PMT PID Hex : ${pmt_pid_hex}"

# Step 3 : ffmpeg command
ffmpeg -re -stream_loop -1 \
-fflags +genpts -copyts -fflags +flush_packets \
-i "${input_file}" \
-c copy -muxrate 12950k \
-mpegts_transport_stream_id 0x1 -mpegts_service_id "${service_id_hex}" -mpegts_pmt_start_pid "${pmt_pid_hex}" -metadata service_provider="${service_provider}" -metadata service_name="${service_name}" \
-f mpegts \
"udp://239.0.0.1:1234?pkt_size=1316&localaddr=172.121.1.51"
