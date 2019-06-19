#!/bin/bash
LOCAL=`pwd`
DATE=`date +%Y%m%d`
CORE=`cat /proc/cpuinfo|grep processor|awk '{print $3}'|tail -n 1`
let CORE+=1

if [ -d /u/gmm_env_setup ]
then
	rm -fr /u/gmm_env_setup/*
else
	mkdir /u/gmm_env_setup
fi
cp -p ${LOCAL}/env/* /u/gmm_env_setup/
cd /u/gmm_env_setup

echo "step 1: install json-c-0.8"
sleep 5
tar zxvf json-c-0.8.tar.gz
cd json-c-0.8
./configure --prefix=/usr
make
make install
echo "step 1: finished!"
sleep 5

echo "step 2: install PCRE Library"
sleep 5
cd /u/gmm_env_setup
tar zxvf pcre-8.36.tar.gz
cd pcre-8.36
./configure --prefix=/usr/local/pcre
make
make install
sleep 5
echo "step 2: finished!"

echo "test if apache exsits in linux OS"
cd ${LOCAL}
if [ ! "`ps -ef|grep httpd|grep -v grep|awk '{print $2 ""}'`" == "" ]
then
echo "httpd exsits"
/usr/sbin/apachectl -k stop
else
echo "httpd do not exsit"
fi
sleep 5

echo "step 3: install httpd"
sleep 5

if [ -d /usr/local/apache ]
then
mv /usr/local/apache /usr/local/apache_backup
fi

cd /u/gmm_env_setup
tar zxvf httpd-2.4.23.tar.gz
#cd /u/gmm_env_setup
#cp -p apr-1.5.2.tar.gz /u/gmm_env_setup/httpd-2.4.17/srclib
#cd /u/gmm_env_setup/httpd-2.4.17/srclib
#tar zxvf apr-1.5.2.tar.gz
#mv apr-1.5.2 apr

#cd /u/gmm_env_setup
#cp -p apr-util-1.5.4.tar.gz /u/gmm_env_setup/httpd-2.4.17/srclib
#cd /u/gmm_env_setup/httpd-2.4.17/srclib
#tar zxvf apr-util-1.5.4.tar.gz
#mv apr-util-1.5.4 apr-util

cd /u/gmm_env_setup/httpd-2.4.23

#echo "you can enable ssl in apache insert Y/y to confirm or N/n to disable this feature."
#read choice
#while [[ ! $choice =~ [YyNn] ]]
#do
#echo "wrong input retry"
#read choice
#done
#if [[ $choice =~ [Yy] ]]
#then
./configure --prefix=/usr/local/apache --enable-modules=most --enable-mods-shared=all --enable-so --enable-rewrite --with-mpm=prefork --with-included-apr --with-pcre=/usr/local/pcre
#./configure -prefix=/usr/local/apache -enable-module=most --enable-so -enable-rewrite -with-mpm=prefork -with-included-apr -with-pcre=/usr/local/pcre -enable-ssl
#elif [[ $choice =~ [Nn] ]]
#then
#./configure -prefix=/usr/local/apache -enable-module=most --enable-so -enable-rewrite -with-mpm=prefork -with-included-apr -with-pcre=/usr/local/pcre
#fi
make clean
make -j${CORE}
make install

cp -p /etc/passwd /etc/passwd_${DATE}
if [ "`cat /etc/passwd|sed -n '/apache/p'`" == "" ]
then
#	if [ -d /var/www ]
#	then
#		rm -fr /var/www
#	fi
	useradd -d /var/www/ apache
	sed -i 's/\(^apache.*::\).*/\1\/var\/www\/:\/sbin\/nologin/' /etc/passwd
	mkdir /var/www/html
	chown apache: /var/www/html/
else
	if [ ! -d /var/www ]
	then
		mkdir /var/www
		chown apache: /var/www
		mkdir /var/www/html
		chown apache: /var/www/html/
	elif [ ! -d /var/www/html ]
	then
		mkdir /var/www/html
		chown apache: /var/www/html/
	fi
	sed -i 's/\(^apache.*::\).*/\1\/var\/www\/:\/sbin\/nologin/' /etc/passwd	
