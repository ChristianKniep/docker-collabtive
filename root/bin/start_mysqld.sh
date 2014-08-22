#!/bin/bash

source /root/bash_func

mysql_install_db
sleep 2
/usr/bin/mysqld_safe & 
sleep 2

RANDPW=$(date +"%F_%H-%M-%S.%N"|md5sum|awk '{print $1}')
sleep 0.2
RANDPW2=$(date +"%F_%H-%M-%S.%N"|md5sum|awk '{print $1}')
MYSQLPW_ROOT=${MYSQLPW_ROOT-${RANDPW}}
MYSQLPW_COLL=${MYSQLPW_COLLAB-${RANDPW2}}

echo "MYSQLPW_ROOT=${MYSQLPW_ROOT}" > /root/mysql_pw
echo "MYSQLPW_COLL=${MYSQLPW_COLL}" >> /root/mysql_pw

mysqladmin -u root password ${MYSQLPW_ROOT}
mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE DATABASE collabtive"
mysql -uroot -p${MYSQLPW_ROOT} -e "GRANT index, create, select, insert, update, delete, alter, lock tables ON collabtive.* TO 'collabuser'@'localhost' identified by '${MYSQLPW_COLL}';"
mysql -uroot -p${MYSQLPW_ROOT} -e "FLUSH PRIVILEGES;"

watch_pid 1
