#!/bin/bash

. ./generator.sh

function validate {
    if [[ ${#folder_letters_param} -gt 7 ||\
    ! $folder_letters_param =~ [[:alpha:]] ]]; then
    echo "Wrong letters for folder"
    exit
    fi

    export filename=${files_letters_param%.*}
    export extension=${files_letters_param#*.}
    if [[ ${#filename} -gt 7 ||\
    ${#extension} -gt 3 ||\
    ! $filename =~ [[:alpha:]] || ! $extension =~ [[:alpha:]] ]]; then
    echo "Wrong letters for files or extension"
    exit
    fi

    export size=${size_param%mb*}
    if [[ ! $size_param =~ ^([0-9]|[1-9][0-9]|100)mb$ ]]\
    || [[ $size -lt 1 || $size -gt 100 ]]; then
    echo "Wrong size of files"
    exit
    fi

    generate
}