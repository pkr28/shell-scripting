#!/bin/bash
set -e

COMPONENT=frontend
source components/common.sh

echo -n " Installing Nginx : " 
yum install nginx -y &>> $LOG
stat $?

echo -n "Downloading the $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Moving to $COMPONENT :"
cd /usr/share/nginx/html
rm -rf * &>> $LOG
stat $?

echo -n "unzip $COMPONENT files: "
unzip /tmp/$COMPONENT.zip &>> $LOG
stat $?

echo -n "Moving $COMPONENT files:"
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md &>> $LOG
stat $?

echo -n "Configuring proxy file:"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOG
stat $?

echo -n "Staring the service: "
systemctl start nginx 
systemctl enable nginx
stat $?
