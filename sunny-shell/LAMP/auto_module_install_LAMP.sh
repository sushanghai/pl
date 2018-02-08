#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-07
#FileName:             auto_install_LAMP.sh
#version:              1.0
#Your change info:      
#Description:          For auto install LAMP with xcache,wp,pma
#DOC URL:               
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
echo "Now install wget..."
rpm -q wget &>/dev/null || yum -y install wget &>/dev/null;
echo "install development tools,please wait..."
yum -y groupinstall "development tools" &>/dev/null || { echo "something wrong when install development tools,Please check local yum resource,script exist now";exit; }
serverip=$(ifconfig  | awk '/inet /{print $2}'| awk -F : '{print $NF}'| head -1)

[ -e /app ] || mkdir /app

get_version() {
 os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`
}

get_version;
min_time () {
    time=`date +%Y%m%d%H%M`
}
min_time;

last_restart_ser(){

/app/httpd24/bin/apachectl restart &>/dev/null && echo "Httpd24 has been restart OK,you can test now..." || echo "Something wrong when start httpd24,please check"
service mysqld restart &>/dev/null  && echo "Mysqld has been restart OK,you can test now..." || echo "Something wrong when start httpd24,please check"
service php-fpm restart &>/dev/null && echo "php-fpm has been restart OK,you can test now..." || echo "Restart php-fpm wrong,if you install php-fpm,please check,else ignore it."
echo "PATH=/app/php/bin:/app/httpd24/bin/:/usr/local/mysql/bin/:$PATH" >> /etc/profile.d/lamp.sh
echo "please run . /etc/profile.d/lamp.sh in order to export PATH"
echo "run   mysql_secure_installation  to init mysql"
echo "all is done,now exist"

}


httpd24_service(){
cat >/etc/init.d/httpd24<<eof
#!/bin/bash
#
# httpd        Startup script for the Apache HTTP Server
#
# chkconfig: - 85 15
# description: The Apache HTTP Server is an efficient and extensible  \\
#	       server implementing the current HTTP standards.
# processname: httpd
# config: /etc/httpd/conf/httpd.conf
# config: /etc/sysconfig/httpd
# pidfile: /var/run/httpd/httpd.pid
#
### BEGIN INIT INFO
# Provides: httpd
# Required-Start: \$local_fs \$remote_fs \$network \$named
# Required-Stop: \$local_fs \$remote_fs \$network
# Should-Start: distcache
# Short-Description: start and stop Apache HTTP Server
# Description: The Apache HTTP Server is an extensible server 
#  implementing the current HTTP standards.
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

if [ -f /etc/sysconfig/httpd ]; then
        . /etc/sysconfig/httpd
fi

# Start httpd in the C locale by default.
HTTPD_LANG=\${HTTPD_LANG-"C"}

# This will prevent initlog from swallowing up a pass-phrase prompt if
# mod_ssl needs a pass-phrase from the user.
INITLOG_ARGS=""

# Set HTTPD=/usr/sbin/httpd.worker in /etc/sysconfig/httpd to use a server
# with the thread-based "worker" MPM; BE WARNED that some modules may not
# work correctly with a thread-based MPM; notably PHP will refuse to start.

# Path to the apachectl script, server binary, and short-form for messages.
apachectl=/app/httpd24/bin/apachectl
httpd=${HTTPD-/app/httpd24/bin/httpd}
prog=httpd
pidfile=${PIDFILE-/app/httpd24/logs/httpd.pid}
lockfile=${LOCKFILE-/var/lock/subsys/httpd24}
RETVAL=0
STOP_TIMEOUT=\${STOP_TIMEOUT-10}

# The semantics of these two functions differ from the way apachectl does
# things -- attempting to start while running is a failure, and shutdown
# when not running is also a failure.  So we just do it the way init scripts
# are expected to behave here.
start() {
        echo -n \$"Starting \$prog: "
        LANG=\$HTTPD_LANG daemon --pidfile=\${pidfile} \$httpd \$OPTIONS
        RETVAL=\$?
        echo
        [ \$RETVAL = 0 ] && touch \${lockfile}
        return \$RETVAL
}

# When stopping httpd, a delay (of default 10 second) is required
# before SIGKILLing the httpd parent; this gives enough time for the
# httpd parent to SIGKILL any errant children.
stop() {
	echo -n \$"Stopping \$prog: "
	killproc -p \${pidfile} -d \${STOP_TIMEOUT} \$httpd
	RETVAL=\$?
	echo
	[ \$RETVAL = 0 ] && rm -f \${lockfile} \${pidfile}
}
reload() {
    echo -n \$"Reloading \$prog: "
    if ! LANG=\$HTTPD_LANG \$httpd \$OPTIONS -t >&/dev/null; then
        RETVAL=6
        echo \$"not reloading due to configuration syntax error"
        failure \$"not reloading \$httpd due to configuration syntax error"
    else
        # Force LSB behaviour from killproc
        LSB=1 killproc -p \${pidfile} \$httpd -HUP
        RETVAL=\$?
        if [ \$RETVAL -eq 7 ]; then
            failure \$"httpd shutdown"
        fi
    fi
    echo
}

# See how we were called.
case "\$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  status)
        status -p \${pidfile} \$httpd
	RETVAL=\$?
	;;
  restart)
	stop
	start
	;;
  condrestart|try-restart)
	if status -p \${pidfile} \$httpd >&/dev/null; then
		stop
		start
	fi
	;;
  force-reload|reload)
        reload
	;;
  graceful|help|configtest|fullstatus)
	\$apachectl \$@
	RETVAL=\$?
	;;
  *)
	echo \$"Usage: \$prog {start|stop|restart|condrestart|try-restart|force-reload|reload|status|fullstatus|graceful|help|configtest}"
	RETVAL=2
esac

exit \$RETVAL
eof
chmod 755 /etc/init.d/httpd24
}


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

install_httpd24(){
echo "now install httpd-2.4.27.tar.bz2 include apr-1.6.2.tar.gz  and apr-util-1.6.0.tar.gz"
get_package;
echo "Httpd2.4 will be install in /app/httpd24,it is website home is /app/httpd24/htdocs/"
echo install openssl-devel pcre-devel expat-devel ,please wait...
yum -y  install openssl-devel pcre-devel expat-devel &>/dev/null || { echo "something wrong when install openssl-devel pcre-devel expat-devel ,Please check local yum resource,script exist now";exit; }
cd /usr/local
tar xf /root/package/package."$time"/apr-1.6.2.tar.gz -C /usr/local
tar xf /root/package/package."$time"/apr-util-1.6.0.tar.gz -C /usr/local
tar xf /root/package/package."$time"/httpd-2.4.27.tar.bz2 -C /usr/local
cp -r /usr/local/apr-1.6.2  /usr/local/httpd-2.4.27/srclib/apr
cp -r /usr/local/apr-util-1.6.0  /usr/local/httpd-2.4.27/srclib/apr-util
cd /usr/local/httpd-2.4.27/
echo "now configure and make install httpd24"
./configure --prefix=/app/httpd24 --enable-so --enable-ssl --enable-rewrite --with-zlib --with-pcre --with-included-apr --enable-modules=most --enable-mpms-shared=all --with-mpm=prefork &>/dev/null;
make &>/dev/null || ehco "something wrong when make httpd.please check"
make install &>/dev/null  || ehco "something wrong when make install httpd.please check"
echo  "PATH=/app/httpd24/bin/:$PATH" >> /etc/profile.d/lamp.sh
id apache &>/dev/null && userdel  apache &>/dev/null;
useradd -r -d /app/httpd24/htdoc  -s /sbin/nologin apache;
sed -i 's/User daemon/User apache/g'  /app/httpd24/conf/httpd.conf 
sed -i 's/Group daemon/Group apache/g'  /app/httpd24/conf/httpd.conf 
echo  "PATH=/app/httpd24/bin/:$PATH" >> /etc/profile.d/lamp.sh
sed -i "s/#ServerName www.example.com:80/ServerName www.$(hostname).com:80/g" /app/httpd24/conf/httpd.conf
if [ "$os_version" -eq 6 ];then
httpd24_service
chkconfig --add httpd24
chkconfig  httpd24 on
else 
echo "/app/httpd24/bin/apachectl start" >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
fi
/app/httpd24/bin/apachectl restart &>/dev/null;
ss -nultp | grep :80 &>/dev/null && echo "Httpd24 now is running..." || echo "Httpd24 could not be start,please check"
}

install_mariadb(){
echo "now install mariadb-5.5.57-linux-x86_64.tar.gz"
get_package;
echo "now unzip mariadb,wait a minute"
tar xf /root/package/package."$time"/mariadb-5.5.57-linux-x86_64.tar.gz  -C /usr/local/
cd /usr/local/
ln -s mariadb-5.5.57-linux-x86_64/ mysql
id mysql &>/dev/null && userdel  mysql &>/dev/null;
useradd -r -m -d /app/mysqldb -s /sbin/nologin mysql;
cd /usr/local/mysql
scripts/mysql_install_db --datadir=/app/mysqldb --user=mysql &>/dev/null;
mkdir /etc/mysql
cp support-files/my-large.cnf   /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a skip_name_resolve = ON' /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a innodb_file_per_table = ON' /etc/mysql/my.cnf
sed -i '/\[mysqld\]/ a datadir = /app/mysqldb' /etc/mysql/my.cnf
cp support-files/mysql.server /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig  mysqld on
if [ $os_version -eq 6 ];then
touch /var/log/mysqld.log;
chown mysql /var/log/mysqld.log;
else
mkdir /var/log/mariadb;
chown mysql /var/log/mariadb/;
fi;
service mysqld restart &>/dev/null;
ps -ef | grep ^mysql &>/dev/null && echo "Mysql is running now..." || echo "Mysql is not running,please check"
echo "PATH=/usr/local/mysql/bin/:$PATH" >/etc/profile.d/lamp.sh 
echo "Now create database wpdb and create user wpadmin"
/usr/local/mysql/bin/mysql <<EOF
create database wpdb;
grant all on wpdb.* to wpadmin@'%' identified by 'Pass123456';
EOF
echo "After mariadb is complete install,for safe ,run mysql_secure_installation"
}

install_php(){
echo "now install php-5.6.31.tar.bz2"
get_package;
echo "install libxml2-devel bzip2-devel libmcrypt-devel,please wait..."
echo "You should check basic and epel source"
yum -y install libxml2-devel bzip2-devel libmcrypt-devel &>/dev/null || { echo "something wrong when install libxml2-devel bzip2-devel libmcrypt-devel,Please check local and epel yum resource,script exist now";exit; }
echo "now unzip  php-5.6.31.tar.bz2,wait a minite"
tar xf /root/package/package."$time"/php-5.6.31.tar.bz2 -C /usr/local
echo "now configure php"
cd /usr/local/php-5.6.31
./configure --prefix=/app/php --with-mysql=/usr/local/mysql --with-openssl --with-mysqli=/usr/local/mysql/bin/mysql_config --enable-mbstring --with-png-dir --with-jpeg-dir --with-freetype-dir --with-zlib --with-libxml-dir=/usr --enable-xml --enable-sockets --with-apxs2=/app/httpd24/bin/apxs --with-mcrypt --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-bz2 &>/dev/null || { echo "something wrong when configure php,script will exist,please check";exit; }
make &>/dev/null || { echo "something wrong when make php,script will exist,please check";exit; }
make install &>/dev/null || { echo "something wrong when make install php,script will exist,please check";exit; }
cp /usr/local/php-5.6.31/php.ini-production  /etc/php.ini
echo "AddType application/x-httpd-php .php" >> /app/httpd24/conf/httpd.conf
echo "AddType application/x-httpd-php-source .phps" >> /app/httpd24/conf/httpd.conf
sed -i.bak 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /app/httpd24/conf/httpd.conf
cat >/app/httpd24/htdocs/index.php <<EOF
<h1>
<?php
\$mysqli=new mysqli("$serverip","root","Pass123456");
if(mysqli_connect_errno()){
echo "it is falilure!";
\$mysqli=null;
exit;
}
echo "nice job,it is connected...";
\$mysqli->close();
phpinfo();
?>
</h1>
EOF
echo "php has been complete configure,now resatart httpd24"
/app/httpd24/bin/apachectl restart  &>/dev/null && echo "Httpd24 has been restart OK,you can test now..." || echo "Something wrong when start httpd24,please check"
}

install_php_fpm(){
echo "now install php-5.6.31.tar.bz2"
echo "install libxml2-devel bzip2-devel libmcrypt-devel,please wait..."
yum -y install openssl-devel libxml2-devel bzip2-devel &>/dev/null || { echo "something wrong when install  openssl-devel libxml2-devel bzip2-devel,Please check local  yum resource,script exist now";exit; }
yum -y install libmcrypt-devel &>/dev/null || { echo "something wrong when install libmcrypt-devel,Please check epel yum resource,script exist now";exit; }
get_package;
echo "now unzip  php-5.6.31.tar.bz2,wait a minite"
tar xf /root/package/package."$time"/php-5.6.31.tar.bz2 -C /usr/local
echo "now configure php"
cd /usr/local/php-5.6.31
./configure --prefix=/app/php --with-mysql=/usr/local/mysql --with-openssl --with-mysqli=/usr/local/mysql/bin/mysql_config --enable-mbstring --with-freetype-dir  --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --enable-sockets --enable-fpm --with-mcrypt --with-config-file-path=/etc/php --with-config-file-scan-dir=/etc/php.d --with-bz2 &>/dev/null || { echo "something wrong when configure php,script will exist,please check";exit; }
make &>/dev/null || { echo "something wrong when make php,script will exist,please check";exit; }
make install &>/dev/null || { echo "something wrong when make install php,script will exist,please check";exit; }
[ -e /etc/php ] || mkdir /etc/php/
cp /usr/local/php-5.6.31/php.ini-production  /etc/php/php.ini
cp   /usr/local/php-5.6.31/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
chkconfig --add php-fpm
cp /app/php/etc/php-fpm.conf.default  /app/php/etc/php-fpm.conf
sed -i.bak 's/#LoadModule proxy_module modules\/mod_proxy.so/LoadModule proxy_module modules\/mod_proxy.so/g'  /app/httpd24/conf/httpd.conf
sed -i 's/#LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so/LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so/g'  /app/httpd24/conf/httpd.conf
#config httpd
sed -i.bak 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /app/httpd24/conf/httpd.conf
echo "AddType application/x-httpd-php .php" >> /app/httpd24/conf/httpd.conf
echo "AddType application/x-httpd-php-source .phps" >> /app/httpd24/conf/httpd.conf
echo "ProxyRequests Off" >>/app/httpd24/conf/httpd.conf
#If your php_fpm is not install in the local host,you should replace 127.0.0.1 with php_fpm host ip.
echo "ProxyPassMatch  ^/(.*\.php)$ fcgi://127.0.0.1:9000/app/httpd24/htdocs/\$1" >>/app/httpd24/conf/httpd.conf
cat >/app/httpd24/htdocs/index.php <<EOF
<h1>
<?php
\$mysqli=new mysqli("$serverip","wpadmin","Pass123456");
if(mysqli_connect_errno()){
echo "it is falilure!";
\$mysqli=null;
exit;
}
echo "nice job,it is connected...";
\$mysqli->close();
phpinfo();
?>
</h1>
EOF
echo "PATH=/app/php/bin:/app/httpd24/bin/:/usr/local/mysql/bin/:$PATH" >>/etc/profile.d/lamp.sh 
echo "php_fpm has been complete configure,now resatart php_fpm and httpd24"
service php-fpm restart &>/dev/null && echo "php-fpm has been restart OK,you can test now..." || { echo "Something wrong when startphp-fpm,it will exit,please check";exit; }
/app/httpd24/bin/apachectl restart  &>/dev/null && echo "Httpd24 has been restart OK,you can test now..." || { echo "Something wrong when start httpd24,it will exit;please check";exit; }
}


install_xcache(){
echo "now install xcache-3.2.0.tar.gz to speed up php"
get_package;
echo "install php-devel ,please wait..."
yum -y  install  php-devel &>/dev/null || { echo "something wrong when install  php-devel ,Please check local yum resource,script exist now";exit; }
tar xf /root/package/package."$time"/xcache-3.2.0.tar.gz -C /usr/local
cd /usr/local/xcache-3.2.0/
phpize 
./configure  --enable-xcache --with-php-config=/app/php/bin/php-config &>/dev/null || { echo "something wrong when configure xcache,script will exist,please check";exit; }
make  &>/dev/null || { echo "something wrong when make xcache,script will exist,please check";exit; }
make install  &>/dev/null || { echo "something wrong when make install xcache,script will exist,please check";exit; }
[ -e /etc/php.d/ ] || mkdir /etc/php.d/
cp /usr/local/xcache-3.2.0/xcache.ini  /etc/php.d/
sed -i.bak 's/extension = xcache.so/extension = \/app\/php\/lib\/php\/extensions\/no-debug-non-zts-20131226\/xcache.so/g' /etc/php.d/xcache.ini 
echo "xcache has been complete configure,now resatart httpd24"
/app/httpd24/bin/apachectl restart  &>/dev/null && echo "Httpd24 has been restart OK,you can test now..." || echo "Something wrong when start httpd24,please check"

}

install_pma(){
echo "now install phpMyAdmin-4.0.10.20-all-languages.zip"
get_package;
echo "now install php-mysql and php-mbstring "
yum -y install  php-mysql php-mbstring &>/dev/null || { echo "something wrong when install php-mysql and php-mbstring,it will exist;please check";exit; }
unzip /root/package/package."$time"/phpMyAdmin-4.0.10.20-all-languages.zip -d /app/httpd24/htdocs/ &>/dev/null
ln -s /app/httpd24/htdocs/phpMyAdmin-4.0.10.20-all-languages/ /app/httpd24/htdocs/pma
cp /app/httpd24/htdocs/pma/config.sample.inc.php  /app/httpd24/htdocs/pma/config.inc.php
sed -i "s/\$cfg\['blowfish_secret'\].*/\$cfg\['blowfish_secret'\] = 'afddadfsdfsfsdfdfsdfsadfsdfsdfsdfsdfffsfdsf';/g" /app/httpd24/htdocs/pma/config.inc.php
echo " phpMyAdmin has been complete configure now restart httpd24 and mysqld"
/app/httpd24/bin/apachectl restart  &>/dev/null && echo "httpd24 has been restart OK" || { echo "something wrong when restart httpd24,it will exit,please check";exit; }
service mysqld restart &>/dev/null && echo "mysqld has been restart ok,you can test  phpMyAdmin now" || { echo "something wrong when restart mysqld,it will exit,please check";exit; }
}

install_wordpress (){
echo "Now install wordpress-4.8-zh_CN.tar.gz,default database is wpdb,and teh user is wpadmin"
get_package;
tar xf /root/package/package."$time"/wordpress-4.8-zh_CN.tar.gz  -C /app/httpd24/htdocs
cd /app/httpd24/htdocs
ln -s /app/httpd24/htdocs/wordpress  /app/httpd24/htdocs/blog
cd /app/httpd24/htdocs/blog/
cp /app/httpd24/htdocs/blog/wp-config-sample.php  /app/httpd24/htdocs/blog/wp-config.php
sed -i.bak 's/database_name_here/wpdb/g' /app/httpd24/htdocs/blog/wp-config.php
sed -i 's/username_here/root/g' /app/httpd24/htdocs/blog/wp-config.php
sed -i 's/password_here/Pass123456/g' /app/httpd24/htdocs/blog/wp-config.php
echo "Now wordpress is config OK,you should open browser http://websrv/blog  to register "
}
echo "The script will install LAMP with phpmysqladmin,xcache and wordpress"
echo "You have two choice to install LAMP,the different is that you could install with php_fpm mode or php in httpd24"
read -p "Please input your choice ,1 means php_mode,2 means php in httpd24 mode( 1 or 2 ): " choice
case $choice in
1)
install_httpd24
install_mariadb
install_php_fpm
install_xcache
install_pma
install_wordpress

;;
2)

install_httpd24
install_mariadb
install_php
install_xcache
install_pma
install_wordpress
;;
*)
echo "Your input is wrong , now exit , please check..."
exit
;;
esac

last_restart_ser
