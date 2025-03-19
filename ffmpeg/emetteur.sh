#!/bin/bash

# Adresse IP du rÃ©cepteur
RECEPTEUR_IP="127.0.0.1"
# Port d'Ã©coute du rÃ©cepteur
RECEPTEUR_PORT=9999

# Fichier vidÃ©o Ã  envoyer
INPUT_VIDEO="20th.mkv"

# Lancement de l'Ã©mission du flux via SRT
ffmpeg -re -i "$INPUT_VIDEO" -c:v libx264 -preset veryfast -b:v 1M -c:a aac -b:a 128k -f mpegts "srt://${RECEPTEUR_IP}:${RECEPTEUR_PORT}?pkt_size=1316"