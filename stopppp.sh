#!/bin/sh

echo "off"
sudo poff
sleep 10

sudo route del -host 131.111.61.129 gw 192.168.58.62 dev eth0
sudo route del default dev ppp0
sudo route add default gw 192.168.58.62 dev eth0
