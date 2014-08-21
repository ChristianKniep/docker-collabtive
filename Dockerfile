###### Updated version of fedora (20)
FROM centos6/supervisor
MAINTAINER "Christian Kniep <christian@qnib.org>"

EXPOSE 80
VOLUME ["/var/www/html", "/var/lib/mysql"]
RUN yum install -y tar

RUN yum install -y mysql-server ImageMagick-perl
RUN yum install -y httpd php php-pear php-xml php-mysql php-intl php-pecl-apc php-gd php-mbstring

# httpd start
ADD etc/supervisor.d/httpd.ini /etc/supervisord.d/httpd.ini

# Jumpstart mariadb
RUN useradd mysql
RUN mkdir -p /var/run/mysqld; chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
ADD etc/supervisor.d/start_mysqld.ini /etc/supervisord.d/start_mysqld.ini
ADD root/bin/start_mysqld.sh /root/bin/start_mysqld.sh

COPY collabtive20_init.tar /root/collabtive20_init.tar
COPY backup_init.sql /root/backup_init.sql

CMD /usr/bin/supervisord -c /etc/supervisord.conf
