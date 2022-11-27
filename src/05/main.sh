#!/bin/bash

function sort_codes {
    for i in ../04/*.txt
    do
    sort -k 8 $i
    done
}

function sort_unique_ip {
    for i in ../04/*.txt
    do
    sort -uk 1 $i
    done
}

function sort_error {
    for i in ../04/*.txt
    do
    awk '$8~/^[45]/' $i
    done
}

function sort_unique_ip_where_error {
    for i in ../04/*.txt
    do
    awk '$8~/^[45]/' $i | sort -uk 1
    done
}

if [[ $# == 1 ]] && [[ "$1" =~ ^(1|2|3|4)$ ]]; then
    case $1 in
    1)  sort_codes;;
    2)  sort_unique_ip;;
    3)  sort_error;;
    4)  sort_unique_ip_where_error;;
esac
else
    echo "Wrong parameters"
fi