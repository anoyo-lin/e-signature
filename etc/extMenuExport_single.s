#!/bin/bash
ACCOUNT=$1
if [ "${ACCOUNT}" == "" ]
then
echo "please follow the account id in commandline"
echo "example: ./install_gmm.s z01"
exit
fi
LOCAL=`pwd`
DATE=`date +%Y%m%d`

clear
echo "Menu Deployment to Gourmate Mobile Device"
echo "......"
rm -f /var/www/html/GMMobile01/config*.zip
cd /u/${ACCOUNT}
/usr/gm/bin/extMenuExport

echo "Menu Deployment Completed."
echo "Please download menu at Gourmate Mobile Device"
echo 
echo "Press [ENTER] to continue"
read cont
