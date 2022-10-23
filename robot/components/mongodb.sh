#!/bin/bash
set -e

COMPONENT=mongodb
source components/common.sh

echo -n "Downloading repo :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo &>> $LOG 
stat $?

echo -n "Installing mongodb : "
yum install -y mongodb-org &>> $LOG
stat $?

echo -n "Editing the conf file :"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
stat $?

echo -n "Starting mongodb service"
systemctl enable mongod
systemctl start mongod
stat $?

echo -n "Downloading mongodb schema :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip" &>> $LOG
stat $?

echo -n "Unzipping mongodb schema"
cd /tmp
unzip mongodb.zip &>> $LOG
cd mongodb-main
mongo < catalogue.js &>> $LOG
mongo < users.js &>> $LOG
stat $?

echo -n "Restarting mongodb service"
systemctl restart mongod
stat $?
