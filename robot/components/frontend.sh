#!/bin/bash

set -e

USERID=$(id -u)
COMPONENT=$COMPONENT

if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m You need to be root User to run this script \e[0m" 
fi

echo " Installing Nginx : "
yum install nginx -y

# echo "Staring nginx service "
# systemctl enable nginx
# systemctl start nginx

# echo "Downloading the $COMPONENT :"
# curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"

# echo "Moving to $COMPONENT :"
# cd /usr/share/nginx/html
# rm -rf *

# echo "unzip $COMPONENT files: "
# unzip /tmp/$COMPONENT.zip

# echo "Moving $COMPONENT files:"
# mv $COMPONENT-main/* .
# mv static/* .
# rm -rf $COMPONENT-main README.md

# echo "Configuring proxy file:"
# mv localhost.conf /etc/nginx/default.d/roboshop.conf

# echo "Restaring the service: "
# systemctl restart nginx
# systemctl status nginx -l
