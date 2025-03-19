#!/bin/bash

# Adresse IP du receiver
RECEIVER_IP="192.168.1.52"
# Port d'Ã©coute du receiver
RECEIVER_PORT=8080

# Fichier vidÃ©o Ã  envoyer
INPUT_VIDEO="20th.mkv"

# ClÃ© de chiffrement (doit Ãªtre partagÃ©e avec Machine 2)
PASSPHRASE="your_password"

# Lancement de l'Ã©mission du flux via SRT en mode caller avec des options supplÃ©mentaires
ffmpeg -re -stream_loop 100 -i "$INPUT_VIDEO" -c:v libx264 -preset veryfast -b:v 1M -c:a aac -b:a 128k -f mpegts "srt://${RECEIVER_IP}:${RECEIVER_PORT}?mode=caller&pkt_size=1316&latency=200&encryption=128&passphrase=${PASSPHRASE}"
