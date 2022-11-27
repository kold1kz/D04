#!/bin/bash

. ./validator.sh
. ./generator.sh

if [[ $# == 3 ]]; then
    export folder_letters_param=$1
    export files_letters_param=$2
    export size_param=$3
    export start_time=`date +"%H:%M:%S"`
    export SECONDS=0


    validate
else
    echo "Wrong number of parameters"
fi