#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-08
#FileName:             clean_schedule.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
echo "$0 is used to clean bak file which generated by run auto script in /sharedisk/script/project"
echo "$0 is run by schedule every Friday 16:00"
echo "System will warn user at 15:30 Friday,if you have some file did not want to be clean,you should move to other dir or change file name without .bak"
echo "Sever 172.168.32.61 will not be clean as well,you can find some history file from server"

wall system now cleaning the backup files
rm -rf  /root/bakfile/*.bak
rm -rf /root/bakfile/\.*.bak
rm -rf /root/autoscript.bak/*.bak
rm -rf /root/ifcfgbak/*.bak

