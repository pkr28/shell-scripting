#!/bin/bash

COMPONENT=mysql
source components/common.sh

echo -n "Configure the repo and installing mysql"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo &>> $LOG
yum install mysql-community-server -y &>> $LOG
stat $?

echo -n "Starting mysql service:"
systemctl enable mysqld 
systemctl start mysqld
stat $?

