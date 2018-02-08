#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Date:                 2017-08-30
#FileName:             autorun.sh
#version:              1.0
#Your change info:     
#Description:          For run script under autoscript by cron schedule
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
path=/root/autoscript
bakdir=/root/autoscript.bak
date=`date +%F-%H-%M`
cd $path
scriptnu=`ls | grep .sh | wc -l`
if [ $scriptnu -eq 0 ];then
#   echo "nothing to do"
   exit 8
else
for script in *.sh;do
    echo "$script exist"
	$path/$script
	mv $script $bakdir/"$script"."$date".bak
	wall "script $script done"
done
fi

unset path
unset bakdir
unset date
unset scriptnu

exit
