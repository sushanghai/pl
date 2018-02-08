#!/bin/bash
# ----------------+---------------------------------------+
# * Author        : Sunny
# * Email         : ghbsunny@sina.com
# * Create time   : 2017-08-19 
# * Last modified : 
# * Filename      : setip.sh
# * Description   : edit net-card config
# * version       : 1.1
# ----------------+---------------------------------------+

export time=`date +%Y%m%d%H%M`
export dir="/etc/sysconfig/network-scripts"
export bakdir="/root/ifcfgbak"

function ipvar {
read -p "please input your ip:" ip
read -p "Please input your netmask: " netmask
read -p "Please input your gateway: " gateway
ping -c 1 -w 1 $ip && { echo "$ip is used,please check";exit 6; } ||echo "$ip is not used,it is ok"
}

function init {
sed -i "s/PREFIX.*$//g" $dir/ifcfg-$netcard
sed -i 's/BOOTPROTO.*$/BOOTPROTO=static/g' $dir/ifcfg-$netcard
sed -i 's/ONBOOT.*$/ONBOOT=yes/g' $dir/ifcfg-$netcard
grep DNS1  $dir/ifcfg-$netcard &>/dev/null && sed -i 's/DNS1.*$/DNS1=8.8.8.8/g' $dir/ifcfg-$netcard  ||sed -i '/GATEWAY/ i DNS1=8.8.8.8' $dir/ifcfg-$netcard
grep DNS2  $dir/ifcfg-$netcard&>/dev/null  && sed -i 's/DNS2.*$/DNS2=172.18.0.1/g' $dir/ifcfg-$netcard  ||sed -i '/GATEWAY/ i DNS2=172.18.0.1' $dir/ifcfg-$netcard
sed -i "s/IPADDR.*$/IPADDR=$ip/g" $dir/ifcfg-$netcard
grep NETMASK  $dir/ifcfg-$netcard&>/dev/null  && sed -i "s/NETMASK.*$/NETMASK=$netmask/g" $dir/ifcfg-$netcard  || sed -i "/IPADDR/ a NETMASK=$netmask" $dir/ifcfg-$netcard
sed -i "s/GATEWAY.*$/GATEWAY=$gateway/g"  $dir/ifcfg-$netcard
sed -i "/^$/d"  $dir/ifcfg-$netcard
}

function init2 {
sed -i 's/HWADDR.*$//g' $dir/ifcfg-$netcard
sed -i 's/UUID.*//g' $dir/ifcfg-$netcard
sed -i "/^$/d"  $dir/ifcfg-$netcard
}

cd $dir
[ -e ifcfg-eth0 ] && cp ifcfg-eth0 ifcfg-eth0.$time.bak || echo "If you are in centOS6,Please check whether your eth0 is exist"
[ -e ifcfg-ens33 ] && cp ifcfg-ens33 ifcfg-ens33.$time.bak || echo "If you are in centOS7,Please check whether your ens33 is exist"


echo -e "Please input follow options:\n eth0) to modify CentOS 6 eth0 \n eth1) to modify CentOS 6 eth1 \n ens33) to modify CentOS 7 ens33 \n ens37) to modify CentOS 7 ens37 \n diy) to config a net-card in least config \n other) to modify other net-card by template \n"
read -p "Please input your choice,ex (eth0 or ens33 or other): " netcard

case $netcard in

eth0)
ipvar
init
service NetworkManager stop

;;

eth1)

[ -e ifcfg-eth1 ] && cp ifcfg-eth1 ifcfg-eth1.$time.bak || cp ifcfg-eth0 ifcfg-eth1
  ipvar;
  init;
  init2;
sed -i 's/DEVICE.*$/DEVICE=eth1/g' $dir/ifcfg-$netcard
sed -i 's/NAME.*/NAME=eth1/g' $dir/ifcfg-$netcard
service NetworkManager stop

;;


ens33)
ipvar;
init;
;;

ens37)

[ -e ifcfg-ens37 ] && cp ifcfg-ens37 ifcfg-ens37.$time.bak || cp ifcfg-ens33 ifcfg-ens37
ipvar;
init;
init2;
sed -i 's/DEVICE.*$/DEVICE=ens37/g' $dir/ifcfg-$netcard
sed -i 's/NAME.*/NAME=ens37/g' $dir/ifcfg-$netcard
;;

diy)
read -p "Please input your diy net-card name,such as ifcfg-eth0 or ifcfg-ens33: " diycard
ipvar;
for card in $(ls /etc/sysconfig/network-scripts);do
    if [ "$card" = "$diycard" ];then
	mv "$card" "$card.$time.bak"
    else
      continue;
    fi	
done

     cat >>/etc/sysconfig/network-scripts/$diycard <<eof
DEVICE=$(echo $diycard | cut -d "-" -f2)
ONBOOT=yes
BOOTPROTO=static
IPADDR=$ip
NETMASK=$netmask
DNS1=8.8.8.8
DNS2=172.18.0.1
GATEWAY=$gateway
eof


;;
other)

read -p "Please input your netcard,such as ifcfg-eth0 or ifcfg-ens33: " netcard
[ -e ifcfg-ens33 -a ! -e ifcfg-$netcard ] && { cp ifcfg-ens33 ifcfg-$netcard;echo "create new ifcfg-$netcard"; } 
[ -e ifcfg-ens33 -a -e ifcfg-$netcard ] && echo " ifcfg-$netcard already exist "
[ -e ifcfg-eth0 -a ! -e ifcfg-$netcard ] && { cp ifcfg-eth0 ifcfg-$netcard;service NetworkManager stop;echo "create new ifcfg-$netcard"; }
[ -e ifcfg-eth0 -a -e ifcfg-$netcard ] && { echo "ifcfg-$netcard already exist";service NetworkManager stop; }
rm -rf ifcfg-other
ipvar;
init;
init2;
sed -i "s/DEVICE.*$/DEVICE=$netcard/g" $dir/ifcfg-$netcard
sed -i "s/NAME.*/NAME=$netcard/g" $dir/ifcfg-$netcard
;; 

*)
  mv *.bak  ifcfgbak
  echo "Please input an internet card"
  exit 18;
;;
esac


[ -e $bakdir ] && echo "dir $bakdir already exist" ||  mkdir -p $bakdir
mv /etc/sysconfig/network-scripts/*.bak $bakdir
echo  "now restart network"

service network restart

unset time
unset dir
unset bakdir
unset ip
unset netmask
unset gateway
unset card
unset netcard
unset diycard
