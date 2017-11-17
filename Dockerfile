FROM resin/rpi-raspbian:latest
MAINTAINER Stephane Piriou <stephane.piriou@zaclys.net>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt php5-dev php-pear build-essential && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN sudo pecl install xdebug

# Add image configuration and scripts
ADD config-xdebug.sh /config-xdebug.sh
ADD start-apache2.sh /start-apache2.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf


# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure /app folder with sample app
RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 50M
ENV PHP_POST_MAX_SIZE 50M

# Xdebug config environement variable 
ENV ZEND_EXTENSION /usr/lib/php5/20100525+lfs/xdebug.so
ENV REMOTE_ENABLE 1
ENV REMOTE_HANDLER dbgp
ENV REMOTE_MODE jit 
ENV REMOTE_HOST 127.0.0.1
ENV REMOTE_PORT 9000
ENV IDEKEY phpStorm


# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80 3306
CMD ["/run.sh"]
