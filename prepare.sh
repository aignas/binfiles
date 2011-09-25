#!/bin/bash

ORIG_IFACE=eth0
ORIG_GW_ADDR=192.168.58.62
DEFAULT_SVN_ADDR=address
DEFAULT_PPP_ADDR=address
DEFAULT_DNS_ADDR=address
OUTPUT=VGA1

function exec {
case $1 in
    --iface=wlan|-iw)
        ORIG_IFACE=wlan0
        ORIG_GW_ADDR=192.168.0.255
        ;;
    --start-vpn|--vpn|-v)
        echo "calling"
        sudo pppd call gns-ank
        sleep 10
        echo "adding stuff"
        sudo route add -host ${DEFAULT_SVN_ADDR} gw ${ORIG_GW_ADDR} dev ${ORIG_IFACE}
        sudo route add default gw ${DEFAULT_PPP_ADDR} dev ppp0
        echo "deleting ${ORIG_IFACE}"
        sudo route del default dev ${ORIG_IFACE}
        echo "Adding a correct DNS server (${DEFAULT_DNS_ADDR})"
        echo "nameserver ${DEFAULT_DNS_ADDR}" | sudo tee -a /etc/resolv.conf >> /dev/null
        ;;
    --stop-vpn|--no-vpn|-nv)
        sudo poff
        sleep 10

        echo "Deleting interface1"
        sudo route del -host ${DEFAULT_SVN_ADDR} gw ${ORIG_GW_ADDR} dev ${ORIG_IFACE}
        echo "Deleting interface2"
        sudo route del default dev ppp0
        echo "Adding interface ${ORIG_IFACE}"
        sudo route add default gw ${ORIG_GW_ADDR} dev ${ORIG_IFACE}
        ;;
    --renew-dns|-rd)
        #sudo dhcpcd -gS domain_name_servers=${DEFAULT_DNS_ADDR} ${ORIG_IFACE}
        echo "Adding a correct DNS server (${DEFAULT_DNS_ADDR})"
        echo "nameserver ${DEFAULT_DNS_ADDR}" | sudo tee -a /etc/resolv.conf >> /dev/null
        ;;
    --display|-d)
        xrandr --output LVDS1 --auto --primary
        xrandr --output ${OUTPUT} --auto --rotate right --right-of LVDS1
        xrandr --output ${OUTPUT} --off
        xrandr --output ${OUTPUT} --auto --rotate right --right-of LVDS1
        echo "The monitors are setup"
        ;;
    --display-off|--no-display|-nd)
        xrandr --output ${OUTPUT} --off
        ;;
    --mount|-m)
        sudo mount -o uid=gns-ank,gid=users,umask=0022,username=user,password=password /mnt/Scherman1group
        ;;
    --umount|-um)
        sudo umount /mnt/Scherman1group
        ;;
    --help|-h)
        cat << EOF
The list of options is as follows:

--iface=wlan0 | -iw
    select wlan0 as the VPN interface
    WARNING! works only if placed before --start-svn
--start-vpn | --vpn | -v
    start VPN 
--stop-vpn | --no-vpn | -nv
    stop VPN
--renew-dns | -rd
    renew DNS for the VPN connection
--display-off | --no-display | -nd
    turn off the secondary display
--display | -d
    configure the secondary display
--mount | -m
    mount the scherman share
--umount | -um
    unmount the scherman share
EOF
        return 0
        ;;
    *)
        cat << EOF
Please specify a paramter or two.
The list of paramaters can be called with the following command:
$ ./prepare.sh --help
or
$ ./prepare.sh -h
EOF
        return 0
        ;;
esac
}

function main {
for param in $@; do
    exec $param
done
}

main $@
