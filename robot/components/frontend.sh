#!/bin/bash

set -e

USERID=$(id -u)
COMPONENT=frontend
LOG=/tmp/$COMPONENT.log

stat() {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi
}

if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m You need to be root User to run this script \e[0m" 
    exit 1
fi

echo -n " Installing Nginx : " 
yum install nginx -y &>> $LOG
stat $?

# echo "Staring nginx service "
# systemctl enable nginx
# systemctl start nginx
# stat $?

# echo "Downloading the $COMPONENT :"
# curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
# stat $?

# echo "Moving to $COMPONENT :"
# cd /usr/share/nginx/html
# rm -rf *
# stat $?

# echo "unzip $COMPONENT files: "
# unzip /tmp/$COMPONENT.zip
# stat $?

# echo "Moving $COMPONENT files:"
# mv $COMPONENT-main/* .
# mv static/* .
# rm -rf $COMPONENT-main README.md
# stat $?

# echo "Configuring proxy file:"
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
# stat $?

# echo "Restaring the service: "
# systemctl restart nginx
# systemctl status nginx -l
# stat $?
