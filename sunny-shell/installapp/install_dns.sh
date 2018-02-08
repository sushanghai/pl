#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-20
#FileName:             install_dns.sh
#version:              1.0
#Your change info:      
#Description:          For
#DOC URL:              http://ghbsunny.blog.51cto.com/7759574/1968239 
#Copyright(C):         2017  All rights reserved
#*****************************************************************************

min_time () {
    time=`date +%Y%m%d%H%M`
	}

os_version=$(cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2)


echo "Enter 1 : install master dns"
echo "Enter 2 : install slave  dns"
echo "Enter 3 : install transmit dns"
echo "Enter 4 : install sub zone dns"
echo "Enter 5 : See how to config key authentication for slaves dns to copy master dns zone resource file with key"
echo "Enter 6 : See how to config acl function"
echo "Enter 7 : See how to config view function"

min_time;

rpm -q bind &>/dev/null || yum -y install bind &>/dev/null;
rpm -q bind-chroot&>/dev/null || yum -y install bind-chroot &>/dev/null
rpm -q bind-utils &>/dev/null  ||     yum -y install bind-utils &>/dev/null
[ -e /etc/named.conf ] && cp /etc/named.conf /etc/named.conf."$time".bak || { echo "/etc/named.conf is not exist,please check";exit 2; }
[ -e /etc/named.rfc1912.zones ] && cp /etc/named.rfc1912.zones /etc/named.rfc1912.zones."$time".bak || { echo "/etc/named.rfc1912.zones is not exist,please";exit 6; }

mastercheck(){
named-checkconf || echo "Something wrong in /etc/named.conf,Please check"
named-checkzone $domain /var/named/"$domain".zone || echo "something was wrong in /var/named/"$domain".zone,please check"
named-checkzone "$arpaip".in-addr.arpa /var/named/"$arpaip".zone || echo "something was wrong in /var/named/"$arpaip".zone,please check"
}
masterconfzone(){
#config /etc/named.conf
  echo "Attention: It will install a master dns,which can provide FQDN-->IP and IP-->FQDN query,and sub-zone"
  echo "The master dns will allow any host to query"

  sed -i  's/listen-on port.*/listen-on port 53 { localhost; };/g' /etc/named.conf
  sed -i  's/allow-query.*/allow-query     { any; };/g' /etc/named.conf
  read -p "How many hosts you will allow slaves to copy mastar's zone resource analysis file(eg:1): " slavenu
  [[ "$slavenu" =~ ^[0-9]+$  ]] || { echo your input is no num,no slaves will allow to copy resource analysis file,please check;$slavenu=0; }
  if [ -z ${slavenu:-} ];then
  slavenu=0
  fi
  if [ "$slavenu" -gt 0 ];then
  read -p "Input which hosts ip was allow to copy(eg:172.18.50.75;172.18.50.63): " ip
   sed -i 's/allow-transfer.*//g' /etc/named.conf 
  sed -i   "/allow-query/ a allow-transfer { $ip; }; " /etc/named.conf
  fi

#config /etc/named.rfc1912.zones
read -p "Please input your domain name in order to make a resource analysis file name,such as sunny.com.zone,sunny.com is domain name(default:sunny.com)": domain
if [ -z ${domain:-} ];then
domain=sunny.com
fi
if  grep "zone \"$domain\" IN"  /etc/named.rfc1912.zones&>/dev/null;then
echo "$domain" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
cat >>/etc/named.rfc1912.zones<<eof
zone "$domain" IN {
    type master;
    file "$domain.zone";
    allow-update { none; };
};
eof
fi

read -p "Please input your inverse network in order to make a inverse resource analysis file name,such as 50.18.172.in-addr.arpa,50.18.172 is inverse network(default:50.18.172)": arpaip
if [ -z ${arpaip:-} ];then
arpaip=50.18.172
fi

if  grep "zone \"$arpaip.in-addr.apra\" IN"  /etc/named.rfc1912.zones&>/dev/null;then
echo "$arpaip.in-addr.arpa" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
cat >>/etc/named.rfc1912.zones<<eof
zone "$arpaip.in-addr.arpa" IN {
    type master;
    file "$arpaip.zone";
    allow-update { none; };
};
eof
fi
}

read -p "Please input your choice(eg:1): " choice
case $choice in

1)

masterconfzone;


#config zone resource analysis file
read -p "Please input the dns server ip(defaults:172.18.50.61): " dnsip
if [ -z ${dnsip:-} ];then
dnsip=172.18.50.61
fi

if ls /var/named/"$domain".zone &>/dev/null ;then 
 echo /var/named/"$domain".zone  already exist,it will not be config one more time,please check.
