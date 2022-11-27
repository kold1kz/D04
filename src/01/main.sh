#!/bin/bash

. ./validator.sh
. ./generator.sh

if [[ $# == 6 ]]; then
    export path_param=$1
    export folders_num_param=$2
    export folder_letters_param=$3
    export files_num_param=$4
    export files_letters_param=$5
    export size_param=$6

    validate
else
    echo "Wrong number of parameters"
fi