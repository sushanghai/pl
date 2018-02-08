#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-30
#FileName:             compile_install_mysql.sh
#version:              1.0
#Your change info:      
#Description:          For compile to install mysql in binary format
#DOC URL:               
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
rpm -q wget &>/dev/null || yum -y  install wget &>/dev/null;
get_version() {
 os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`
 }

part_common_install (){
mkdir /etc/mysql
cp /usr/local/mysql/support-files/my-huge.cnf /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a  innodb_file_per_table = on ' /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a  skip_name_resolve = on' /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a  datadir = \/mysql\/mydata/' /etc/mysql/my.cnf
cd    /usr/local/mysql/
./scripts/mysql_install_db --datadir=/mysql/mydata --user=mysql
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig  --add mysqld
chkconfig mysqld on
cat >/etc/profile.d/mysql.sh<<eof
export PATH=/usr/local/mysql/bin:$PATH
eof
}

get_package (){
min_time () {
    time=`date +%Y%m%d%H%M`
}
min_time;
packge_name (){ 
  echo "Now You will ask to input to package name,if you do not know the complete package name,please check under under http://192.168.32.75/source/ or make sure which package you have prepare in local host"
  echo "for example,version httpd 2.4 ,its complete package name is httpd-2.4.27.tar.bz2"
  echo "The packge you have download or prepare in local host will be move to /root/package/"
  echo
}
echo "You have two ways to get packages you want:"
echo "remote: I already put some packages in url http://192.168.32.75/source/  ,if it was in http://192.168.32.75/source/"
echo "local:  You should down load the package to the local host"
echo
[ -e /root/package ] || mkdir -p /root/package;
read -p  "Your package in l(local) or r(remote)( r or l ): " choice
case $choice in  
r)
  packge_name;
  read -p "Please input your complete package name under http://192.168.32.75/source/ (example:httpd-2.4.27.tar.bz2): " package 
  echo "Now it will get package to assign path"
  echo "Mariadb package will put in /root/package/"$package"."$time",it will take a few minute,please wait"

if ping  -c 1 -w 1 192.168.32.75 &>/dev/null;then 
  [ -e /root/package/"$package"."$time" ] || mkdir -p /root/package/"$package"."$time";
  cd /root/package/"$package"."$time"
  wget http://192.168.32.75/source/"$package" &>/dev/null
  if [ $? -eq 0 ];then 
     echo "$package is download to /root/package/"$package"."$time" "
  else
     echo "$package may not be download from  http://192.168.32.75/source/,the script will exit,please check."  
	 exit
  fi
else
  echo "package source server 192.168.32.75 may be down,the script will exit,please check."
  exit
fi
;;
l)
   read -p "Please input the package directory(eg: /root/mariadb ): " localdir
   read -p "Please input the full  package name ,(eg: mariadb-5.5.57-linux-x86_64.tar.gz ): " package
   [ -e /root/package/"$package"."$time" ] || mkdir -p /root/package/"$package"."$time";
   mv $localdir/$package  /root/package/"$package"."$time"
  if [ $? -eq 0 ];then
  echo "$localdir/$package is move to /root/package/"$package"."$time" "
  else
  echo "$localdir/$package may not move to /root/package/"$package"."$time",the script will exit,please check."
  exit
  fi
;;
*)
  echo "Your input is not r or l ,and it is wrong input,the script will exit,please check"
  exit
;;
esac
}





get_version;
echo "Now you will install mysql by auto complie in binary format"
echo "If your system is cent6.9,it will auto complie  mariadb-5.5.57"
echo "If your system is cent7,it will auto compile mariadb-10.2.8"
echo "I suggest you to download the mariadb package to local when you download the script together"
echo "The mariadb dabtabase path is  /mysql/mydata"
[ -e /mysql/mydata ] || mkdir -p  /mysql/mydata
echo

get_package;

#complile mysql

id mysql &>/dev/null && { usermode -d /mysql/mydata mysql;echo "Your system has account mysql ,mysql homedir is changed to /mysql/mydata,please check"; } || useradd -r -m -d /mysql/mydata -s /sbin/nologin mysql &>/dev/null;
if [ "$os_version" -eq 6 ];then
tar xf /root/package/"$package"."$time"/"$package" -C /usr/local/
cd /usr/local/
ln -s  mariadb-5.5.57-linux-x86_64  mysql
part_common_install;
touch /var/log/mysqld.log
chown mysql /var/log/mysqld.log
elif [ "$os_version" -eq 7 ];then
tar xf /root/package/"$package"."$time"/"$package" -C /usr/local/
cd /usr/local/
ln -s mariadb-10.2.8-linux-x86_64/ mysql
part_common_install;
mkdir /var/log/mariadb
touch /var/log/mariadb/mariadb.log
chown mysql /var/log/mariadb/mariadb.log


fi
echo "Now the script will restart mysqld"
echo
service mysqld restart;
ss -nlp | grep 3306 &>/dev/null && echo -e "Mysql is running now .... \nRun /usr/local/mysql/bin/mysql_secure_installation  to initial mysql for safe administrate\n" || echo "Mysql is not running,please check."
echo "Please run ". /etc/profile.d/mysql.sh to export mysql to PATH" ,if mysql is running, then run "mysql" to test,if mysql is not running,please check after you export mysql to the PATH"
