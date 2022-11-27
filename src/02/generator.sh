#!/bin/bash

function log_it {
    if ! [ -e `pwd`/log.txt ]; then
    touch `pwd`/log.txt
    fi
    log_path=$1
    log_size=$2

    if [[ $log_size == "0" ]]; then
    echo "$log_path - `date +"%F %H:%M:%S"`" >> `pwd`/log.txt
    else
    echo "$log_path - `date +"%F %H:%M:%S"` - $log_size" >> `pwd`/log.txt
    fi
}

function random_path {
    num=`shuf -i 1-$path_num -n1`
    while true
    do
    path=`find / -maxdepth 3\
     -type d -perm -o+w 2>/dev/null ! \( -wholename "*/bin" -o -wholename "*/bin/*" -o -wholename\
      "*/sbin" -o -wholename "*/sbin/*" -o -wholename "*/proc/*" \) | sort -R | awk '(NR == '$num')'`
        if ! (mkdir $path/$foldername\_$current_date 2>/dev/null); then
        num=$(( 1 + `shuf -i 1-$path_num -n1` ))
        else
        break
        fi
    done
}

function final_output {
    end_time=`date +"%H:%M:%S"`
    duration=$SECONDS

    echo "script start time: $start_time" >> `pwd`/log.txt
    echo "script end time: $end_time" >> `pwd`/log.txt
    echo "duration: $(($duration / 60)) minutes and $(($duration % 60)) seconds" >> `pwd`/log.txt

    tail -n3 `pwd`/log.txt
    exit
}

function check_path_num {
    path_num=`find / -maxdepth 3\
     -type d -perm -o+w 2>/dev/null ! \( -wholename "*/bin" -o -wholename "*/bin/*" -o -wholename\
      "*/sbin" -o -wholename "*/sbin/*" -o -wholename "*/proc/*" \) | wc -l`
}

function create_file {
    size_dd=$1
    file_name_dd=$2

    dd if=/dev/zero of=$file_name_dd bs=$size_dd count=1 2>/dev/zero
}

function create_nodes {
    export path
    export path_num
    check_path_num

    for (( i=0; i<$folders_num; i++ ))
    do
        random_path
        log_it $path/$foldername\_$current_date 0
        new_filename=$filename

        for (( j=1; j<=$files_num; j++ ))
        do
            create_file $size"MB" $path/$foldername\_$current_date/$new_filename\_$current_date"."$extension
            log_it $path/$foldername\_$current_date/$new_filename\_$current_date"."$extension $size"mb"
            new_filename=$new_filename${filename: -1}
            root_size=`df -k /root | tail -n1 | awk '{print $4}'`
            if [[ $root_size -le 1048576 ]]; then
            final_output
            fi
        done
        foldername=$foldername${foldername: -1}
    done
    create_nodes
}

function generate {
    root_size=`df -k /root | tail -n1 | awk '{print $4}'`
	if [[ $root_size -le 1048576 ]]; then
    echo "No space on device"
    exit 
    fi

    export limit=$(( ( $root_size - 1048576 ) / ( $size * 1024 ) ))
    export current_date=`date +"%d%m%y"`
    export foldername=$folder_letters_param
    export folders_num=`shuf -i 1-100 -n1`
    export files_num=$(( $limit / $folders_num + 3 ))
    if [[ $limit -lt 1 ]]; then
    exit
    fi

    while [[ ${#foldername} -lt 5 ]]
    do
    foldername=$foldername${foldername: -1}
    done

    while [[ ${#filename} -lt 5 ]]
    do
    filename=$filename${filename: -1}
    done

    create_nodes
}

