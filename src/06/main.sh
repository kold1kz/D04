#!/bin/bash

if [[ $# != 0 ]]; then 
    echo "Wrong parameters"
else
    goaccess ../04/*txt -o report.html --log-format=COMBINED
    open report.html
fi