fi

cd /usr/local/apache/conf
cp -p /usr/local/apache/conf/httpd.conf /usr/local/apache/conf/httpd_${DATE}.conf
sed -i 's/\(^DocumentRoot.*\)\/usr\/local\/apache\/htdocs\(.*\)/\1\/var\/www\/html\2/' httpd.conf
sed -i 's/\(^<Directory.*\)\/usr\/local\/apache\/htdocs\(.*\)/\1\/var\/www\/html\2/' httpd.conf
host=`cat /etc/sysconfig/network|sed -n 's/HOSTNAME=\(.*\)/\1/p'`
sed -i "s/^#ServerName.*/ServerName $host/g" httpd.conf
sed -i 's/\(^User \).*/\1apache/' httpd.conf
sed -i 's/\(^Group \).*/\1apache/' httpd.conf

/usr/local/apache/bin/apachectl -k start

echo "/usr/local/apache/bin/apachectl -k start" >> /etc/rc.local

echo "step 3: finished!"
sleep 5

echo "step 4: install XML2 Library"
sleep 5
cd /u/gmm_env_setup
tar zxvf libxml2-2.7.7.tar.gz
cd libxml2-2.7.7
./configure --prefix=/usr
make
make install
echo "step 4: finished!"
sleep 5

#VER=`uname -r|awk -F- '{print $1}'|awk -F. '{print $3}'`
#if [[ $VER == "18" ]]
#then

echo "step 5: install XLIZ RHEL5 only"
sleep 5
cd /u/gmm_env_setup/
tar zxvf zlib-1.2.5.tar.tar
cd  zlib-1.2.5
./configure --prefix=/usr
make
make install
cp -p /usr/lib/libz.so.1.2.5 /lib/libz.so.1.2.5
mv /lib/libz.so.1 /lib/libz.so.1.bak
ln -s /lib/libz.so.1.2.5 /lib/libz.so.1
echo "step 5: finished!"
sleep 5

#fi

##############################################################################
echo "install libjpeg"
#error 1

if [ ! -d /usr/man ]
then
mkdir /usr/man
mkdir /usr/man/man1
elif [ ! -d /usr/man/man1 ]
then
mkdir /usr/man/man1
fi

cd /u/gmm_env_setup/
tar zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
./configure --enable-static --enable-shared --prefix=/usr
make
make install


#error 2
cd /u/gmm_env_setup/
tar zxvf libpng-1.6.2.tar.gz
cd libpng-1.6.2
./configure --prefix=/usr
make check
make install


#find 3
cd /u/gmm_env_setup/
tar zxvf xproto-7.0.22.tar.gz
cd xproto-7.0.22
./configure --prefix=/usr
make
make install


#find 4
cd /u/gmm_env_setup/
tar zxvf xextproto-7.2.1.tar.gz
cd xextproto-7.2.1
./configure --prefix=/usr
make
make install


#find 5
cd /u/gmm_env_setup/
tar zxvf xtrans-1.2.7.tar.gz
cd xtrans-1.2.7
./configure --prefix=/usr
make
make install


#find 6
cd /u/gmm_env_setup/
tar zxvf libXau-1.0.7.tar.gz
cd libXau-1.0.7
./configure --prefix=/usr
make
make install


#find 7
cd /u/gmm_env_setup/
tar zxvf xcmiscproto-1.2.2.tar.gz
cd xcmiscproto-1.2.2
./configure --prefix=/usr
make
make install


#find 8
cd /u/gmm_env_setup/
tar zxvf bigreqsproto-1.1.2.tar.gz
cd bigreqsproto-1.1.2
./configure --prefix=/usr
make
make install


#find 9
cd /u/gmm_env_setup/
tar zxvf libXdmcp-1.1.1.tar.gz
cd libXdmcp-1.1.1
./configure --prefix=/usr
make
make install


