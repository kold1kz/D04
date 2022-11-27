#!/bin/bash

. ./cleaner.sh

if [[ $# == 1 ]] && [[ $1 == "1" || $1 == "2" || $1 == "3" ]]; then
    export menu=$1
    cleaner_func
else
    echo "Wrong parameters"
fi