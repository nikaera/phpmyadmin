FROM centos:centos7
MAINTAINER shun <shun@kadinche.com>

RUN yum -y update ca-certificates
RUN yum -y update
RUN yum -y install yum-fastestmirror; yum clean all
RUN yum -y install epel-release; yum clean all

RUN yum -y install mysql mysql-devel mysql-server mysql-utilities; yum clean all
RUN yum -y install php php-mysql php-mcrypt phpmyadmin; yum clean all
RUN yum -y install httpd; yum clean all
RUN chown -R apache:apache /usr/share/phpMyAdmin
RUN sed -i -e"s/Allow from 127.0.0.1/Allow from all/g" /etc/httpd/conf.d/phpMyAdmin.conf
RUN sed -i -e"s/Require ip 127.0.0.1/Require all granted/g" /etc/httpd/conf.d/phpMyAdmin.conf
RUN sed -i -e"s/DirectoryIndex index.html/DirectoryIndex index.html index.php/g" /etc/httpd/conf/httpd.conf

ADD config.inc.php /etc/phpMyAdmin/config.inc.php
ADD randomize_18.sh /root/randomize_18.sh
RUN HASH=`sh /root/randomize_18.sh`; \
	sed -i -e"s/{hash}/${HASH}/g" /etc/phpMyAdmin/config.inc.php
RUN sed -i -e"s/{MYSQL_HOST}/${MYSQL_HOST:=mysql}/g" /etc/phpMyAdmin/config.inc.php
RUN sed -i -e"s/{MYSQL_PORT}/${MYSQL_PORT:=3306}/g" /etc/phpMyAdmin/config.inc.php

CMD httpd -k start; tail -f /var/log/httpd/error_log
