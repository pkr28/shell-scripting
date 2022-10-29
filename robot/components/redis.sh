#!/bin/bash

COMPONENT=redis
APPUSER=roboshop
source components/common.sh

echo -n "Installing $COMPONENT"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo &>> $LOG
yum install $COMPONENT-6.2.7 -y &>> $LOG
stat $?

echo -n "Editing the conf file :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod$COMPONENT.conf 
stat $?

echo -n "Starting $COMPONENT service"
systemctl daemon-reload
systemctl enable $COMPONENT
systemctl start $COMPONENT
stat $?