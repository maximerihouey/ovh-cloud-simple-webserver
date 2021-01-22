#!/bin/bash

cd /tmp

cat <<EOT >> index.py
import http.server
import socketserver

PORT = 80

Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
EOT

echo "This is a webserver." > index.html

sudo python3 -m index.py 80 &
