#!/bin/bash

###############################################################################
# Packager HLS LIVE 2 paliers depuis les flux multicast générés par ffmpeg
# - Flux 1 (HD)  : udp://239.0.0.1:2001 (720p)
# - Flux 2 (SD)  : udp://239.0.0.1:2002 (480p)
# - Segments HLS : 10 secondes (.ts)
# - Structure : service01/service01_720p.m3u8 et service01/service01_480p.m3u8
###############################################################################

set -e

########################
# Paramètres à adapter #
########################

# Service ID
SERVICE_ID="service01"

# Multicast / interface locale (doit matcher ton script ffmpeg)
MULTICAST_IP="239.0.0.1"
LOCAL_IF_IP="192.168.1.102"

PORT_HD=2001   # correspond au 720p dans streaming_mbts_3.sh
PORT_SD=2002   # correspond au 360p dans streaming_mbts_3.sh (sera renommé en 480p)

# Répertoire de sortie HLS
OUTPUT_DIR="./${SERVICE_ID}"

# Binaire Shaka Packager (change si nécessaire : packager, shaka-packager, etc.)
PACKAGER_BIN="packager"

############
# Structure des dossiers
############

# Créer la structure de dossiers
mkdir -p "${OUTPUT_DIR}/${SERVICE_ID}_720p"
mkdir -p "${OUTPUT_DIR}/${SERVICE_ID}_480p"

############
# Exécution
############

echo "###############################"
echo "## Packaging HLS LIVE Shaka ##"
echo "###############################"
echo "Service ID : ${SERVICE_ID}"
echo "Flux HD : udp://${MULTICAST_IP}:${PORT_HD} (720p)"
echo "Flux SD : udp://${MULTICAST_IP}:${PORT_SD} (480p)"
echo "Dossier de sortie : ${OUTPUT_DIR}"
echo "Segments : 10 secondes (.ts)"
echo

echo
echo "Packaging LIVE terminé."
echo "Playlists HLS :"
echo "  - ${OUTPUT_DIR}/${SERVICE_ID}_720p.m3u8"
echo "  - ${OUTPUT_DIR}/${SERVICE_ID}_480p.m3u8"
echo "Tu peux les lire avec un player HLS (VLC, hls.js, etc.)."

${PACKAGER_BIN} \
  "input=udp://${MULTICAST_IP}:${PORT_HD}?interface=${LOCAL_IF_IP},stream=video,stream=audio,segment_template=${OUTPUT_DIR}/${SERVICE_ID}_720p/${SERVICE_ID}_\$Number%02d\$.ts,playlist_name=${OUTPUT_DIR}/${SERVICE_ID}_720p.m3u8" \
  "input=udp://${MULTICAST_IP}:${PORT_SD}?interface=${LOCAL_IF_IP},stream=video,stream=audio,segment_template=${OUTPUT_DIR}/${SERVICE_ID}_480p/${SERVICE_ID}_\$Number%02d\$.ts,playlist_name=${OUTPUT_DIR}/${SERVICE_ID}_480p.m3u8" \
  --hls_playlist_type LIVE \
  --segment_duration 10 \
  --hls_time 10 \
  --preserved_segments_outside_live_window 10 \
  --hls_master_playlist_output ${OUTPUT_DIR}/${SERVICE_ID}_master.m3u8


