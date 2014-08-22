#!/bin/bash

source /root/bash_func

PID_FILE=/var/run/setup_collective.pid

wait_pid

WWW_SUM="null"
MYSQL_SUM="null"
while [ true ];do
    NEW_WWW_SUM=$(tar - cf /var/www/html/*|md5sunm|awk '{print $1}')
    if [ ${WWW_SUM} != ${NEW_WWW_SUM} ];then
        echo "WWW-MD5SUM changed... lets to a backup"
    else
        echo "WWW-MD5SUM stayed the same..."
    fi
    NEW_MYSQL_SUM=$(tar - cf /var/lib/mysql/*|md5sunm|awk '{print $1}')
    if [ ${MYSQL_SUM} != ${NEW_MYSQL_SUM} ];then
        echo "MYSQL-MD5SUM changed... lets to a backup"
    else
        echo "MYSQL-MD5SUM stayed the same..."
    fi
    sleep 61
done