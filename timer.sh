#!/bin/bash

if [[ (-z $1 || -z $2) ]] || \
    [[ "$1" = "-h" || "$1" = "--help" ]]; then
    echo "timer [work duration] [break duration] [custom command[optional]]"
    echo "timer -h --help"
    echo "time is measured in minutes, so for a break to be 15min enter number 15"
    exit 1
fi

WORK=$(($1*60))
BREAK=$(($2*60))
TIME=0

while true; do
    mpc pause
    echo "tea.title:set_text('Work :')" | awesome-client
    while [[ $TIME -le $WORK ]]; do
        sleep 1
        TIME=$(($TIME+1))
        echo "tea.progbar:set_value($TIME/$WORK)" | awesome-client
    done
    TIME=0
    mpc play
    echo "tea.title:set_text('Break :')" | awesome-client
    while [[ $TIME -le $BREAK ]]; do
        sleep 1
        TIME=$(($TIME+1))
        echo "tea.progbar:set_value($TIME/$BREAK)" | awesome-client
    done
    TIME=0
done
