#!/bin/bash

trap 'echo "Signal SIGINT caught"' SIGINT

while true
do
   echo "Press Ctrl-C to generate SIGINT signal"
   sleep 1
done
exit 1