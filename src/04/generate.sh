#!/bin/bash

function fill_file {
    logname=$1
    strings_num=`shuf -i 100-1000 -n1`
    for (( i = 0; i < $strings_num; ++i ))
    do

    ip="`shuf -i 1-255 -n1`.`shuf -i 1-255 -n1`.`shuf -i 1-255 -n1`.`shuf -i 1-255 -n1` - -"
    my_date="[`date -d "$start_time $sec_count"sec"" +"%d/%b/%Y:%H:%M:%S"` +0200]"
    method="\"${methods[$(($RANDOM % ${#methods[@]}))]} HTTP/1.1\""
    code="${codes[$(($RANDOM % ${#codes[@]}))]} ${RANDOM:0:100000}"
    agent="\"https://mylittlepony.hasbro.com/\" \"${agents[$(($RANDOM % ${#agents[@]}))]}\""
    echo "$ip $my_date $method $code $agent" >> $logname

    sec_count=$(($sec_count + 1))
    done
    echo "$2 file is done"
}

if [ $# != 0 ]; then
    echo "Script should be launched with 0 parameters"
    exit
fi

export start_time=`date +"%F %H:%M:%S"`
export sec_count=1
export methods=( 'GET' 'POST' 'PUT' 'PATCH' 'DELETE' )
export codes=( 200 201 400 401 403 404 500 501 502 503 )
export agents=( 'Mozilla' 'Google Chrome' 'Opera' 'Safari'\
 'Internet Explorer' 'Microsoft Edge' 'Crawler and bot' 'Library and net tool')

for i in {1..5}
do
start_time=`date -d "$start_time 30hour" +"%F %H:%M:%S"`
touch log"$i".txt
fill_file log"$i".txt $i
done

# 200 - Успешно, сервер успешно обработал запрос
# 201 - Создано, сервер успешно обработал запрос и создал новый ресурс
# 400 - Неверный запрос, не может быть понят сервером из-за некорректного синтаксиса
# 401 - Неавторизованный запрос, для доступа к документу необходимо вводить пароль или быть зарегистрированным пользователем
# 403 - Доступ к ресурсу запрещен, сервер отказывается обработать запрос, у пользователя нет прав на просмотр содержимого
# 404 - Ресурс не найден, сервер не может найти запрашиваемый ресурс
# 500 - Внутренняя ошибка сервера, сервер столкнулся с непредвиденным условием, которое не позволяет ему выполнить запрос
# 501 - Не реализовано, сервер не поддерживает функционал, который необходим для обработки запроса
# 502 - Неверный шлюз, сервер получил недопустимый ответ от следующего сервера в цепочке запросов, к которому обратился при попытке выполнить запрос
# 503 - Сервис недоступен, потому что сервер перегружен или на нём проводятся технические работы