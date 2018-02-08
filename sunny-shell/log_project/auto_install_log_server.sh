#!/bin/bash
#
#*****************************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-16
#FileName:             auto_install_log_server.sh
#version:              1.0
#Your change info:      
#Description:          For auto install log server by rsyslog-mysql and LogAnalyzer
#DOC URL:              http://ghbsunny.blog.51cto.com/7759574/1973012 
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************************

os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`
time=`date +%Y%m%d%H%M`
ip=$(ifconfig  | awk '/inet /{print $2}'| awk -F : '{print $NF}'| head -1)
package='loganalyzer-4.1.5.tar.gz'
  [ -e /root/package/package."$time" ] || mkdir -p /root/package/package."$time";
  echo "$package" | tr -s " " "\n" &>/root/package/package.file
  echo

install_rsyslog_mysq(){

rpm -q rsyslog-mysql &>/dev/null || { yum -y install rsyslog-mysql &>/dev/null && echo "rsyslog-mysql is install complete" || { echo "rsyslog-mysql is not install,check yum source";exit; }; }
read -p "Input your sql admin user(default:root): " mysqladmin
mysqladmin=${mysqladmin:-root}
read -p "Input your sql admin user password: " adminpass
createdb=$(rpm -ql rsyslog-mysql | grep createDB.sql)
mysql -u$mysqladmin -p$adminpass < $createdb
/usr/bin/mysql -u$mysqladmin -p$adminpass <<EOF
grant all on Syslog.* to logadmin@'%' identified by 'Pass123456';
EOF
}
config_rsyslog(){
rpm -q rsyslog &>/dev/null || { yum -y install rsyslog &>/dev/null && echo "rsyslog is install complete" || { echo "rsyslog is not install,check yum source";exit; }; }
cat >>/etc/rsyslog.conf <<EOF
\$ModLoad imudp
\$UDPServerRun 514 
\$ModLoad imtcp
\$InputTCPServerRun 514 
\$ModLoad ommysql
local2.*                                                :ommysql:$ip,Syslog,logadmin,Pass123456
EOF
echo "rsyslog has been complete config,you can test if facility local2 can be log now."
echo "You can add facility.loglevel  :ommysql:$ip,Syslog,logadmin,Pass123456 to /etc/rsyslog.conf to log more log in the log server"
}

install_LogAnalyzer(){
echo "Now install loganalyzer"
tar xf /root/package/package."$time"/$package  -C  /usr/local/
cp -a /usr/local/loganalyzer-4.1.5/src  /var/www/html/log
touch /var/www/html/log/config.php
chmod  666 /var/www/html/log/config.php
echo -e "LogAnalyzer has been release,please run http://$ip/blog to config your log admin,defautl config is below\n\n
DBServer = "$ip";\n
DBName = 'Syslog';\n
DBUser = 'logadmin';\n
DBPassword = 'Pass123456';\n
DBTableName = 'SystemEvents';\n
"
}
restart_service(){
service rsyslog restart &>/dev/null && echo "rsyslog has been restart" || echo "Something wrong when restart rsyslog,please check"
service httpd restart &>/dev/null && echo "httpd has been restart" || echo "Something wrong when restart httpd,please check"
case $os_version in
6)
service mysqld restart &>/dev/null && echo "mysql has been restart" || echo "Something wrong when restart mysql,please check"
;;
7)
service mariadb restart &>/dev/null && echo "mysql has been restart" || echo "Something wrong when restart mysql,please check"
;;
*)
echo "Something wrong when restart mysql,please check"
exit
;;
esac
}


install_pack(){
rpm -q httpd &>/dev/null || { yum -y install httpd &>/dev/null && echo "httpd is install complete" || { echo "httpd is not install,check yum source";exit; }; }
rpm -q php &>/dev/null || { yum -y install php &>/dev/null && echo "php is install complete" || { echo "php is not install,check yum source";exit; }; }
rpm -q php-mysql &>/dev/null || { yum -y install php-mysql &>/dev/null && echo "php-mysql is install complete" || { echo "php-mysql is not install,check yum source";exit; }; }
rpm -q php-gd &>/dev/null || { yum -y install php-gd &>/dev/null && echo "php-gd is install complete" || { echo "php-gd is not install,check yum source";exit; }; }
}
download_LogAnalyzer(){

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

echo 
echo "First of all,make your basic and epel source is ok,it is better sohu epel,you can run cmd  yum repolist to check your yum source"
echo
read -p "Is your epel ok?,answer y to continue,other to check your epel: " isepel
case $isepel in
y)
echo "Since your answer is y,I know your epel is ok,the script will continue..."
;;
*)
echo "For your answer is not y,it will exit,please check your epel"
echo -e "Below is how to config sohu epel,you can write it to /etc/yum.repo.d/sunny.repo\n\n
[sohu]\n
name=sohu-source\n
baseurl=http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/\n
gpgcheck=1\n
enabled=0\n
gpgkey=http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/RPM-GPG-KEY-CentOS-\$releasever\n"
echo
exit
;;
esac

case $os_version in 
6)
if rpm -q mysql-server &>/dev/null;then
echo "The  mysql-server is already install before"
else
rpm -q mysql &>/dev/null || { yum -y install mysql &>/dev/null && echo "mysql is install complete" || { echo "mysql is not install,check yum source";exit; }; }
rpm -q mysql-server &>/dev/null || { yum -y install mysql-server &>/dev/null && echo "mysql-server is install complete" || { echo "mysql is not install,check yum source";exit; }; }
service mysqld restart &>/dev/null && echo "mysql has been restart" || echo "Something wrong when restart mysql,please check"
/usr/bin/mysql_secure_installation;
fi
echo "Now install some relative package"
install_pack
install_rsyslog_mysq
config_rsyslog
download_LogAnalyzer
install_LogAnalyzer

;;

7)
if rpm -q mysql-server &>/dev/null;then
echo "The  mysql-server is already install before"
else
rpm -q mariadb &>/dev/null || { yum -y install mariadb &>/dev/null && echo "mysql is install complete" || { echo "mysql is not install,check yum source";exit; }; }
rpm -q mariadb-server &>/dev/null || { yum -y install mariadb-server &>/dev/null && echo "mysql-server is install complete" || { echo "mysql-server is not install,check yum source";exit; }; }
service mariadb restart &>/dev/null && echo "mysql has been restart" || echo "Something wrong when restart mysql,please check"
/usr/bin/mysql_secure_installation
fi
echo "Now install some relative package"
install_pack
install_rsyslog_mysq
config_rsyslog
download_LogAnalyzer
install_LogAnalyzer
;;

*)
echo "Your system is not centos6 or 7,please check"
exit
;;
esac

echo 
echo "All config is done now,Now restart service"

restart_service

echo "If all service is restart ok,you can test now,otherwise,you just to solve the restart problem,the test"
echo "test url is http://$ip/blog"



