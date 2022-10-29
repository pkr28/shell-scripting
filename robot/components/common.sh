
LOG=/tmp/$COMPONENT.log

USERID=$(id -u)

#Verifying function
stat() {
    if [ $1 -eq 0 ]; then
        echo -e "\e[32m Success \e[0m"
    else 
        echo -e "\e[31m Failure \e[0m"
    fi
}
# validation of Root user
if [ $USERID -ne 0 ] ; then
    echo -e "\e[31m You need to be root User to run this script \e[0m" 
    exit 1
fi

NODEJS(){
    echo -n "Downloading and Installing NodeJS"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOG
    yum install nodejs -y &>> $LOG
    stat $?

    #Creating a user
    CREATE_USER

    # Downloading and extracting code
    DOWNLOADING_AND_EXTRACTING

    #Installing npm
    NPM_INSTALL

    #Configuring the system files
    SYSTEM_SERVICE
}

CREATE_USER() {
    id $APPUSER
        if [ $? -ne 0 ] ; then
        echo -n "Creating User"
        useradd $APPUSER
        stat $?
        fi
}
DOWNLOADING_AND_EXTRACTING() {
   
    echo -n "Downloading $COMPONENT files"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOG
    stat $?
    
    echo -n "Cleaning & Unzipping $COMPONENT components : "
    rm -rf /home/$APPUSER/$COMPONENT
    cd /home/$APPUSER/ 
    unzip -o /tmp/$COMPONENT.zip &>> $LOG
    mv $COMPONENT-main $COMPONENT
    stat $?

    echo -n "Changing Permissions of $APPUSER:"
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT 
    chmod -R 775 /home/$APPUSER/$COMPONENT
    stat $?
}

NPM_INSTALL() {
    echo -n "Installing $COMPONENT dependencies"
    cd /home/$APPUSER/$COMPONENT
    npm install &>> $LOG
    stat $?
}

SYSTEM_SERVICE() {
    echo -n "Editing $COMPONENT services file: "
    sed -i -e 's/MONGO_DNSNAME/mongodb.robot.internal/' -e 's/REDIS_ENDPOINT/redis.robot.internal/' -e 's/MONGO_ENDPOINT/mongodb.robot.internal/'  -e 's/CATALOGUE_ENDPOINT/catalogue.robot.internal/' /home/$APPUSER/$COMPONENT/systemd.service 
    stat $?

    echo -n "Starting the service"
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    systemctl daemon-reload
    systemctl start $COMPONENT
    systemctl enable $COMPONENT
    stat $?
}