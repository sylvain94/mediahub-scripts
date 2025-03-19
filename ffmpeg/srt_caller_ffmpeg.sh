#!/bin/bash

#IP de l'interface d'ecoute
IP=192.168.1.52

# Port d'écoute pour recevoir le flux
PORT=8080

#FOR MULTICAST OUTPUT 
OUTPUT_VIDEO="-f mpegts udp://239.0.0.1:1234?localaddr=192.168.1.52"

#Fichier de sortie
#OUTPUT_VIDEO="test.ts"

# # Clé de chiffrement (doit être partagée avec l'émetteur)
PASSPHRASE="your_password"

# Lancement de la réception du flux via SRT en mode listener avec reconnection automatique
ffmpeg -i "srt://192.168.1.52:8080?mode=listener&pkt_size=1316&latency=200&encryption=128&passphrase=${PASSPHRASE}&reconnect=1&reconnect_attempts=10&reconnect_delay_min=1000&reconnect_delay_max=10000" -c copy ${OUTPUT_VIDEO}
