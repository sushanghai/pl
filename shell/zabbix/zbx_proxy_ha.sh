server_ip=192.168.70.50
id zabbix
ID=echo $?
if [ $ID -eq 0 ];then
echo "exist zabbix"
else
groupadd -g 300 zabbix
useradd -u 300 -g zabbix zabbix
fi
#agentd_ip=`/sbin/ifconfig eth0 | grep 'inet addr'| awk '{print $2}' | awk -F: '{print $2}'`
#grep "epel" /etc/yum.repos.d/CentOS-Base.repo
result=`echo $?`
#if [ $result -eq 0 ];then
#yum install -y curl curl-devel net-snmp snmp net-snmp-devel perl-DBI libxml2-devel
#yum groupinstall "Development Tools" "Server Platform Development" -y
#else 
#echo "[epel]" >> /etc/yum.repos.d/CentOS-Base.repo
#echo "name=Centos epel" >> /etc/yum.repos.d/CentOS-Base.repo
#echo "baseurl=http://mirrors.aliyun.com/epel/6/\$basearch" >> /etc/yum.repos.d/CentOS-Base.repo
#echo "gpgcheck=0" >> /etc/yum.repos.d/CentOS-Base.repo
#echo "enabled=1" >> /etc/yum.repos.d/CentOS-Base.repo
yum install -y curl curl-devel net-snmp snmp net-snmp-devel perl-DBI libxml2-devel
#yum groupinstall "Development Tools" "Server Platform Development" -y
#fi
ZBXFILE=/usr/local/zabbix_agent
if [ -a $ZBXFILE ];then
cp /root/zabbix-2.4.8/misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
else
cd /root/
tar -xf zabbix-2.4.8.tar.gz
cd zabbix-2.4.8
make clean
./configure --prefix=/usr/local/zabbix_agent/ --enable-agent
make
make install
cp /root/zabbix-2.4.8/misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
fi
HOST=`echo $HOSTNAME`
#sed -i "s#\# StartAgents=3#StartAgents=8#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
#sed -i "s#\# Timeout=3#Timeout=8#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
#sed -i "s@\# Include=/usr/local/etc/zabbix_agentd.conf.d/#Include=/usr/local/zabbix_agent/etc/zabbix_agentd.conf.d/#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
#sed -i "s#\# UnsafeUserParameters=0#UnsafeUserParameters=1#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s#Server=127.0.0.1#Server=`echo $server_ip`#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s#ServerActive=127.0.0.1#ServerActive=`echo $server_ip`#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s#Hostname=Zabbix server#Hostname=`echo $HOST`#" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s#BASEDIR=/usr/local#BASEDIR=/usr/local/zabbix_agent#" /etc/init.d/zabbix_agentd

service zabbix_agentd start
chkconfig --add zabbix_agentd
chkconfig zabbix_agentd on
