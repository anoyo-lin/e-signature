#!/bin/bash
ACCOUNT=$1
if [ "${ACCOUNT}" == "" ]
then
echo "please follow the account id in commandline"
echo "example: ./install_gmm.s z01"
exit
fi

if [ ! -f /u/${ACCOUNT}/esign_installed ]
then
echo "already installed esign in ${DATE}" > /u/${ACCOUNT}/esign_installed

START=1
WS=18
JAVA=`echo $PATH|sed -n 's/.*java\/\([^\/]*\)\/bin.*/\1/p'`
if [ "${JAVA}" == "" ]
then 
JAVA=jre1.7.0_72
fi
LOCAL=`pwd`
DATE=`date +%Y%m%d`

if [ ! -d /u/tmp/paidImage ]
then
	mkdir /u/tmp/paidImage/
	chmod 777 /u/tmp/paidImage/
fi

echo "killing specified processes"
tmpfile=/u/tmp/_kill_proc
ps -ef | grep GCOnlineInterface | grep -v grep | awk '{print $2 ""}' > $tmpfile
ps -ef | grep gmMobile | grep -v grep | awk '{print $2 ""}' >> $tmpfile
if test -s $tmpfile
then 
	kill `cat $tmpfile`
	sleep 2
	sync
	ps -ef | grep GCOnlineInterface | grep -v grep | awk '{print $2 ""}' > $tmpfile
	ps -ef | grep gmMobile | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	if test -s $tmpfile
	then 
		kill -9 `cat $tmpfile`
		sleep 2
		sync
	fi
fi
rm -f $tmpfile

if [ ! -f /usr/gm_esign_${DATE}.zip ]
then
	zip -r /usr/gm_esign_${DATE}.zip /usr/gm/
fi
zip -r /u/${ACCOUNT}/sales_esign_${DATE}.zip /u/${ACCOUNT}/sales/
zip -r /u/${ACCOUNT}/data_esign_${DATE}.zip /u/${ACCOUNT}/data/

if [ -f ${LOCAL}/esign/GCOnlineInterface.jar ]
then
cp -p ${LOCAL}/esign/GCOnlineInterface.jar /usr/gm/bin/
chmod 755 /usr/gm/bin/GCOnlineInterface.jar
fi
if [ "`sed -n '/^connection_timeout/p' /usr/gm/global/GCOnlineInterface.inf`" == "" ]
then
sed -i '/^protocol.*/a connection_timeout=60000' /usr/gm/global/GCOnlineInterface.inf
fi
cd /root/
nohup /usr/java/${JAVA}/bin/java -jar /usr/gm/bin/GCOnlineInterface.jar &
cd ${LOCAL}

sed -n '/^[^#].*/p' /u/${ACCOUNT}/data/gm_over.inf > tmp
sed 's/[[:space:]]//g' tmp > temp && mv temp tmp
sed -i 's/^[^#].*gmate.inf.*/#&/g' tmp
for x in `sed -n '/\[gmate\]/,/\[ckperiod\]/s/^[^#].*inf/&/p' tmp|awk -F = '{print $2}'|sort -u` gmate.inf back_summary.inf back_detail.inf
do
	if [ ! -f /u/${ACCOUNT}/data/$x.esign ];then
		cp -p /u/${ACCOUNT}/data/$x /u/${ACCOUNT}/data/$x.esign
		for i in `awk '/\[pattern8\]/{while(getline)if($0!~/\[pattern8\]/)print;else exit}' ${LOCAL}/conf/setup.inf|awk -F= '{print $1}'|sed 's/^#//g'`
		do
			sed -i "/${i}/d" /u/${ACCOUNT}/data/$x
		done
		awk '/\[pattern8\]/{while(getline)if($0!~/\[pattern8\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
		sed -i '/\[gmate\]/r temp' /u/${ACCOUNT}/data/$x
		sed -i 's/^java_path.*/#&/g' /u/${ACCOUNT}/data/$x
		sed -i "/^support_e_signature.*/a java_path=/usr/java/${JAVA}/bin/" /u/${ACCOUNT}/data/$x

		if  [ "`sed -n '/^def_cash_paytype/p' /u/${ACCOUNT}/data/${x}`" == "" ]
		then
			sed -i '/^\[member\]/a def_cash_paytype=0' /u/${ACCOUNT}/data/$x
		else
			sed -i 's/\(^def_cash_paytype\).*/\1=0/g' /u/${ACCOUNT}/data/$x
		fi
	fi
