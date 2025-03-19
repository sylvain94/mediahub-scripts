#!/bin/bash

#IP de l'interface d'ecoute
IP=192.168.1.52

# Port d'écoute pour recevoir le flux
PORT=8080

# # Fichier de sortie pour le flux reçu
#FOR MULTICAST OUTPUT #OUTPUT_VIDEO="-f mpegts udp://239.0.0.1:1234?localaddr=192.168.1.52"
OUTPUT_VIDEO="test.ts"

# # Clé de chiffrement (doit être partagée avec l'émetteur)
PASSPHRASE="your_password"

# # Paramètres de reconnexion
RECONNECT="&reconnect=1&reconnect_attempts=10&reconnect_delay_min=1000&reconnect_delay_max=10000"


tsp -I srt --listener ${IP}:${PORT} --transtype live --messageapi -P until --seconds 10 -P analyze -O drop
