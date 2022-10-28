#!/bin/bash

COMPONENT=catalogue
APPUSER=roboshop
source components/common.sh

echo -n "Downloading and Installing NodeJS"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
yum install nodejs -y &>> $LOG
stat $?

id $APPUSER
if [ $? -ne 0 ] ; then
echo -n "Creating User"
useradd $APPUSER
stat $?
fi

echo -n "Downloading $COMPONENT files"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOG
stat $?

echo -n "Changing to $APPUSER"
cd /home/$APPUSER
stat $?

echo -n "Unzipping $COMPONENT components : "
unzip -o /tmp/$COMPONENT.zip &>> $LOG
stat $?

echo -n "Cleaning and Moving $COMPONENT files"
rm -rf $APPUSER
mv $COMPONENT-main $COMPONENT
cd /home/$APPUSER/$COMPONENT
npm install &>> $LOG
stat $?

echo -n "Changing Permissions of $APPUSER:"
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT && chmod -R 775 /home/$APPUSER/$COMPONENT 
stat $?

echo -n "Editing $COMPONENT services file: "
sed -i -e 's/MONGO_DNSNAME/mongodb.robo.internal/' /home/$APPUSER/$COMPONENT/systemd.service 
stat $?

echo -n "Starting the service"
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
systemctl daemon-reload
systemctl start $COMPONENT
systemctl enable $COMPONENT
systemctl status $COMPONENT -l &>> $LOG
stat $?