else
cat >>/var/named/"$domain".zone<<eof
\$TTL 1D
@   IN    SOA  masterdns  admin.sunny.com. (
                    $(date +%Y%m%d)01   ; serial
                    1D  ; refresh
                    1H  ; retry
                    1W  ; expire
                    3H )    ; minimum
           NS  masterdns
           NS  slave1
           NS  slave2
masterdns        A   $dnsip
slave1           A  172.18.50.63
slave2           A   172.18.50.75
www              CNAME  webser
ftp              CNAME  webser
webser           A    172.18.50.88
http             A    172.18.50.66
           MX 10 mailsrv1
           MX 20 mailsrv2
mailsrv1   A  172.18.50.72
mailsrv2   A  172.18.50.73
tracy.sunny.com. IN NS  subzone1.tracy.sunny.com.
subzone1.tracy.sunny.com. A 172.18.50.62

eof
fi

#you should define" $ORIGIN 50.18.172.in-addr.arpa. " before you define PTR type,or you should write the full arpa address when you define slaves,others it will no tranfer zone file from master dns server auto when master arpa resource file change
if ls /var/named/$arpaip.zone &>/dev/null ;then 
 echo /var/named/$arpaip.zone  already exist,it will not be config one more time,please check.
else
cat >>/var/named/"$arpaip".zone<<eof
\$TTL 1D
@   IN    SOA  masterdns.$domain.  admin.sunny.com. (
                    $(date +%Y%m%d)01   ; serial
                    1D  ; refresh
                    1H  ; retry
                    1W  ; expire
                    3H )    ; minimum
       IN    NS  masterdns.$domain.
       IN    NS   slave1.sunny.com.
       IN    NS   slave2.sunny.com.
tracy.sunny.com.    IN   NS       subzone1.tracy.sunny.com.
63.50.18.172.in-addr.arpa.     IN    PTR  slave1.sunny.com.
75.50.18.172.in-addr.arpa.     IN    PTR  slave2.sunny.com.
62.50.18.172.in-addr.arpa.     IN    PTR  subzone1.tracy.sunny.com.
61     IN    PTR   masterdns.$domain.
88     IN    PTR  www.sunny.com.
66     IN    PTR  http.sunny.com.
88     IN    PTR  ftp.sunny.com.
72     IN    PTR  mailsrv1.sunny.com.
73     IN    PTR  mailsrv2.sunny.com.

eof
fi

echo "You can run "vim /var/named/"$domain".zone" to add more source analysis"

 mastercheck;

;;

2)
#config /etc/named.conf
  echo "Attention: It will install a slave dns,which can provide FQDN-->IP and IP-->FQDN query"
  echo "The slave dns will allow any host to query"
  sed -i  's/listen-on port.*/listen-on port 53 { localhost; };/g' /etc/named.conf
  sed -i  's/allow-query.*/allow-query     { any; };/g' /etc/named.conf
#config /etc/named.rfc1912.zones
read -p "Please input master ip(default: 172.18.50.61 )" masterip
if [ -z ${masterip:-} ];then
masterip=172.18.50.61
fi
read -p "Please input your domain name in order to make a resource analysis file name,such as sunny.com.zone,sunny.com is domain name(default:sunny.com)": domain
if [ -z ${domain:-} ];then
domain=sunny.com
fi
if  grep "zone \"$domain\" IN"  /etc/named.rfc1912.zones&>/dev/null;then
echo "$domain" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
cat >>/etc/named.rfc1912.zones<<eof
zone "$domain" IN {
    type slave;
	masters { $masterip; };
	file "slaves/$domain.zone";
};
eof
fi

read -p "Please input your inverse network in order to make a inverse resource analysis file name,such as 50.18.172.in-addr.arpa,50.18.172 is inverse network(default:50.18.172)": arpaip
if [ -z ${arpaip:-} ];then
arpaip=50.18.172
fi

if  grep "zone \"$arpaip.in-addr.apra\" IN"  /etc/named.rfc1912.zones&>/dev/null;then
echo "$arpaip.in-addr.arpa" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
cat >>/etc/named.rfc1912.zones<<eof
zone "$arpaip.in-addr.arpa" IN {
    type slave;
	masters { $masterip; };
    file "slaves/$arpaip.zone";
};
eof
fi
;;
3)
    echo "Your will install a forward dns hosts"
	echo
	echo
	sed -i  's/listen-on port.*/listen-on port 53 { localhost; };/g' /etc/named.conf
	sed -i  's/allow-query.*/allow-query     { any; };/g' /etc/named.conf
	read -p "Input which server you forward as dns server(defaults:172.18.50.61):" forwardip
	if [ -z ${forwardip:-} ];then
	forwardip=172.18.50.61
	fi
	echo "Enter all : to forward all request to assign dns server"
	echo "Enter part : only forward some zone request to assign dns server"
	sed -i 's/dnssec-enable yes;/dnssec-enable no;/g' /etc/named.conf
	sed -i 's/dnssec-validation yes;/dnssec-validation no;/g' /etc/named.conf
    read -p "Please input your choice (all  or  part): " aorp
	case $aorp in 
	all)
      sed -i 's/forward.*//g' /etc/named.conf
      sed -i '/dnssec-validation/ a  forward first;' /etc/named.conf
	  sed -i "/forward/ a  forwarders { $forwardip; };" /etc/named.conf

	;;
    part)
     
