#!/bin/bash

# to fetch the aliases
shopt -s expand_aliases
source /root/bash_func

# wait for the pw file to be written
PID_FILE=/root/mysql_pw
wait_pid
source /root/mysql_pw

# wait for the setup to end
PID_FILE=/var/run/setup_collective.pid
wait_pid

WWW_TS=0
MYSQL_SUM="null"

if [ ! -d /backup ];then
    echo "No /backup directory..."
    exit 0
fi

while [ true ];do
    NEWEST_FILE=$(find /var/www/html/ -type f ! -iregex ".*templates_c.*" -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")
    NEW_WWW_TS=$(stat -c%Y ${NEWEST_FILE})
    if [ ${WWW_TS} -lt ${NEW_WWW_TS} ];then
        echo "$(date) # Newer file '${NEWEST_FILE}' detected '${WWW_TS} -lt ${NEW_WWW_TS}'... lets to a backup"
        WWW_TS=${NEW_WWW_TS}
        cd /var/www/html/
        tar cf /backup/backup_$(date +"%F_%H-%M-%S").tar *
    fi
    mysqldump --all-databases -uroot -p${MYSQLPW_ROOT} > /root/temp_bkp.sql 2>/dev/null
    NEW_MYSQL_SUM=$(cat /root/temp_bkp.sql |egrep -v "(Dump completed on|INSERT INTO \`user\`)" |md5sum |awk '{print $1}')
    if [ ${MYSQL_SUM} != ${NEW_MYSQL_SUM} ];then
        echo "$(date) # MYSQL-MD5SUM changed... lets to a backup"
        MYSQL_SUM=${NEW_MYSQL_SUM}
        cp /root/temp_bkp.sql /backup/backup_$(date +"%F_%H-%M-%S").sql
    fi
    sleep 61
done
