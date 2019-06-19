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
VER=`uname -r|awk -F- '{print $1}'|awk -F. '{print $3}'`

if [ ! -f /u/${ACCOUNT}/gmm_installed ]
then
echo "already installed gmm in ${DATE}" > /u/${ACCOUNT}/gmm_installed

#batch_tool will undeleted amount of record that you inserted
echo "please insert station amount can not greater than 99"
read OLD_WS
while [[ "`echo $OLD_WS|sed -n '/^[1-9][0-9]*$/p'`" == "" || $OLD_WS -gt 99 ]]
do 
	echo "wrong input please retry"
	read OLD_WS
done

START=1
WS=$(($OLD_WS+$START-1))
sed -i "s/^WS.*/WS=${WS}/g" ${LOCAL}/etc/extMenuExport_multi.s
sed -i "s/^WS.*/WS=${WS}/g" ${LOCAL}/esign_setup.s
sed -i "s/^WS.*/WS=${WS}/g" ${LOCAL}/esign/esign_purge.s

zip -r /u/${ACCOUNT}/data_gmm_${DATE}.zip /u/${ACCOUNT}/data
zip -r /u/${ACCOUNT}/tty_gmm_${DATE}.zip /u/${ACCOUNT}/tty
if [ ! -f /usr/gm/global/reindex.inf.gmm ]
then
	zip -r /usr/gm/global_gmm_${DATE}.zip /usr/gm/global
	zip -r /var/www/html_gmm_${DATE}.zip /var/www/html
fi
#chmod 755 ${LOCAL}/bin/dos2unix
#dos format inf file to unix format
#${LOCAL}/bin/dos2unix -k -q -o /u/${ACCOUNT}/data/*.inf
#${LOCAL}/bin/dos2unix -k -q -o /u/${ACCOUNT}/tty/*.inf
#${LOCAL}/bin/dos2unix -k -q -o /usr/gm/global/reindex.inf

chmod 755 ${LOCAL}/bin/batch_tool
chmod 755 ${LOCAL}/bin/reindex

