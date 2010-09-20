#!/bin/bash

#Autostart script

case $1 in
  start)
  # Wallpaper
    nitrogen --restore &&
  # System Tray
  # stalonetray &
  # Conky windows
  ${HOME}/scripts/conky/conky_start.sh
  # cairo-clock & 
  # Skype
    skype &
  # Composite
    xcompmgr -r 13 -o .7 -l -20 -t -17.5 -I .4 -O .7 -D .1 -cCfn &
  # Other Programs
    wicd-client &
  # padevchooser &
  # sonata --hiden & 
  # thinkhdaps & 
    pidgin & 
  # workrave & 
    hp-systray &
    ;;
  end)
    # Kill the processes
    killall conky \
      stalonetray \
      xcompmgr \
      skype \
      wicd-client \
      padevchooser \
      sonata \
      thinkhdaps \
      pidgin \
      workrave \
      hp-systray
    ;;
esac
