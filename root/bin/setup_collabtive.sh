#!/bin/bash

touch /var/run/setup_collective.pid

source /root/bash_func

# wait for the pid
watch_pid 0
sleep 2

if [ ! -f /var/www/html/index.php ];then
   source /root/mysql_pw
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
      chown apache: /var/www/html/config/standard/config.php
      chown apache: -R  /var/www/html/{files,templates_c}
      mysql -uroot -p${MYSQLPW_ROOT} < /root/backup_init.sql
   fi
   sed -i -e "s/\$db_pass =.*/\$db_pass = '${MYSQLPW_COLL}';/" /var/www/html/config/standard/config.php
fi

rm -f /var/run/setup_collective.pid

rm -f /root/backup_init.sql /root/collabtive20_init.tar