chmod 755 ${LOCAL}/gm_script/*.s
${LOCAL}/gm_script/kill_all.s
${LOCAL}/gm_script/disable_prog.s

if [ ! -d /var/www/html/GMMobile ]
then
	mkdir /var/www/html/GMMobile
else
	rm -fr /var/www/html/GMMobile/*
fi
chmod 777 /var/www/html/GMMobile
unzip -o -d /var/www/html/GMMobile ${LOCAL}/html/webServer*.zip
mkdir /var/www/html/GMMobile/log
chmod 777 /var/www/html/GMMobile/log
mkdir /var/www/html/GMMobile/data
chmod 755 /var/www/html/GMMobile/data
mkdir /var/www/html/GMMobile/checkImg
chmod 777 /var/www/html/GMMobile/checkImg
mkdir /var/www/html/GMMobile/uploads
chmod 777 /var/www/html/GMMobile/uploads
echo "POS_address=`sed -n 's/\"//g;s/^IPADDR=\(.*\)/\1/p' /etc/sysconfig/network-scripts/ifcfg-eth0`" > /var/www/html/GMMobile/data/config.inf
chmod 755 /var/www/html/GMMobile/data/config.inf 
awk '/\[pattern2\]/{while(getline)if($0!~/\[pattern2\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
#sed -i 'r temp' /var/www/html/GMMobile$i/data/deviceKey.txt
cat temp > /var/www/html/GMMobile/data/deviceKey.txt
rm temp

for (( i = ${START}; i <= ${WS}; i++ ))
do
	if [ $i -lt 10 ]
	then
		if [ ! -d /var/www/html/GMMobile0$i ]
		then
			mkdir /var/www/html/GMMobile0$i
		else
			rm -fr /var/www/html/GMMobile0$i/*
		fi
		chmod 777 /var/www/html/GMMobile0$i
		unzip -o -d /var/www/html/GMMobile0$i ${LOCAL}/html/webServer*.zip
		mkdir /var/www/html/GMMobile0$i/log
		chmod 777 /var/www/html/GMMobile0$i/log
		mkdir /var/www/html/GMMobile0$i/data
		chmod 755 /var/www/html/GMMobile0$i/data
		mkdir /var/www/html/GMMobile0$i/checkImg
		chmod 777 /var/www/html/GMMobile0$i/checkImg
		mkdir /var/www/html/GMMobile0$i/uploads
		chmod 777 /var/www/html/GMMobile0$i/uploads
		echo "POS_address=`sed -n 's/\"//g;s/^IPADDR=\(.*\)/\1/p' /etc/sysconfig/network-scripts/ifcfg-eth0`" > /var/www/html/GMMobile0$i/data/config.inf
		chmod 755 /var/www/html/GMMobile0$i/data/config.inf
		awk '/\[pattern2\]/{while(getline)if($0!~/\[pattern2\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
		#sed -i 'r temp' /var/www/html/GMMobile0$i/data/deviceKey.txt
		cat temp > /var/www/html/GMMobile0$i/data/deviceKey.txt
	else
		if [ ! -d /var/www/html/GMMobile$i ]
		then
			mkdir /var/www/html/GMMobile$i
		else
			rm -fr /var/www/html/GMMobile$i/*
		fi
		chmod 777 /var/www/html/GMMobile$i
		unzip -o -d /var/www/html/GMMobile$i ${LOCAL}/html/webServer*.zip
		mkdir /var/www/html/GMMobile$i/log
		chmod 777 /var/www/html/GMMobile$i/log
		mkdir /var/www/html/GMMobile$i/data
		chmod 755 /var/www/html/GMMobile$i/data
		mkdir /var/www/html/GMMobile$i/checkImg
		chmod 777 /var/www/html/GMMobile$i/checkImg
		mkdir /var/www/html/GMMobile$i/uploads
		chmod 777 /var/www/html/GMMobile$i/uploads
		echo "POS_address=`sed -n 's/\"//g;s/^IPADDR=\(.*\)/\1/p' /etc/sysconfig/network-scripts/ifcfg-eth0`" > /var/www/html/GMMobile$i/data/config.inf
		chmod 755 /var/www/html/GMMobile$i/data/config.inf
		awk '/\[pattern2\]/{while(getline)if($0!~/\[pattern2\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
		#sed -i 'r temp' /var/www/html/GMMobile$i/data/deviceKey.txt
		cat temp > /var/www/html/GMMobile$i/data/deviceKey.txt
	fi
done
rm temp

if [[ $VER == "21" ]]
then
	unzip -o -d ${LOCAL}/etc/ ${LOCAL}/etc/gmMobile*3*.zip
else
	unzip -o -d ${LOCAL}/etc/ ${LOCAL}/etc/gmMobile*5*.zip
fi

mv ${LOCAL}/etc/gmMobilesetup /usr/gm/bin/
chmod 755 /usr/gm/bin/gmMobilesetup
unzip -o -d /usr/gm/etc/ ${LOCAL}/etc/gmMobile_scripts.zip
chmod 755 /usr/gm/etc/gmMobile*.s
rm ${LOCAL}/etc/gmMobile_scripts.zip


if [[ $VER == "32" ]]
then 
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*6*.zip
elif [[ $VER == "18" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*5*.zip
else
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gmMobile*3*.zip
fi
chmod 777 /usr/gm/bin/gmMobile*

DEBIT=`sed -n '/^cardstat_dir.*/p' /u/$ACCOUNT/data/gmate.inf`
STAT=`sed -n 's/^\[1.*stattype="\([0-9]*\)"/\1/p' /u/$ACCOUNT/gm_user.s`
PROC=`sed -n "/\[1.*/,/\[.*/s/${STAT})\(.*\);;.*/\1/p" /u/$ACCOUNT/gm_user.s|sed -n 's/[[:space:]]//gp'`
echo $PROC
if [[ $DEBIT != "" ]]
then
if [[ $VER == "32" && $PROC == "gmctrl115tb" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL6*debit.zip
	csconv.s ctos /usr/gm/bin/gm*115tb.txt
elif [[ $VER == "32" && $PROC == "gmctrl115tb_debit" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL6*debit.zip
	for x in /usr/gm/bin/gm*115tb
	do
		cp -f $x ${x}_debit
		cp -f $x.txt ${x}_debit.txt
	done
	csconv.s ctos /usr/gm/bin/gm*115tb_debit.txt
elif [[ $VER == "18" && $PROC == "gmctrl115tb" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL5*debit.zip
	csconv.s ctos /usr/gm/bin/gm*115tb.txt
else
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL5*debit.zip
	for x in /usr/gm/bin/gm*115tb
	do
		cp -f $x $x_debit
		cp -f $x.txt $x_debit.txt
	done
	csconv.s ctos /usr/gm/bin/gm*115tb_debit.txt
fi
else
if [[ $VER == "32" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL6*20170111.zip
	csconv.s ctos /usr/gm/bin/gm*115tb.txt
elif [[ $VER == "18" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/gm115*RHEL5*20170126.zip
	csconv.s ctos /usr/gm/bin/gm*115tb.txt
fi
fi

	

#if [[ $VER == "21" ]]
#then
#	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/extMenu.*3*.zip
#else
#	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/extMenu.*5*.zip
#fi
#chmod 755 /usr/gm/bin/extMenuExport

sed -n '/^[^#].*/p' /u/${ACCOUNT}/data/gm_over.inf > tmp
sed -i 's/[[:space:]]//g' tmp
for x in `sed -n '/\[gmate\]/,/\[ckperiod\]/{/^[^#].*inf/p}' tmp|awk -F = '{print $2}'` back_summary.inf back_detail.inf gmate.inf
do
	if [ ! -f /u/${ACCOUNT}/data/$x.gmm ]
	then
		cp -p /u/${ACCOUNT}/data/$x /u/${ACCOUNT}/data/$x.gmm
#		sed -i '/\[gmate\]/,/\[pda\]/{s/passwd_encryption.*/#&/}' /u/${ACCOUNT}/data/$x
#		sed -i '/\[gmate\]/a passwd_encryption=2' /u/${ACCOUNT}/data/$x 
		sed -i '/\[pda\]/,/\[open table\]/{s/^num_lang.*/#&/}' /u/${ACCOUNT}/data/$x
		sed -i '/\[pda\]/,/\[open table\]/{s/^mesg_file.*/#&/}' /u/${ACCOUNT}/data/$x
		for i in `awk '/\[pattern3\]/{while(getline)if($0!~/\[pattern3\]/)print;else exit}' ${LOCAL}/conf/setup.inf|awk -F= '{print $1}'|sed 's/^#//g'`
		do
			sed -i "/${i}/d" /u/${ACCOUNT}/data/$x
		done
		awk '/\[pattern3\]/{while(getline)if($0!~/\[pattern3\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
		sed -i '/\[pda\]/r temp' /u/${ACCOUNT}/data/$x
	fi
done
rm temp
rm tmp

if [ ! -f /u/${ACCOUNT}/data/employee.dbf.gmm ]
then
	cp -p /u/${ACCOUNT}/data/employee.dbf /u/${ACCOUNT}/data/employee.dbf.gmm
	cd /u/${ACCOUNT}/data
	${LOCAL}/bin/batch_tool employee.dbf /MODIFY:${LOCAL}/bin/femployee.txt
	cd ${LOCAL}
fi

if [ ! -d /usr/tmp/config ]
then
	mkdir /usr/tmp/config
fi
chmod 755 /usr/tmp/config

if [ ! -f /usr/gm/global/proc.dbf ]
then
	cd /usr/gm/global/
	${LOCAL}/bin/batch_tool process.dbf /pack:dbf
fi

#customer.inf process.dbf
cp -p ${LOCAL}/conf/proc.dbf /usr/gm/global/proc.dbf
cd /usr/gm/global/
${LOCAL}/bin/batch_tool proc.dbf /recall:$START-$WS
${LOCAL}/bin/batch_tool proc.dbf /pack:dbf
${LOCAL}/bin/batch_tool proc.dbf "/l:FUSER=${ACCOUNT}" /update
${LOCAL}/bin/batch_tool proc.dbf /delete:all
${LOCAL}/bin/batch_tool process.dbf +proc.dbf


#if there is a new customer.inf,batch_tool will append proc.dbf to process.dbf,and execute paytbld.s script at last,if not you will do this procedure manually
if [[ -f ${LOCAL}/conf/customer.inf && ! -f /usr/gm/global/customer.inf.gmm && ! -f /usr/gm/global/process.dbf.gmm ]]
then
	cp -p /usr/gm/global/customer.inf /usr/gm/global/customer.inf.gmm
	cp -p ${LOCAL}/conf/customer.inf /usr/gm/global/customer.inf
	cp -p /usr/gm/global/process.dbf /usr/gm/global/process.dbf.gmm
	${LOCAL}/bin/batch_tool process.dbf /recall:all
else
	echo "lack of new customer.inf,you need update license and process.dbf manually"
fi
#tty.inf
if [ ! -f /u/${ACCOUNT}/tty/tty.inf.gmm ]
then
	cp -p /u/${ACCOUNT}/tty/tty.inf /u/${ACCOUNT}/tty/tty.inf.gmm
	awk '/\[pattern4\]/{while(getline)if($0!~/\[pattern4\]/)print;else exit}' ${LOCAL}/conf/setup.inf|awk "{if(NR <= ${WS} && NR >= ${START}){print}}" > temp
	sed -i '/\[main\]/r temp' /u/${ACCOUNT}/tty/tty.inf
	rm temp
	OTHER=`sed -n '/^other/p' /u/${ACCOUNT}/tty/tty.inf|tail -1|awk -F= '{print $1}'|sed -n 's/other\(.*\)/\1/p'`
	sed -i "/^other${OTHER}.*/a other$(($OTHER+1))=99,1,0,0,0,1,0" /u/${ACCOUNT}/tty/tty.inf
	sed -i "s/other_esign/other$(($OTHER+1))/g" /u/${ACCOUNT}/tty/tty.inf
fi
#tty.dbf
cd /u/${ACCOUNT}/tty/
for ((i=${START};i<=${WS};i++))
do
	if [ $i -lt 10 ];then
		cp /u/${ACCOUNT}/tty/tty.dbf /u/${ACCOUNT}/tty/ttyh0$i.dbf
		st=`sed -n "/h0$i/p" /u/${ACCOUNT}/tty/tty.inf|awk -F= '{print $2}'|awk -F, '{print $3}'`
		${LOCAL}/bin/batch_tool ttyh0$i.dbf "/l:FCK_CUR=$(($st+1))" /update
	else
		cp /u/${ACCOUNT}/tty/tty.dbf /u/${ACCOUNT}/tty/ttyh$i.dbf
		st=`sed -n "/h$i/p" /u/${ACCOUNT}/tty/tty.inf|awk -F= '{print $2}'|awk -F, '{print $3}'`
		${LOCAL}/bin/batch_tool ttyh$i.dbf "/l:FCK_CUR=$(($st+1))" /update
	fi
done
cd ${LOCAL}
chmod -R 777 /u/${ACCOUNT}/
chown -R ${ACCOUNT}:${ACCOUNT} /u/${ACCOUNT}/
cd ${LOCAL}

if [[ $VER == "21" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/extMenu*3.zip
elif [[ $VER == "18" ]]
then
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/extMenu*5.zip
else
	unzip -o -d /usr/gm/bin/ ${LOCAL}/gm_bin/extMenu*6.zip
fi
chmod 755 /usr/gm/bin/extMenuExport

rm -f /u/${ACCOUNT}/data/extMenuExport.inf
rm -f /u/${ACCOUNT}/data/extMenuExport_*.inf
cp -p ${LOCAL}/conf/extMenuExport.inf /u/${ACCOUNT}/data/extMenuExport.inf
for (( j = ${START}; j <= ${WS}; j++ ))
do
	if [ $j -lt 10 ]
	then
		cp -p /u/${ACCOUNT}/data/extMenuExport.inf /u/${ACCOUNT}/data/extMenuExport_0$j.inf
		sed -i "s/GMMobile01/GMMobile0$j/" /u/${ACCOUNT}/data/extMenuExport_0$j.inf
		sed -i "s/h01/h0$j/" /u/${ACCOUNT}/data/extMenuExport_0$j.inf
	else
		cp -p /u/${ACCOUNT}/data/extMenuExport.inf /u/${ACCOUNT}/data/extMenuExport_$j.inf
		sed -i "s/GMMobile01/GMMobile$j/" /u/${ACCOUNT}/data/extMenuExport_$j.inf
		sed -i "s/h01/h$j/" /u/${ACCOUNT}/data/extMenuExport_$j.inf
	fi
done

cp -p ${LOCAL}/data/tblflr.dbf /u/${ACCOUNT}/data/tblflr.dbf
cp -p ${LOCAL}/data/tblflr.cdx /u/${ACCOUNT}/data/tblflr.cdx
#cp -p ${LOCAL}/tty/ttyx*.dbf /u/${ACCOUNT}/tty/
if [ ! -f /u/${ACCOUNT}/data/tbl_stat.dbf.gmm ]
then
	cp -p /u/${ACCOUNT}/data/tbl_stat.dbf /u/${ACCOUNT}/data/tbl_stat.dbf.gmm
	cd /u/${ACCOUNT}/data
	${LOCAL}/bin/batch_tool tbl_stat.dbf /MODIFY:${LOCAL}/bin/ftbl_stat.txt
	cd ${LOCAL}
fi

#echo "do you want multiple panel setting for each outlet Yy or Nn?"
#read choice
#while [[ ! $choice =~ [YyNn] ]]
#do
#	echo "wrong input retry"
#	read choice
#done
#if [[ $choice =~ [Yy] ]]
#elif [[ $choice =~ [Nn] ]]

if [ $WS -gt 1 ]
then
	cp -p ${LOCAL}/etc/extMenuExport_multi.s /usr/gm/etc/extMenuExport_${ACCOUNT}.s
else
	cp -p ${LOCAL}/etc/extMenuExport_single.s /usr/gm/etc/extMenuExport_${ACCOUNT}.s
fi
chmod 777 /usr/gm/etc/extMenuExport_${ACCOUNT}.s

if [ ! -f /var/spool/cron/root.gmm ]
then
	cp -p /var/spool/cron/root /var/spool/cron/root.gmm
fi

CRON=`sed -n 's/.*extMenuExport_\(z[0-9][0-9]\)\.s.*/\1/p' /var/spool/cron/root`
if [[ ${CRON} == "" || ${CRON} != ${ACCOUNT} ]]
then
	echo "0 4 * * * /usr/gm/etc/extMenuExport_${ACCOUNT}.s ${ACCOUNT} > /dev/null 2>&1" >> /var/spool/cron/root
fi

if [ ! -f /u/${ACCOUNT}/data/ckfmt.inf.gmm ]
then
cp -p /u/${ACCOUNT}/data/ckfmt.inf /u/${ACCOUNT}/data/ckfmt.inf.gmm
awk '/\[pattern10\]/{while(getline)if($0!~/\[pattern10\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
sed -i $'/\[setup1\]/{e cat temp\n}' /u/${ACCOUNT}/data/ckfmt.inf
awk '/\[pattern11\]/{while(getline)if($0!~/\[pattern11\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
sed -i '$e cat temp' /u/${ACCOUNT}/data/ckfmt.inf
rm temp
fi


##########################################################################
##if tty id start with 9 will add extMenuExport and gmMobilesetup button##
##########################################################################
STAT=`sed -n 's/^9.*stattype="\([0-9]\)".*/\1/p' /u/${ACCOUNT}/gm_user.s|awk '{if ( NR == 1 ){print $1}}'`
INF=`sed -n "s/.*${STAT}.*gm_select.*\/\(.*\);;.*/\1/p" /u/${ACCOUNT}/gm_user.s`

if [ ! -f /u/${ACCOUNT}/gm_user.s.gmm ]
then
	cp -p /u/${ACCOUNT}/gm_user.s /u/${ACCOUNT}/gm_user.s.gmm
	sed -i "/\[8\][)]/,/esac/{s/\(.*${STAT}[)] \).*\(;;.*\)/\1\/usr\/gm\/etc\/extMenuExport_${ACCOUNT}\.s ${ACCOUNT}\2/}" /u/${ACCOUNT}/gm_user.s
	sed -i "/\[9\][)]/,/esac/{s/\(.*${STAT}[)] \).*\(;;.*\)/\1\/usr\/gm\/bin\/gmMobilesetup\2/}" /u/${ACCOUNT}/gm_user.s
fi

array=($(LANG=en sed -n 's/^selection\([0-9]\).*/\1/p' /u/${ACCOUNT}/${INF}))
length=${#array[@]}
id=0
for ((i=0; i<$length; i++))
do
	if [ $id -lt ${array[$i]} ]
	then
		let "id=${array[$i]}"
	fi
done

if [ ! -f /u/${ACCOUNT}/${INF}.gmm ]
then
	cp -p /u/${ACCOUNT}/${INF} /u/${ACCOUNT}/${INF}.gmm
	sed -i "/^selection${id}.*/i selection${id} = 8,8,8\. Export Menu for iPod" /u/${ACCOUNT}/${INF}
	let "id+=1"
	sed -i "/.*8,8,8\..*/a selection${id} = 9,9,9\. Restart iPod Service" /u/${ACCOUNT}/${INF}
	let "id+=1"
	sed -i "s/.*\( = 0,0,0\..*\)/selection${id}\1/" /u/${ACCOUNT}/${INF}
fi

#this will add tbl_stat reindex info to /usr/gm/global/reindex.inf,and execute reindex to reindex the updated account
if [ ! -f /usr/gm/global/reindex.inf.gmm ]
then
	cp -p /usr/gm/global/reindex.inf /usr/gm/global/reindex.inf.gmm
	awk '/\[pattern5\]/{while(getline)if($0!~/\[pattern5\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
	n=`grep -n "name_list" /usr/gm/global/reindex.inf|awk -F: '{if(NR==1){print $1}}'`
	sed -i ''$n' r temp' /usr/gm/global/reindex.inf
	awk '/\[pattern6\]/{while(getline)if($0!~/\[pattern6\]/)print;else exit}' ${LOCAL}/conf/setup.inf > temp
	sed -i '$e cat temp' /usr/gm/global/reindex.inf
	rm temp
fi

cd /u/${ACCOUNT}
${LOCAL}/bin/reindex -s /usr/gm/global/reindex.inf -e
chmod -R 777 /u/${ACCOUNT}
chown -R ${ACCOUNT}:${ACCOUNT} /u/${ACCOUNT}
chmod -R 777 /usr/gm
chown -R bin:bin /usr/gm
cd ${LOCAL}
${LOCAL}/gm_script/activate_prog.s
chmod -R 777 /var/www

NEW_START=$(($START+$OLD_WS))
sed -i "s/^START.*/START=${NEW_START}/g" ${LOCAL}/install_gmm.s
sed -i "s/^START.*/START=${START}/g" ${LOCAL}/esign_setup.s
echo "please execute **************./esign_setup.s ${ACCOUNT}************ later"
else
cat /u/${ACCOUNT}/gmm_installed
fi