#find 10
cd /u/gmm_env_setup/
tar zxvf kbproto-1.0.6.tar.gz
cd kbproto-1.0.6
./configure --prefix=/usr
make
make install


#find 11
cd /u/gmm_env_setup/
tar zxvf inputproto-2.2.tar.gz
cd inputproto-2.2
./configure --prefix=/usr
make
make install


#version 12
cd /u/gmm_env_setup/
tar zxvf Python-2.7.5.tgz
cd Python-2.7.5
./configure --prefix=/usr
make
make install


#version 13
cd /u/gmm_env_setup/
tar zxvf xcb-proto-1.7.tar.gz
cd xcb-proto-1.7
./configure --prefix=/usr
make
make install


#exist 14
cd /u/gmm_env_setup/
tar zxvf libpthread-stubs-0.3.tar.gz
cd libpthread-stubs-0.3
./configure --prefix=/usr
make
make install


#exist 15
cd /u/gmm_env_setup/
tar zxvf libxcb-1.8.1.tar.gz
cd libxcb-1.8.1
./configure --prefix=/usr
make
make install


#exist 16
cd /u/gmm_env_setup/
tar zxvf libX11-1.5.0.tar.gz
cd libX11-1.5.0
./configure --prefix=/usr
make
make install


#exist 17
cd /u/gmm_env_setup/
tar zxvf freetype-2.4.11.tar.gz
cd freetype-2.4.11
./configure --prefix=/usr
make
make install


#error 18
cd /u/gmm_env_setup/
tar zxvf libXpm-3.5.4.2.tar.gz
cd libXpm-3.5.4.2
./configure --prefix=/usr
make
make install


#font 19
cd /usr/share/fonts
cp -p /u/gmm_env_setup/xpfonts.zip /usr/share/fonts/
unzip /usr/share/fonts/xpfonts.zip

echo "libjpeg finished!"
sleep 3
##############################################################################

echo "step 6: install php"
sleep 5
cd /u/gmm_env_setup
tar zxvf php-5.6.28.tar.gz
cd php-5.6.28
#./configure -with-apxs2=/usr/local/apache/bin/apxs -enable-sockets -disable-debug -with-config-file-path=/usr/local/apache/conf -with-libxml-dir=/usr/lib -with-zlib-dir=/usr/lib
./configure --with-apxs2=/usr/local/apache/bin/apxs --enable-sockets --with-config-file-path=/usr/local/apache/conf --with-libxml-dir=/usr/lib --with-zlib-dir=/usr/lib --with-gd --with-xpm-dir=/usr/lib --with-freetype-dir=/usr/lib --enable-gd-native-ttf --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib
make clean
make -j${CORE}
make install

cp ./php.ini-production /usr/local/apache/conf/php.ini
sed -i 's/^;\(include_path.*"\.:\).*/\1\/usr\/local\/lib\/php"/' /usr/local/apache/conf/php.ini
sed -i 's/\(^default_charset =\).*/\1/g' /usr/local/apache/conf/php.ini
#sed -i '/;extension=php_xsl.dll/a extension=sockets.so' /usr/local/apache/conf/php.ini
awk '/\[pattern1\]/{while(getline)if($0!~/\[pattern1\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
sed -i '/^LoadModule php5_module.*/r temp' /usr/local/apache/conf/httpd.conf
rm temp

#cd /u/gmm_env_setup/php-5.6.28/ext/sockets/
#make clean
#/usr/local/bin/phpize
#./configure --prefix=/usr/local/bin --with-php-config=/usr/local/bin/php-config --enable-sockets
#make
#make install

echo "step 6: finished!"
sleep 5

service iptables stop

/usr/local/apache/bin/apachectl -k restart

cd /var/www/html
echo "<?php" > test.php
echo "phpinfo();" >> test.php
echo "?>" >> test.php
chmod 755 test.php

sleep 5
sync
/usr/local/apache/bin/apachectl -k restart
