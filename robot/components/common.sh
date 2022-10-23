
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