done
rm temp
rm tmp
for ((i=${START};i<=${WS};i++))
do
	if [ $i -lt 10 ];then
		cp /u/${ACCOUNT}/data/gmate.inf /u/${ACCOUNT}/data/gmate_ipod0$i.inf
		sed -i "s/GMMobile/GMMobile0$i/g" /u/${ACCOUNT}/data/gmate_ipod0$i.inf
		sed -i "/\[ckperiod\]/i h0$i=gmate_ipod0$i.inf" /u/${ACCOUNT}/data/gm_over.inf
	else
		cp /u/${ACCOUNT}/data/gmate.inf /u/${ACCOUNT}/data/gmate_ipod$i.inf
		sed -i "s/GMMobile/GMMobile$i/g" /u/${ACCOUNT}/data/gmate_ipod$i.inf
		sed -i "/\[ckperiod\]/i h$i=gmate_ipod$i.inf" /u/${ACCOUNT}/data/gm_over.inf
	fi	
done

#cd /var/www/html/
#lsdir|awk '{printf ("%s\n",$9)}'|cut -c 9 > _tmp_list
#for x in `cat _tmp_list`
#do
#unzip -o -d /var/www/html/GMMobile${x} ${LOCAL}/html/webServer*.zip
#cd /var/www/html/GMMobile${x}
#mkdir checkImg
#chmod 777 checkImg
#mkdir uploads
#chmod 777 uploads
#done
#rm -f /var/www/html/_tmp_list
#if [ -d /var/www/html/GMMobile ]
#then
#unzip -o -d /var/www/html/GMMobile ${LOCAL}/html/webServer*.zip
#mkdir /var/www/html/GMMobile/checkImg
#chmod 777 /var/www/html/GMMobile/checkImg
#mkdir /var/www/html/GMMobile/uploads
#chmod 777 /var/www/html/GMMobile/uploads
#fi

#if [ "`sed -n 's/^[^0-9]*\([0-9]\).*/\1/p' /etc/redhat-release`" == "3" ]
#then
#unzip -o -d ${LOCAL}/etc/ ${LOCAL}/etc/gmMobile*3.zip
#else
#unzip -o -d ${LOCAL}/etc/ ${LOCAL}/etc/gmMobile*5.zip
#fi
#mv ${LOCAL}/etc/gmMobilesetup /usr/gm/bin/
#chmod 755 /usr/gm/bin/gmMobilesetup
#unzip -o -d /usr/gm/etc/ ${LOCAL}/etc/gmMobile_scripts.zip
#chmod 755 /usr/gm/etc/gmMobile*.s
#rm ${LOCAL}/etc/gmMobile_scripts.zip

