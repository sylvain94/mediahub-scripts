#!/bin/bash

#IP de l'interface d'ecoute
IP=192.168.1.52

# Port d'écoute pour recevoir le flux
PORT=8080

# # Fichier de sortie pour le flux reçu
OUTPUT_VIDEO="output_video.ts"

# # Clé de chiffrement (doit être partagée avec l'émetteur)
PASSPHRASE="your_password"

# # Lancement de la réception du flux via SRT avec des options supplémentaires
ffmpeg -hide_banner -i "srt://${IP}:${PORT}?mode=listener&pkt_size=1316&latency=200&encryption=128&passphrase=${PASSPHRASE}" -c copy "$OUTPUT_VIDEO"

