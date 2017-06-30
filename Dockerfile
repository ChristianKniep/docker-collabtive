###### Updated version of fedora (20)
FROM qnib/centos6_supervisor
MAINTAINER "Christian Kniep <christian@qnib.org>"

EXPOSE 80
VOLUME ["/var/www/html", "/var/lib/mysql"]
RUN yum update -y \
 && yum install -y tar vim mysql-server ImageMagick-perl \
 && yum install -y httpd \
 && yum install -y php php-pear php-xml php-mysql php-intl php-pecl-apc php-gd php-mbstring

# httpd start
ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

# Jumpstart mariadb
RUN getent passwd mysql || useradd mysql \
 && mkdir -p /var/run/mysqld \
 && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
ADD etc/supervisord.d/start_mysqld.ini /etc/supervisord.d/start_mysqld.ini
ADD root/bin/start_mysqld.sh /root/bin/start_mysqld.sh

ADD root/bash_func /root/
ADD etc/supervisord.d/setup_collabtive.ini /etc/supervisord.d/
ADD root/bin/setup_collabtive.sh /root/bin/
ADD etc/supervisord.d/backup_site.ini /etc/supervisord.d/
ADD root/bin/backup_site.sh /root/bin/

#COPY collabtive20_init.tar /root/collabtive20_init.tar
COPY backup_init.sql /root/backup_init.sql
RUN cd /root/ \
 && wget -q https://github.com/philippK-de/Collabtive/archive/3.0.2.zip

CMD /usr/bin/supervisord -c /etc/supervisord.conf
