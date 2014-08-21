#!/bin/bash

function watch_pid {
   if [ -f ${1} ];then
      sleep 5
      watch_pid ${1}
   else
      exit 1
   fi

}

mysql_install_db
sleep 5
/usr/bin/mysqld_safe & 
sleep 5

RANDPW=$(date +"%F_%H-%M-%S.%N"|md5sum|awk '{print $1}')
sleep 0.2
RANDPW2=$(date +"%F_%H-%M-%S.%N"|md5sum|awk '{print $1}')
MYSQLPW_ROOT=${MYSQLPW_ROOT-${RANDPW}}
MYSQLPW_COLL=${MYSQLPW_COLLAB-${RANDPW2}}

mysqladmin -u root password ${MYSQLPW_ROOT}
mysql -uroot -p${MYSQLPW_ROOT} -e "CREATE DATABASE collabtive"
mysql -uroot -p${MYSQLPW_ROOT} -e "GRANT index, create, select, insert, update, delete, alter, lock tables ON collabtive.* TO 'collabuser'@'localhost' identified by '${MYSQLPW_COLL}';"
mysql -uroot -p${MYSQLPW_ROOT} -e "FLUSH PRIVILEGES;"

if [ ! -f /var/www/html/index.php ];then
   if [ -d /backup ];then
      echo "# BACKUP directory detected"
      tar_file=$(find /backup/ -type f -name \*.tar | xargs ls -ltr | tail -n 1|awk '{print $NF}')
      cd /var/www/html/
      echo "# tar xf ${tar_file}"
      tar xf ${tar_file}
      chown apache: /var/www/html/config/standard/config.php
      chown apache: -R  /var/www/html/{files,templates_c}
      sql_file=$(find /backup/ -type f -name \*.sql | xargs ls -ltr | tail -n 1|awk '{print $NF}')
      echo "# restore from '${sql_file}'"
      mysql -uroot -p${MYSQLPW_ROOT} < ${sql_file}
   else
      echo "# initializing basic"
      # TODO: DB-PW for collabuser should be adjusted
      cd /var/www/html/
      tar xf /root/collabtive20_init.tar
      mysql -uroot -p${MYSQLPW_ROOT} < /root/backup_init.sql
   fi
   sed -i -e "s/\$db_pass =.*/\$db_pass = '${MYSQLPW_COLL}';/" /var/www/html/config/standard/config.php
fi

rm -f /root/backup_init.sql /root/collabtive20_init.tar

watch_pid /var/run/mysqld/mysqld.pid
