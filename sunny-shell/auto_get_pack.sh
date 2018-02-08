#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-11
#FileName:             get_pack.sh
#version:              1.0
#Your change info:      
#Description:          For auto get package to /root/package
#DOC URL:               
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
rpm -q wget &>/dev/null || yum -y install wget &>/dev/null;
min_time () {
    time=`date +%Y%m%d%H%M`
}
min_time;



get_pack_file (){
  echo "Now You will ask to input to package name,if you do not know the complete package name,please check under  $url $localdir" 
  echo "for example,version httpd 2.4 ,its complete package name is httpd-2.4.27.tar.bz2，if you have many packages to download,you should use space to distinguish between different packages"
  read -p "now please input the packages names you want to download in $url,(eg:apr-1.6.2.tar.gz  httpd-2.4.27.tar.bz2  php-7.1.10.tar.xz): " package
  [ -e /root/package/package."$time" ] || mkdir -p /root/package/package."$time";
  echo "$package" | tr -s " " "\n" &>/root/package/package.file
  echo
}

get_package (){
echo "You have two ways to get packages you want:"
echo "remote: You will download from remote server,default url is  http://192.168.32.75/source"
echo "local:  You have already prepare package in the local host"
echo
[ -e /root/package ] || mkdir -p /root/package;
read -p  "Your package in l(local) or r(remote)( r or l ): " choice
case $choice in
r)
  read -p "Please input the url where you want to download package(default:http://172.18.50.75/source): " url
  url=${url:-http://172.18.50.75/source}
  wget -nv --spider $url 2>&1 | grep -o "200 OK" &>/dev/null || { echo "The url is wrong or could not be connect,the scirpt will exit,please check";exit; }

  get_pack_file;

  echo "Now start to download pack,please wait a minute"
  cd  /root/package/package."$time"
  while read pack;
  do
  [ -e /root/package/package."$time"/$pack ] || wget -q "$url/$pack"
  [ -e /root/package/package."$time"/$pack ] && echo  "$pack had been success download !" || { echo "$pack did not been downloaded,it will exist,please check...";exit; }
  done</root/package/package.file;
 # rm -f /root/package/package.file;
;;
l)
   read -p "Please input the package directory(eg: /root/mariadb ): " localdir

  get_pack_file;

  echo "Now start to copy pack to /root/package/package."$time",please wait a minute"
  cd  /root/package/package."$time"
  while read pack
  do
  [ -e /root/package/package."$time"/$pack ] || cp $localdir/$pack /root/package/package."$time" &>/dev/null;
  [ -e /root/package/package."$time"/$pack ] && echo  "$pack had been  success copy to /root/package/package.$time " || { echo "$pack did not copy to /root/package/package.$time,it will exist,please check...";exit; }
  done</root/package/package.file
 # rm -f /root/package/package.file;
;;
*)
  echo "Your input is not r or l ,and it is wrong input,the script will exit,please check"
  exit
;;
esac
}

remove_package(){
read -p "Would U want to remove the package you have prepared this time( y  or  n ): " removeable
if [ "$removeable" = "y" ];then
  echo "now delete  /root/package/package."$time""
  rm -rf /root/package/package."$time";
  else
  echo "Since you answer is not y,$package will be save in  /root/package/package."$time" "
fi
}

get_package
remove_package