read -p "Please which  domain zone you want to forward,such as sunny.com.zone,sunny.com is domain name(default:sunny.com)": forwardzone
if [ -z ${forwardzone:-} ];then
forwardzone=sunny.com
fi
read -p "Please input your inverse network in order to make a inverse resource analysis file name,such as 50.18.172.in-addr.arpa,50.18.172 is inverse network(default:50.18.172)": arpaip
if [ -z ${arpaip:-} ];then
arpaip=50.18.172
fi
	read -p "Input which server you forward as dns server(defaults:172.18.50.61):" forwardip
	if [ -z ${forwardip:-} ];then
	forwardip=172.18.50.61
	fi
if  grep "forwarders { $forwardip; };"  /etc/named.rfc1912.zones&>/dev/null;then
echo forwarders "$forwardip" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
# "If your server is centos6,but your forward is centos7,and you set forward first,it can be successful if you test forward direction,but it would be fail if you test inverse arpa.you should set forward only to test inverse arpa,it is the same promble is it is both centos7.However it is ok if dns and forward host are all centos6"

cat >>/etc/named.rfc1912.zones<<eof
zone "$forwardzone" IN {
    type forward;
	forward first;
	forwarders { $forwardip; };
};
zone "$arpaip.in-addr.arpa" IN {

type  forward;
forward first;
forwarders { $forwardip; };

};

eof
fi
	;;
	*)
       echo "Your input is wrong ,nothing has been config,please check"
	;;
	esac


;;

4)


masterconfzone;
read -p "Please input the main dns ip to forward (defaults:172.18.50.61): " forwardip2
if [ -z ${forwardip2:-} ];then
forwardip2=172.18.50.61
fi

if  grep "forwarders { $forwardip2; };"  /etc/named.conf&>/dev/null;then
echo forwarders "$forwardip2" already config in /etc/named.rfc1912.zones,it will not be config one more time,please check.
else
sed -i "/allow-query/ a forwarders { $forwardip2; };" /etc/named.conf
fi


#config zone resource analysis file
read -p "Please input the subzone dns server ip(defaults:172.18.50.62): " dnsip
if [ -z ${dnsip:-} ];then
dnsip=172.18.50.62
fi

if ls /var/named/"$domain".zone &>/dev/null ;then 
 echo /var/named/"$domain".zone  already exist,it will not be config one more time,please check.
else
cat >>/var/named/"$domain".zone<<eof
\$TTL 1D
@   IN    SOA  subzone  admin.sunny.com. (
                    $(date +%Y%m%d)01   ; serial
                    1D  ; refresh
                    1H  ; retry
                    1W  ; expire
                    3H )    ; minimum
           NS  subzone
           MX 10 mailsrv1
           MX 20 mailsrv2
subzone    A   $dnsip
mailsrv1   A  192.168.32.72
mailsrv2   A  192.168.32.73
nginx      A  192.168.32.77
eof
fi

#you should define" $ORIGIN 50.18.172.in-addr.arpa. " before you define PTR type,or you should write the full arpa address when you define slaves,others it will no tranfer zone file from master dns server auto when master arpa resource file change
if ls /var/named/$arpaip.zone &>/dev/null ;then 
 echo /var/named/$arpaip.zone  already exist,it will not be config one more time,please check.
else
cat >>/var/named/"$arpaip".zone<<eof
\$TTL 1D
@   IN    SOA  subzone.$domain.  admin.sunny.com. (
                    $(date +%Y%m%d)01   ; serial
                    1D  ; refresh
                    1H  ; retry
                    1W  ; expire
                    3H )    ; minimum
       IN    NS  subzone.$domain.
62     IN    PTR  subzone.tracy.sunny.com.
72     IN    PTR  mailsrv1.tracy.sunny.com.
73     IN    PTR  mailsrv2.tracy.sunny.com.
77     IN    PTR  nginx.tracy.sunny.com.

eof
fi

echo "You can run "vim /var/named/"$domain".zone" to add more source analysis"

 mastercheck;
;;

