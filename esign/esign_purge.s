#!/bin/bash
WS=18
for ((x=1;x<=${WS};x++))
do
	if [ $x -lt 10 ];then
		cd /var/www/html/GMMobile0${x}
		rm -f checkImg/*.jpg
		rm -f uploads/*.jpg
		rm -f checkImg/*.bmp
		rm -f uploads/*.bmp
	else
		cd /var/www/html/GMMobile${x}
		rm -f checkImg/*.jpg
		rm -f uploads/*.jpg
		rm -f checkImg/*.bmp
		rm -f uploads/*.bmp
	fi
done