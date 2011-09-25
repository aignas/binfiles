#!/bin/bash
NUM=$1
if [[ -z $1 ]]; then NUM="1"; fi
for i in $(seq ${1:-1}); do
  nohup urxvt >/dev/null 2>&1 $
done
