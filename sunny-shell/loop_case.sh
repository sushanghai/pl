#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-20
#FileName:             tt.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
echo "Enter 1 :  print hello world,do loop again"
echo "Enter 2 :  print hello sunny,do loop again"
echo "Enter 3 :  print hello master,but exit $0 do not run other cmds out of loop"
echo "Enter 4 :  print hellp tracy.but Jump out of the loop,run other cmds out of loop continue"
echo "Enter any other :  print bye,and exit $0,do not run other cmds out of loop"


while true;do
read -p "Please input your choice: " choice
case $choice in
1)
  echo  hello world
;;
2)
 echo  hello sunny
;;
3)
  echo  hello master
   exit
   ;;
4)
 echo   "hello tracy"
 break
 ;;
*)
 echo bye
 exit
 ;;
esac
done
echo it is end
