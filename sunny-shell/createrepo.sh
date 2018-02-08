#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-13
#FileName:             mvrepo.sh
#version:              1.0
#Your change info:     
#Description:          For auto config the package source
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
 #cat /etc/redhat-release   $releasever # it 6 or 7
 # uname -a                  $basearch  # it is i386 or x86——64
 # mkdir -p /var/www/html/centos/{6.5,6.9,7.3.1611}/{x86_64,i386}
 # mkdir -p /var/www/html/fedora-epel/{6.5,6.9,7.3.1611}/{x86_64,i386}
 #wget -nd -r -l1 --no-parent http://172.18.0.1/fedora-epel/6/x86_64/
 #wget -nd -r -l2 --no-parent  http://172.18.0.1/fedora-epel/7/x86_64/

min=$(date +%Y%m%d%H%M)

yum -y install wget &>/dev/null || { echo "Your host does not install wget,please check";exit; } 

#remove all repofile to new path
[ -e /etc/yum.repos.d/repobak.$min ] || mkdir -p /etc/yum.repos.d/repobak.$min
mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/repobak.$min
cat >/etc/yum.repos.d/sunny"$min".repo<<EOF
[sunnybase]
name=sunny_base_source_75
baseurl=http://172.18.50.75/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=http://172.18.50.75/centos/$releasever/RPM-GPG-KEY-CentOS-$releasever

[sunnyepel]
name=sunny_epel_source_61
baseurl=http://172.18.50.61/fedora-epel/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF


#test whether url can be reached
  read -p "Please input the url1 where you want to download base package(default:http://172.18.50.75/source): " url1
  read -p "Please input the url2 where you want to download epel package(default:http://172.18.50.61/source): " url2
  url1=${url1:-http://172.18.50.75/}
  url2=${url2:-http://172.18.50.61/}
  wget -nv --spider $url1 2>&1 | grep -o "200 OK" &>/dev/null && echo "$url1 is find to connect" || { echo "The base source $url1 is wrong or could not be connect,the scirpt will exit,please check the network to $url1";exit; }
  wget -nv --spider $url2 2>&1 | grep -o "200 OK" &>/dev/null && echo "$url2 is find to connect" || { echo "The epel source $url2 is wrong or could not be connect,the scirpt will exit,please check the network to $url2";exit; }

#test repolist
echo "Now it will test whether package source is OK,wait a minite"
yum repolist


#remove all repofile to theri old path
# mv /etc/yum.repos.d/repobak.$min/*.repo /etc/yum.repos.d/ && { rm -rf /etc/yum.repos.d/repobak.$min;rm -f etc/yum.repos.d/sunny"$min".repo; }



