#!/bin/bash
##Mysql docker container initialization######
docker pull mysql
docker run --detach --name=cleo-mysql --env="MYSQL_ROOT_PASSWORD=cleo@123" --publish 6033:3306 mysql
mysql -u root -P 6033 -h localhost -p'cleo@123' -e "create database wordpress"
mysql -u root -P 6033 -h localhost -p'cleo@123' -e "create user 'wordpressuser'@'%' identified by 'cleo@123'"
mysql -u root -P 6033 -h localhost -p'cleo@123' -e "grant all privileges on wordpress.* TO 'wordpressuser'@'%'"


