#!/bin/bash

#input_file="TNT_11_1_17.ts"
input_file="20th.ts"

#Step 1 - Analysing the TS file
tsp -I file ${input_file} \
-P until -s 2 \
-P analyze --json -o service_info_tsduck.json \
-O drop

#Step 2 - Playing the TS file to IP Multicast
tsp -r -I file ${input_file} \
-P regulate \
-O ip \
-l 172.121.1.51 239.0.0.1:1234

exit 0
