# How to create a file analysis

## 1. Start the script analyis.sh

The script starts tsduck and anaylize your ts file. It will create service_info_tsduck.json and the result of the analysis will be displayed in your browser.

```shell
chmod +x analysis.sh
./analysis.sh
```
The script will create a file service_info_tsduck.json

## 2. Visualize the result in your web browser

Start the http server
```shell
chmod +x start_web_browser.sh
./start_web_browser.sh
```

Open your browser and type http://localhost/tsduck.html