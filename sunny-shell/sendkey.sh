#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-14
#FileName:             sendkey.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************

for ip in 62 63 71 72 73 75;do
expect -c "
   spawn ssh-copy-id -i .ssh/id_rsa.pub root@192.168.32."$ip" 
   expect {
           \"*assword\" {set timeout 500; send \Pass123456\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
done
