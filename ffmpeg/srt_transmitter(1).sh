#!/bin/bash

# Adresse IP du rÃ©cepteur
RECEIVER_IP="192.168.1.52"
# Port d'Ã©coute du rÃ©cepteur
RECEIVER_PORT=8080

# Fichier vidÃ©o Ã  envoyer
INPUT="20th.mkv"

# ClÃ© de chiffrement (doit Ãªtre partagÃ©e avec le rÃ©cepteur)
PASSPHRASE="your_password"

# Lancement de l'Ã©mission du flux via SRT avec des options supplÃ©mentaires
ffmpeg -re -i "$INPUT" -c:v libx264 -preset veryfast -b:v 1M -c:a aac -b:a 128k -f mpegts "srt://${RECEIVER_IP}:${RECEIVER_PORT}?pkt_size=1316&latency=200&encryption=128&passphrase=${PASSPHRASE}"

