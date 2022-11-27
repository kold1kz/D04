#!/bin/bash

function log_it {
    if ! [ -e `pwd`/log.txt ]; then
    touch `pwd`/log.txt
    fi
    log_path=$1
    log_size=$2

    if [[ $log_size == "0" ]]; then
    echo "$log_path - `date +"%d %b %Y %H:%M:%S"`" >> `pwd`/log.txt
    else
    echo "$log_path - `date +"%d %b %Y %H:%M:%S"` - $log_size" >> `pwd`/log.txt
    fi
}

function create_file {
    size_dd=$1
    file_name_dd=$2

    dd if=/dev/zero of=$file_name_dd bs=$size_dd count=1 2>/dev/zero
}

function create_nodes {
    for (( i=0; i<$folders_num_param; i++ ))
    do
        mkdir $path_param/$foldername\_$current_date
        log_it $path_param/$foldername\_$current_date 0
        new_filename=$filename

        for (( j=1; j<=$files_num_param; j++ ))
        do
            create_file $size"KB" $path_param/$foldername\_$current_date/$new_filename\_$current_date"."$extension
            log_it $path_param/$foldername\_$current_date/$new_filename\_$current_date"."$extension $size"kb"
            new_filename=$new_filename${filename: -1}
            root_size=`df -k /root | tail -n1 | awk '{print $4}'`
            if [[ $root_size -le 1048576 ]]; then
            exit
            fi
        done
        foldername=$foldername${foldername: -1}
    done
}

function generate {
    export root_size=`df -k /root | tail -n1 | awk '{print $4}'`
	if [[ $root_size -le 1048576 ]]; then
    echo "No space on device"
    exit 
    fi

    export limit=$(( ( $root_size - 1048576 ) / $size ))
    export current_date=`date +"%d%m%y"`
    export foldername=$folder_letters_param
    if [[ $limit -lt 1 ]]; then
    exit
    fi

    while [[ ${#foldername} -lt 4 ]]
    do
    foldername=$foldername${foldername: -1}
    done

    while [[ ${#filename} -lt 4 ]]
    do
    filename=$filename${filename: -1}
    done

    create_nodes
}