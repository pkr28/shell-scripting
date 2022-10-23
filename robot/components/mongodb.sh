#!/bin/bash
set -e

COMPONENT=mongodb
source components/common.sh

echo -n "Downloading repo :"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo &>> $LOG 
stat $?

echo -n "Installing $COMPONENT : "
yum install -y $COMPONENT-org &>> $LOG
stat $?

echo -n "Editing the conf file :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 
stat $?

echo -n "Starting $COMPONENT service"
systemctl enable mongod
systemctl start mongod
stat $?

echo -n "Downloading $COMPONENT schema :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOG
stat $?

echo -n "Unzipping $COMPONENT schema"
cd /tmp
unzip $COMPONENT.zip &>> $LOG
cd $COMPONENT-main
mongo < catalogue.js &>> $LOG
mongo < users.js &>> $LOG
stat $?

echo -n "Restarting $COMPONENT service"
systemctl restart mongod
stat $?
