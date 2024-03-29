# 	Kill all GOURMATE running processes 
echo "Kill all GOURMATE processes ..."

tmpfile=/u/tmp/_gm_kill_all

ps -ef | grep cggmate | grep -v grep | awk '{print $2 ""}' > $tmpfile
ps -ef | grep cggmctrl | grep -v grep | awk '{print $2 ""}' >> $tmpfile
ps -ef | grep cggmrep | grep -v grep | awk '{print $2 ""}' >> $tmpfile
ps -ef | grep gmate | grep -v grep | awk '{print $2 ""}' > $tmpfile
ps -ef | grep gmctrl | grep -v grep | awk '{print $2 ""}' >> $tmpfile
ps -ef | grep gmrep | grep -v grep | awk '{print $2 ""}' >> $tmpfile
ps -ef | grep gmpda | grep -v grep | awk '{print $2 ""}' >> $tmpfile
ps -ef | grep gmMobile | grep -v grep | awk '{print $2 ""}' >> $tmpfile
#ps -ef | grep gm_select | grep -v grep | awk '{print $2 ""}' >> $tmpfile
if test -s $tmpfile
then 
	kill `cat $tmpfile`
	sleep 2
	sync
	ps -ef | grep cggmate | grep -v grep | awk '{print $2 ""}' > $tmpfile
	ps -ef | grep cggmctrl | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	ps -ef | grep cggmrep | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	ps -ef | grep gmate | grep -v grep | awk '{print $2 ""}' > $tmpfile
	ps -ef | grep gmctrl | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	ps -ef | grep gmrep | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	ps -ef | grep gmpda | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	ps -ef | grep gmMobile | grep -v grep | awk '{print $2 ""}' >> $tmpfile
#	ps -ef | grep gm_select | grep -v grep | awk '{print $2 ""}' >> $tmpfile
	if test -s $tmpfile
	then 
		kill -9 `cat $tmpfile`
		sleep 2
		sync
	fi
fi
rm -f $tmpfile

echo "terminated all specified process"
sleep 2
ps -ef | grep gmate | grep -v grep
ps -ef | grep gmctrl | grep -v grep
ps -ef | grep gmrep | grep -v grep
ps -ef | grep gmMobile | grep -v grep
echo "if there is any process display on screen, kill it manually"
sleep 2 

#ps -ef | grep gm_select | grep -v grep | awk '{print $2 ""}' > $tmpfile
#ps -ef | grep gm_select | grep -v grep | awk '{print $3 ""}' > $tmpfile
#if test -s $tmpfile
#then 
#	kill -9 `cat $tmpfile`
#	sleep 2
#	sync
#fi
#rm -f $tmpfile

