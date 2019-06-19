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
START=1
WS=18
clear
echo "Menu Deployment to Gourmate Mobile Device"
echo "......"
cd /u/${ACCOUNT}/
for ((k=${START};k<=${WS};k++))
do
	if [ $k -lt 10 ]
	then
		rm -f /var/www/html/GMMobile0$k/config*.zip
        cp data/extMenuExport_0$k.inf data/extMenuExport.inf
        /usr/gm/bin/extMenuExport
		chmod 666 /var/www/html/GMMobile0$k/config*.zip
	else
		rm -f /var/www/html/GMMobile$k/config*.zip
        cp data/extMenuExport_$k.inf data/extMenuExport.inf
        /usr/gm/bin/extMenuExport
		chmod 666 /var/www/html/GMMobile$k/config*.zip
	fi
done

echo "Menu Deployment Completed."
echo "Please download menu at Gourmate Mobile Device"
echo 
echo "Press [ENTER] to continue"
read cont
