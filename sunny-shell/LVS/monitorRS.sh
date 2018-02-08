#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-23
#FileName:             monitorRS.sh
#version:              1.0
#Your change info:     
#Description:          For auto monitor RS status
#DOC URL:                  http://ghbsunny.blog.51cto.com/7759574/1975832
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
echo "This is a script to auto monitor RS status,if you want to run the scirpt ,suggest you to excute cmd below"
echo
echo " nohup /PATH/TO/script/monitorRS.sh > /root/RSout.file 2>&1 & "
echo
echo "If you want to stop the script,you should run two cmds below,first you find the PID,then kill it"
echo
echo "ps -ef | grep monitorRS.sh"
echo  "kill -9 PID"

VIP=10.10.10.10
VPORT=80
RS=("192.168.32.63" "192.168.32.73")
RW=("3" "1")
RPORT=80
TYPE=g
LOG=/var/log/monitorRS.log
[ -e /var/log/monitorRS.log ] || touch /var/log/monitorRS.log

addrs() {
  ipvsadm -a -t $VIP:$VPORT -r $1:$RPORT -$TYPE -w $2
  [ $? -eq 0 ] && return 0 || return 1
}

delrs() {
  ipvsadm -d -t $VIP:$VPORT -r $1:$RPORT
  [ $? -eq 0 ] && return 0 || return 1
}


while true; do
  let COUNT=0
for rip in ${RS[*]}; do

    if ipvsadm -Ln | grep "$rip:$RPORT" &> /dev/null ; then
      RS_status=online
    else
      RS_status=offline
    fi

	if $(curl --connect-timeout 1 http://$rip &>/dev/null) ; then
    RS_test=yes
	else
	RS_test=no
	fi

case $RS_test in
yes)
      case ${RS_status} in
	  online)
	  echo "`date +'%F %H:%M:%S'`, $rip is work nice now." >> $LOG
	  ;;
	  offline)
         addrs $rip ${RW[$COUNT]} &>/dev/null;
		 addstatus=$?
         	if  [ $? -eq 0 ] && RS_status=online ;
		 	then
		 		echo "`date +'%F %H:%M:%S'`, $rip has been added to work." >> $LOG
			else
			    echo "something wrong when add $rip back to work,please check,maybe your should do it manual"
		    	 echo "`date +'%F %H:%M:%S'`, $rip is added failed." >> $LOG
			fi
	  ;;
	  *)
	  echo "Something wrong when read RS_status"
	  ;;
	  esac
;;
no)
      case ${RS_status} in
	  online)
         delrs $rip &>/dev/null;
         [ $? -eq 0 ] && RS_status=offline && echo "`date +'%F %H:%M:%S'`, $rip is out of work,it is delete." >> $LOG
		 ;;
	  offline)
		 echo "`date +'%F %H:%M:%S'`,$rip is still out of  work" >> $LOG
		 ;;
        *)
	  echo "Something wrong when read RS_status"
	  ;;
	  esac
;;
*)
   echo "Something wrong when read RS_test"
;;
esac
    let COUNT++
  done
  sleep 3
done
