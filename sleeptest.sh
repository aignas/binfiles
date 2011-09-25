#!/bin/bash
# sleep.sh test script for measuring power drain during suspend-to-ram with ACPI
# needs bc packages to do all the floating point computations

# default settings, change if needed
LOG="/var/log/battery.log"
BATTERY="BAT0"
THRESHOLD=400

if [ ! "x${UID}"=="x0" ]; then
   echo 'This script can only be run by root.'
   exit 1
fi

# get start values
date >> $LOG
DATE_BEFORE=`date +%s`
BAT_BEFORE=`cat /sys/devices/platform/smapi/$BATTERY/remaining_capacity`

# go to sleep and custom commands to try out
# if you 
if [ "x$1" != "x" ] ; then
  $1
else
  echo "not good"
fi

if ! grep -q 'discharging' /sys/devices/platform/smapi/$BATTERY/state; then
cat << EOF
---------------------
!!! Not running on battery power, did you forget to disconnect the charger?
!!! The results might not or are not realible if you see this message
---------------------
EOF
   #exit 1
fi

sleep 3

# get end values
DATE_AFTER=`date +%s`
BAT_AFTER=`cat /sys/devices/platform/smapi/$BATTERY/remaining_capacity`

# do the calculations 
DIFF=`echo "$BAT_AFTER - $BAT_BEFORE" | bc`
SECONDS=`echo "$DATE_AFTER - $DATE_BEFORE" | bc`
USAGE=`echo "$DIFF * 3600 / $SECONDS" | bc`

# output the results
cat << EOF
before: $BAT_BEFORE mWh
after: $BAT_AFTER mWh
diff: $DIFF mWh
seconds: $SECONDS sec
result: $USAGE mW
EOF
if [ $USAGE -le -$THRESHOLD ]
then
    echo "!!! Power consumption while suspended to RAM is very high !!!."
fi
if [ $SECONDS -lt 1200 ]
then

cat << EOF
  !!! The notebook was suspended less than 20 minutes.
  !!! To get representative values please let the notebook sleep
  !!! for at least 20 minutes.
EOF
fi
echo ""
