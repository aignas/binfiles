#!/bin/sh

for file in ${HOME}/.conky/.*.conkyrc
do
  conky -q -c $file &
done;
      
