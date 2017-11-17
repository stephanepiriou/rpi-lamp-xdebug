#!/bin/bash

echo "zend_extension=$ZEND_EXTENSION" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_enable=$REMOTE_ENABLE" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_handler=$REMOTE_HANDLER" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_mode=$REMOTE_MODE" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_host=$REMOTE_HOST" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.remote_port=$REMOTE_PORT" | sudo tee -a /etc/php5/mods-available/xdebug.ini
echo "xdebug.idekey=$IDEKEY" | sudo tee -a /etc/php5/mods-available/xdebug.ini
sudo php5enmod xdebug