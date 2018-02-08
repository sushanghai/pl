#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-03
#FileName:             scp.sh
#version:              1.0
#Your change info:     
#Description:          For use to copy or send scripts by quite,or telnet or  ssh other host by quite
#Copyright(C):         2017  All rights reserved
#*****************************************************************************



echo "1 copy wang home dir,usage:$0"
echo "2 copy file under wang home,usage: $0 file_to_copy"
echo "3 send file to wang home,usage: $0 file_to_send"
echo "4 login other host by ssh,usage: $0 login_ip"
echo "5 login other host by telnet,usage: $0 login_ip login_user"
read -p "input the remote ip: " ip
read -p "input full path file_name or dir: " file
read -p "input host password: " passwd
read -p "Please input your choice: " choice
case $choice in 
1)
	expect -c "
	spawn scp -r wang@172.18.0.107:/home/wang/ /root/wang_$(date +%F-%H-%M)
	#spawn scp -r root@$ip:$file "$file\_$(date +%F-%H-%M)"
	expect {
	      # \"*assword\" {set timeout 300; send \"$passwd\r\"; }
	       \"*assword\" {set timeout 300; send \"$passwd\r\"; }
		   \"yes/no\" { send \"yes\r\"; exp_continue; }
	}
	expect eof"
	;;
2)
    expect -c "
  spawn  scp  wang@172.18.0.107:$file "$file\_$(date +%F-%H-%M)"
   # spawn scp  root@$ip:$file  /root/
    expect {
          # \"*assword\" {set timeout 500; send \"$passwd\r\"; }
           \"*assword\" {set timeout 500; send \"$passwd\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
    ;; 
3)
	expect -c "
   spawn  scp  $file  root@172.18.0.107:/home/wang/$(basenae $file)
   #spawn  scp  $file  root@$ip:/root
   expect {
          # \"*assword\" {set timeout 500; send \"$passwd\r\"; }
           \"*assword\" {set timeout 500; send \"$passwd\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
    ;; 
4)
   expect -c "
	spawn  ssh $ip
    expect {
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    \"*assword\" {set timeout 500; send \"$passwd\r\"; }
	}	
	interact
	 expect eof"
     ;;
5)
  
	  expect -c "
    spawn  telnet $ip
    expect {
    \"*assword\" {set timeout 500; send \"$passwd\r\"; }
    \"login\" { send \"sunny\r\";exp_continue; }
    }  
	interact
     expect eof"
     ;;
*)
    echo "Your input is wrong,please check"
	exit
	;;
esac
