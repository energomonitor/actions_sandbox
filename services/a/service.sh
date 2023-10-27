#!/bin/bash

counter=1

while true; do
    echo "Service '$SERVICE_NAME': $counter"
    ((counter++))
    sleep 1
done
