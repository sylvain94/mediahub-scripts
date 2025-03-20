# How to create a file analysis

## 1. Start the script analysis.sh

The script starts tsduck, anaylize your ts file and then create service_info_tsduck.json.

```shell
chmod +x analysis.sh
./analysis.sh
```
## 2. Visualize the result in your web browser

Start the http server to diplay the analysis result

```shell
chmod +x start_web_browser.sh
./start_web_browser.sh
```

Open your browser and type http://localhost:8000/index.html