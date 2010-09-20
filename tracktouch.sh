#!/bin/bash

pkill osd_cat
OSD_CAT=`which osd_cat`
XOSD="${OSD_CAT} --delay=2 --age=0 --lines=2 --pos=bottom --align=center --font=-adobe-helvetica-bold-r-normal-*-*-180-*-*-p-*-*-* --colour=green --shadow=1 --offset=25 --indent=25"

TOUCHPAD='SynPS/2 Synaptics TouchPad'
TRACKPOINT='TPPS/2 IBM TrackPoint'

synclient TouchpadOff=0
TOUCHPAD_STATE=$(xinput --list-props "${TOUCHPAD}" | grep '137' | sed 's/.*:[\t]//')
#TOUCHPAD_STATE=$(xinput --list-props "${TOUCHPAD}" | grep '137' | awk '$0=$NF' FS=)
TRACKPOINT_STATE=$(xinput --list-props "${TRACKPOINT}" | grep '137' | sed 's/.*:[\t]//')
#TRACKPOINT_STATE=$(xinput --list-props "${TRACKPOINT}" | grep '137' | awk '$0=$NF' FS=)

STATE=$((${TOUCHPAD_STATE} + ${TRACKPOINT_STATE} * 2))

case ${STATE} in
  #if both are off - turn touchpad on
  0)
  xinput --set-prop "${TOUCHPAD}" 137 1
  echo -e "Touchpad On" | ${XOSD}
  ;;
  1)
  xinput --set-prop "${TRACKPOINT}" 137 1
  xinput --set-prop "${TOUCHPAD}" 137 0
  echo -e "Trackpoint On" | ${XOSD}
  ;;
  2)
  xinput --set-prop "${TOUCHPAD}" 137 1
  echo -e "Both On" | ${XOSD}
  ;;
  3)
  xinput --set-prop "${TRACKPOINT}" 137 0
  xinput --set-prop "${TOUCHPAD}" 137 0
  echo -e "Both Off" | ${XOSD}
  ;;
esac

