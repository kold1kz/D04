#!/bin/bash

. ./generator.sh

function validate {
    if [[ !(-d $path_param) ]]; then
    echo "Wrong path"
    exit
    fi

    if [[ ${path_param:0:1} != "/" ]]; then
    echo "Wrong path"
    exit
    fi

    if [[ ${path_param: -1} == "/" ]]; then
    echo "Wrong path"
    exit
    fi

    if [[ ! $folders_num_param =~ [0-9] || $folders_num_param -le 0 ]]; then
    echo "Wrong num of folders"
    exit
    fi

    if [[ ${#folder_letters_param} -gt 7 ||\
    ! $folder_letters_param =~ [[:alpha:]] ]]; then
    echo "Wrong letters for folder"
    exit
    fi

    if [[ ! $files_num_param =~ [0-9] || $files_num_param -le 0 ]]; then
    echo "Wrong number of folders"
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

    export size=${size_param%kb*}
    if [[ ! $size_param =~ ^([0-9]|[1-9][0-9]|100)kb$ ]]\
    || [[ $size -lt 1 || $size -gt 100 ]]; then
    echo "Wrong size of files"
    exit
    fi

    generate
}