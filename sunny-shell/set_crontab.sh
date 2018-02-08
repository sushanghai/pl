#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-08
#FileName:             autocp.sh
#version:              1.0
#Your change info:     
#Description:          For set crontab
#DOC URL:              http://www.jianshu.com/p/ccbf926e377c
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
################################################################################################
#You can find the crontab in the history,if you want to reset crontab,you can remove # in front of every line
#attention,if you find any script do not work as the schedule which  you set  in /etc/crontab,you can try to set it by crontab -e.
#if you use crontab -e ,the grammar does not need to assign the user
#I suggest use this method to edit schedule
###############################################################################################

#method 1 : edit /var/spool/cron/user ,it means the schedule is running by the user.it can be check by crontab -l

#client only
#echo "00 16 * * 5 /root/autoscript.bak/clean_schedule.sh" >>/var/spool/cron/root
#echo "30 15 * * 5 /root/autoscript.bak/clean_warn.sh" >>/var/spool/cron/root
#echo "00 10 * * * /usr/sbin/ntpdate 192.168.32.61;/sbin/hwclock -w" >>/var/spool/cron/root

#server only
#echo "*/2 * * * * /sharedisk/script/project/autoproject/autosend.sh" >>/var/spool/cron/root
#echo "15 10 * * * /sharedisk/script/project/backup.sh" >>/var/spool/cron/root
#echo "20 10 * * * /usr/bin/rsync -a /sharedisk/script 192.168.32.75:/var/ftp/hui" >>/var/spool/cron/root


#both server and client
#echo "*/3 * * * * /root/autoscript.bak/autorun.sh" >>/var/spool/cron/root

#only in client 172.18.59.71 to cp backup script as second host back
#echo "20 10 * * * /root/autoscript.bak/copy_bakfile.sh" >>/var/spool/cron/root






#method 2 : edit /etc/crontab ,but you can not see the schdule by "crontab -l",you can check by "cat /etc/crontab"
#client only
#sed  -i "/user-name/ a  00 16 * * 5 root /root/autoscript.bak/clean_schedule.sh" /etc/crontab
#sed -i "/user-name/ a 30 15 * * 5 root /root/autoscript.bak/clean_warn.sh" /etc/crontab
#sed -i "/user-name/ a 00 10 * * * root /usr/sbin/ntpdate 192.168.32.61;/sbin/hwclock -w" /etc/crontab

#server only
#sed  -i "/user-name/ a  */2 * * * * root /sharedisk/script/project/autoproject/autosend.sh" /etc/crontab
#sed -i  "/user-name/ a  15 10 * * * root /sharedisk/script/project/backup.sh" /etc/crontab
#sed -i "/user-name/  a  20 10 * * * root /usr/bin/rsync -a /sharedisk/script 192.168.32.75:/var/ftp/hui" /etc/crontab


#both server and client
#sed  -i "/user-name/ a  */3 * * * * root /root/autoscript.bak/autorun.sh" /etc/crontab

#only in client 172.18.59.71 to cp backup script as second host back
#sed -i  "/user-name/ a  20 10 * * * root /root/autoscript.bak/copy_bakfile.sh" /etc/crontab

