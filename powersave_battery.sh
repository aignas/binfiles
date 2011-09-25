#!/bin/bash

#### Ethernet section
# disable Wake On Lan
ethtool -s eth0 wol d

#### Wireless Section
# Wifi powersaving 1 - least, 5 - most, 6 - disable
iwpriv wlan0 set_power 5

# Unused bluetooth

# SATA link power management
for i in /sys/class/scsi_host/host*/link_power_management_policy
do echo min_power > $i
done
