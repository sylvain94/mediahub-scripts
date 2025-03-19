#!/bin/bash

#-re : Lit l'entrÃ©e en temps rÃ©el, cela permet de maintenir la vitesse de diffusion Ã  1x.
#-stream_loop -1 : lit le fichier d'entrÃ©e en boucle 
#-fflags +genpts flush_packets : gÃ©nÃ¨re des horodatages PTS/DTS corrects.
#-copyts : copie les tables du signal d'entrÃ©e Ã  la sortie.

clear


input_file="/home/vdpj3398/20th.ts" 
#input_file="frequence_666Mzh_EclairTv.ts"
#input_file="06_10_2016_15_46_24833441.ts"

ffmpeg -re -stream_loop -1 \
-fflags +genpts -copyts -fflags +flush_packets \
-i ${input_file} \
-c copy -muxrate 10950k \
-f mpegts "udp://239.0.0.2:5000?pkt_size=1316&localaddr=192.168.100.102"
