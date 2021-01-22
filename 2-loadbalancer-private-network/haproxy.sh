#!/bin/bash

sudo apt-get install haproxy -y

# changing config
echo "" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "frontend http_front" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "   bind *:80" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "   stats uri /haproxy?stats" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "   default_backend http_back" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "backend http_back" | sudo tee -a /etc/haproxy/haproxy.cfg
echo "   balance roundrobin" | sudo tee -a /etc/haproxy/haproxy.cfg
%{ for addr in ip_addrs ~}
echo "   server ${addr} ${addr}:80 check" | sudo tee -a /etc/haproxy/haproxy.cfg
%{ endfor ~}
echo "" | sudo tee -a /etc/haproxy/haproxy.cfg

sudo systemctl restart haproxy