5)
echo "eg: master dns server ip 172.18.50.61 ; slave nds ip: 172.18.50.63"
echo  "step 1: run at server "dnssec-keygen -a HMAC-MD5 -b 128 -n HOST 6akey" to generate a key chain,--> get result two keys: K6akey.+157+49816.key and K6akey.+157+49816.private "
echo  "step 2: run at server "cat K6akey.+157+49816.private" to get key,there is one line begin with "Key:" --> get result: "Key: +rnJ7Yl6iU9be4Uxj/x04A==", the character string "+rnJ7Yl6iU9be4Uxj/x04A==" is the key  "
echo  "step 3: config at master dns,run "vim /etc/named.conf" ,inside option ,add conf 'allow-transfer { key 6akey; }' 6akey is the key name       

    server 172.18.50.63 {   
       keys { 6akey; };
    };  
    key 6akey {
    
    algorithm hmac-md5;
    secret "+rnJ7Yl6iU9be4Uxj/x04A==";
    }; 
####attention 172.18.50.63 is the slave which you allow to copy resoure file from master,"+rnJ7Yl6iU9be4Uxj/x04A==" is the key #####
  "
echo "step 4: config at slave dns, outside option,config below :

  server 172.18.50.61 {
       keys { 6akey; };
    };  
    key 6akey {
       
    algorithm hmac-md5;
    secret "+rnJ7Yl6iU9be4Uxj/x04A==";
    };  
 ####attention 172.18.50.61 is the master ip which the slave want to  copy resoure file ,"+rnJ7Yl6iU9be4Uxj/x04A==" is the key #####
"
echo "step 5: run "service named restart" to restart dns service"
;;
6)
echo "ACL function is to Merge one or more addresses into a collection and call it through a uniform name"
echo "You can define acl and config at any dns server"
echo "run at dns server,define one acl name mynet,and apply it to allow-qurey,below is example,run "vim /etc/named.conf"
####define acl
acl mynet {
  172.18.50.62;
  172.18.50.63;
  172.18.50.75;
};
####apply acl
allow-query     { mynet; };
"
echo "then run "service named restart" to restart dns service,only the three hosts can qurey the dns server "
echo "Attention,there are four default acl in dns,
none,no one ip 
any,any ip
localhost,only the host ip
localnet,eg localhost 192.168.32.66 and subnet 255.255.255.0,so localnet is 192.168.32.0/24

"
echo "no all parameter can use acl,for one eg, forwarders { 172.18.50.61; },172.18.50.61; should be ip,and can not be replaced with acl"
;;
7)
echo "All all config in /etc/named.conf"
echo "when using 'view' statements, all zones must be in views, so as "include "/etc/named.rfc1912.zones";  " should be config in view "
echo "you can define acl to do soome ip match"
echo "step 1：Prepare six files in /var/named/,   32.168.192.zone  chao.32.168.192.zone  chao.tracy.sunny.com.zone,external.32.168.192.zone  external.tracy.sunny.com.zone,tracy.sunny.com.zone "
echo "step 2: run " vim /etc/named.conf "
#########define two acl as below#####
acl internal  {
      172.18.50.61;
      172.18.50.63;
};

acl external {
     172.18.50.72;
     172.18.50.73;
};
#########config three views as below#####
view inter { 
match-clients { internal; };
zone "." IN {
    type hint;
    file "named.ca";
};

zone "tracy.sunny.com" IN {
    type master;
    file "tracy.sunny.com.zone";
    allow-update { none; };
};
zone "32.168.192.in-addr.arpa" IN {
    type master;
    file "32.168.192.zone";
    allow-update { none; };
};
include "/etc/named.rfc1912.zones";
};

view exter { 
match-clients { external; };
zone "." IN {
    type hint;
    file "named.ca";
};

zone "tracy.sunny.com" IN {
    type master;
    file "external.tracy.sunny.com.zone";
    allow-update { none; };
};
zone "1.1.1.in-addr.arpa" IN {
    type master;
    file "external.32.168.192.zone";
    allow-update { none; };
};
include "/etc/named.rfc1912.zones";
};

view other { 
match-clients { any; };
zone "." IN {
    type hint;
    file "named.ca";
};
zone "tracy.sunny.com" IN {
    type master;
    file "chao.tracy.sunny.com.zone";
    allow-update { none; };
};
zone "2.2.2.in-addr.arpa" IN {
    type master;
    file "chao.32.168.192.zone";
    allow-update { none; };
};
include "/etc/named.rfc1912.zones";
};
#####################################

"
echo "step 3: run "service named restart" to restart dns service "



;;

*)
   echo "Your input is wrong ,please check"
;;

esac

service named restart

if [ $os_version -eq 6 ];then
service named status | grep " is running" &>/dev/null && echo "dns is running..." || echo "dns is not running,please check"
else
service named status | grep "active (running)" >&/dev/null && echo "dns is running..." || echo "dns is not running,please check"
fi



