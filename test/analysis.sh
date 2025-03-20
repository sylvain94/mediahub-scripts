#!/bin/bash

## File name to analyze
INPUT_FILE_NAME="mire_720p.ts"

tsp -I file $INPUT_FILE_NAME \
-P analyze --json -o service_info_tsduck.json \
-P until -s 2  -O drop 