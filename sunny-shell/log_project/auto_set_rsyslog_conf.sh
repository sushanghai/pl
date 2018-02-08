#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-15
#FileName:             auto_set_rsyslog_conf.sh
#version:              1.0
#Your change info:      
#Description:          For auto set rsylog_conf in client
#DOC URL:               
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************

time=`date +%Y%m%d%H%M`
os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`

mv /etc/rsyslog.conf /etc/rsyslog.conf.$time.bak
read -p "Please input your log server ip(default:172.18.50.75): " ip
ip=${ip:-172.18.50.75}
echo ip is $ip
case $os_version in 

6)
cat >/etc/rsyslog.conf<<eof
\$ModLoad imuxsock # provides support for local system logging (e.g. via logger command)
\$ModLoad imklog   # provides kernel logging support (previously done by rklogd)
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
\$IncludeConfig /etc/rsyslog.d/*.conf
*.info;mail.none;authpriv.none;cron.none               @$ip
authpriv.*                                             @$ip
mail.*                                                 @$ip
cron.*                                                 @$ip
*.emerg                                                 *
uucp,news.crit                                         @$ip
local7.*                                               @$ip 
eof
;;
7)
cat >/etc/rsyslog.conf<<eof
\$ModLoad imuxsock # provides support for local system logging (e.g. via logger command)
\$ModLoad imjournal # provides access to the systemd journal
\$WorkDirectory /var/lib/rsyslog
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
\$IncludeConfig /etc/rsyslog.d/*.conf
\$OmitLocalLogging on
\$IMJournalStateFile imjournal.state
*.info;mail.none;authpriv.none;cron.none                @$ip
authpriv.*                                              @$ip
mail.*                                                  @$ip
cron.*                                                  @$ip
*.emerg                                                 :omusrmsg:*
uucp,news.crit                                          @$ip
local7.*                                                @$ip 
eof
;;
*)
echo "The host is not centos6 or 7,it will exit now"
mv  /etc/rsyslog.conf.$time.bak /etc/rsyslog.conf 
exit
;;
esac

service rsyslog restart && echo "rsyslog has been restart" || echo "something wrong when restart rsyslog,please check"
