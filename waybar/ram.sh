#!/bin/bash

# Prints the total ram and used ram in MiB

get_ram() {
    TOTAL_RAM=$(free -mh --si | awk  {'print $2'} | head -n 2 | tail -1)
    USED_RAM=$(free -mh --si | awk  {'print $3'} | head -n 2 | tail -1)
    MB="MiB"

    echo "$USED_RAM/$TOTAL_RAM$MB"
}

get_ram
