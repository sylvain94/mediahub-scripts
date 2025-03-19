ffmpeg -stream_loop 100 -i par2-sentry-05-Port18-TF1autres-TriggeredByUser-20240718-093251-00-c2.ts \
-f mpegts udp://239.0.0.1:1234?pkt_size=1316
