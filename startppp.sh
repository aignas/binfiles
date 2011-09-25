#!/bin/sh

echo "calling"
sudo pppd call gns-ank &
echo "sleeping"
sleep 10
# Only need this next line on OpenSuSE, NOT Ubuntu, which creates it 
# automatically on creation of the ppp connection.
echo "adding"
sudo route add -host 131.111.61.132 gw 192.168.58.62 dev eth0
echo "adding"
sudo route add default gw 131.111.61.130 dev ppp0
echo "deleting"
sudo route del default dev eth0