#if [ "`sed -n 's/^[^0-9]*\([0-9]\).*/\1/p' /etc/redhat-release`" == "6" ]
#then 
#unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*6.zip
#elif [ "`sed -n 's/^[^0-9]*\([0-9]\).*/\1/p' /etc/redhat-release`" == "5" ]
#then
#unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*5.zip
#else
#unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*3.zip
#fi
#chmod 777 /usr/gm/bin/gmMobile.*
if [ ! -f /u/${ACCOUNT}/data/ckfmt.inf.esign ]
then
cp -p /u/${ACCOUNT}/data/ckfmt.inf /u/${ACCOUNT}/data/ckfmt.inf.esign
LANG=zh_cn.gbk sed -i 's/\(^[^#].*member2\)\(\$\)\(.*\)/\1,8,1,8\2****\3/g' /u/${ACCOUNT}/data/ckfmt.inf
awk '/\[pattern7\]/{while(getline)if($0!~/\[pattern7\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
LANG=zh_cn.gbk sed -i '/\[setup1\]/r temp' /u/${ACCOUNT}/data/ckfmt.inf
rm temp
awk '/\[pattern9\]/{while(getline)if($0!~/\[pattern9\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
LANG=zh_cn.gbk sed -i $'/;-F;05/{e cat temp\n}' /u/${ACCOUNT}/data/ckfmt.inf
rm temp
fi
chmod 755 ${LOCAL}/bin/batch_tool
chmod 755 ${LOCAL}/bin/reindex
chmod 755 ${LOCAL}/gm_script/*.s
${LOCAL}/gm_script/kill_all.s
${LOCAL}/gm_script/disable_prog.s

cd /u/${ACCOUNT}/sales
${LOCAL}/bin/batch_tool ckheader.dbf /MODIFY:${LOCAL}/bin/esign.txt
cp -p ${LOCAL}/esign/esign_img.dbf /u/${ACCOUNT}/sales/
cp -p ${LOCAL}/esign/gc_pref.dbf /u/${ACCOUNT}/data/
#this command will separate displayed table to a matrix and only grasp the month info and remove duplicate month directory such like 201508back
#use batch_tool to execute history sales data,will cost a lot of time,3.3GB sales will costs six minutes at least,so cordinate your update procedure according ot
#the sales size.
#you dont want to concern about if there is one or two database is already support 4 digits ,the programme will pass the 4 digits database automatically
MONTH_LIST=`lsdir | awk '{printf("%s\n",substr($9,1,6))}' | sort -u`
for MONTH in ${MONTH_LIST}
do
cd /u/${ACCOUNT}/sales/${MONTH}
if [ ! -f /u/"${ACCOUNT}"/sales/"${MONTH}"/esign_img.dbf ]
then
cp -p ${LOCAL}/esign/esign_img.dbf /u/${ACCOUNT}/sales/${MONTH}/
fi
${LOCAL}/bin/batch_tool ckheader.dbf /MODIFY:${LOCAL}/bin/esign.txt
done
#execute daily
cd /u/${ACCOUNT}/daily
if [ -f /u/"${ACCOUNT}"/daily/ck_hd00.dbf ]
then
	zip -r /u/${ACCOUNT}/daily_esign_${DATE}.zip /u/${ACCOUNT}/daily/
	cp -p ${LOCAL}/esign/esign_img.* /u/${ACCOUNT}/daily/
	${LOCAL}/bin/batch_tool ck_hd00.dbf /MODIFY:${LOCAL}/bin/esign.txt
fi

cd /u/${ACCOUNT}
${LOCAL}/bin/reindex -s /usr/gm/global/reindex.inf -e
chmod -R 777 /u/${ACCOUNT}
chown -R ${ACCOUNT}:${ACCOUNT} /u/${ACCOUNT}
cd ${LOCAL}
${LOCAL}/gm_script/activate_prog.s

cp -p ${LOCAL}/esign/esign_purge.s /usr/gm/etc/
chmod 755 /usr/gm/etc/esign_purge.s
if [ "`sed -n '/esign_purge/p' /var/spool/cron/root`" == "" ]
then
	echo "0 3 * * 2 /usr/gm/etc/esign_purge.s > /dev/null 2>&1" >> /var/spool/cron/root
fi

if [ -f ${LOCAL}/esign/ESignature.jar ]
then
cp -p ${LOCAL}/esign/ESignature.jar /usr/gm/bin/
chmod 755 /usr/gm/bin/ESignature.jar
fi

sed -i "s/^START.*/START=$((${WS}+1))/g" ${LOCAL}/etc/extMenuExport_multi.s

else
cat /u/${ACCOUNT}/esign_installed
fi
