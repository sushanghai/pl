#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Email:                ghbsunny@sina.com
#Date:                 2017-09-08
#FileName:             backup.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************

min_time () {
    time=`date +%Y%m%d%H%M`
	}

cd /sharedisk/for_script.bak

min_time

tar -cf script."$time".tar  /sharedisk/script









#tar file accord to baklist.what baklist is which be tar to tarfile

#cd /sharedisk/for_script.bak
#find /sharedisk/script/* -mmin -30 > /sharedisk/for_script.bak/bak30min_list
#find /sharedisk/script/* -mtime -7 >> /sharedisk/for_script.bak/bak7day_list
#tar -cf script."$time".tar -T /sharedisk/for_script.bak/bak30min_list


#run below cmd as schedule in order to remote disaster recovery

#find /nfsfile/share/for_script.bak/* -mmin -30 -exec cp {} /root/script_bak/ \;

