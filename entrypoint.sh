#!/bin/sh
cd /usr/src/app/
python -u pokecli.py &
sleep 8s
cd /usr/src/app/web
python -m SimpleHTTPServer 8000 &

tail -f /dev/null
