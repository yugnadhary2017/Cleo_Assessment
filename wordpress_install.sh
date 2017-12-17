#!/bin/bash
cd ~
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/*
cd /var/www/html
cp wp-config-sample.php wp-config.php
cd 

