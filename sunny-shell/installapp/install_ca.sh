#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-09
#FileName:             install_ca.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************

CApath=/etc/pki/CA
certpath=/etc/pki/CA/certs
tlspath=/etc/pki/tls
tlsprivatepath=/etc/pki/tls/private
caprivatepate=/etc/pki/CA/private


#check certification info,run below cmd
#openssl x509 -in cent7bbaa.crt -noout -text

#check certification request infomation,run cmd as below
#openssl req -noout -text -in aa.csr

#check certification status,run cmd as below,01 is serial number
#openssl ca -status 01



active_ip(){
actip=$(ip a| grep -E "[0-9]+\/"| cut -d / -f1|sed -nr  's@.*( [0-9]+\.[^0][0-9]*\.[0-9]+\.[0-9]+)@\1@p'|cut -d " " -f2|head -1)
}

pri_key_name(){
echo "private key name should end with .key,such as clent.key"
read -p "enter your private key name(default:client."$actip".key) " prikey
if [ -z ${prikey:-} ];then
prikey=client."$actip".key
fi
}

cli_csr_name(){
echo "Cert request name should end with .crs,such as clent.csr"
read -p "enter your cert request name(default:client."$actip".csr) " clicsr
if [ -z ${clicsr:-} ];then
clicsr=client."$actip".csr
fi
}

key_length(){
echo "key length should be one of 1024,2048,4096"
read -p "enter your private key length(default:2048): " length
if [ -z ${length:-} ]; then
length=2048
fi
}


root_pre(){

[ -e "$CApath"/index.txt ] || touch  "$CApath"/index.txt
[ -e "$CApath"/serial ] || echo 01 >  "$CApath"/serial
#create a server private key
echo "unless you have modify ca private key name in /etc/pki/tls/openssl.cnf,only use default cakey.pem"read -p "enter your ca private key name accord to openssl.cnf (default:cakey.pem) " cakey
if [ -z ${cakey:-} ];then
cakey=cakey.pem
fi
key_length
if [ -e "$caprivatepate"/"$cakey"  ] ;then
echo "The server already have private key,$cakey, under "$caprivatepate"/,please check"
else
umask 066;
read -p "enter yes to encrypt private key,other enter will no enrypt: " yorn
if [ "$yorn" = yes ];then
   read -p "enter encrypt key word(eg:-des3): " encry
   openssl genrsa -out "$caprivatepate"/"$cakey" "$encry" "$length"
   else
    openssl genrsa -out "$caprivatepate"/"$cakey"  "$length"
fi
umask 022;
fi

}



echo "Enter 1 : run at root CA server and rootca_sig_itself"
echo "Enter 2 : run at sub_server,generate a private key and signature request file,and send request file to root CA "
echo "Enter 3 : run at client host,generate certification requst file and send to server auto"
echo "Enter 4 : run at server,generate certification and send to client auto"
echo "Enter 5 : run at server,to revoke some certification"
read -p "Please input your choice: " choice

case $choice in

1)

root_pre;

#generate a signature certificate for itself,-x509 is key work,means it signature to itself
echo "unless you have modify ca  signature certificate name in /etc/pki/tls/openssl.cnf,only use default cacert.pem"
read -p "enter your ca signature cer name accord to openssl.cnf (default:cacert.pem) " cacert
if [ -z ${cacert:-} ];then
cacert=cacert.pem
fi
if [ -e "$CApath"/"$cacert"  ] ;then
 echo "The server already have signature certificate,"$cacert" under "$CApath",please check"
 else
openssl  req -new -x509 -key "$caprivatepate"/"$cakey"   -days 7300 -out  "$CApath"/"$cacert"
fi
;;

2)

root_pre;
#generate a signature certificate request file and send to root CA
read -p "enter your ca signature cer request file  (default:subca.csr): " subcacert
if [ -z ${subcacert:-} ];then
subcacert=subca.csr
fi
if [ -e "$CApath"/"$subcacert"  ] ;then
 echo "The sub ca already have signature certificate,"$subcacert"under "$CApath",please check"
 else
openssl  req -new  -key "$caprivatepate"/"$cakey"   -days 7300 -out  "$CApath"/"$subcacert"
fi

#send request file to root CA
read -p "which root CA would you send(default:192.168.32.61): " serip
if [ -z ${serip:-} ];then
serip=192.168.32.61
fi
expect -c "
   spawn  scp   "$CApath"/"$subcacert"   root@"$serip":"$CApath"/certs/
   expect {
           \"*assword\" {set timeout 500; send \"Pass123456\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
;;

3)
echo "Please check whether you are in client"
#client generate private key
active_ip
pri_key_name
cli_csr_name
key_length


if [ -e "$tlsprivatepath"/"$prikey"  ] ;then
echo "The client already have private key "$prikey" under "$tlsprivatepat",please check"
else
umask 066;
if [ "$yorn" = yes ];then
   read -p "enter encrypt key word(eg:-des3): " encry
   openssl genrsa -out "$tlsprivatepath"/"$prikey" "$encry" "$length"
   else
    openssl genrsa -out "$tlsprivatepath"/"$prikey"  "$length"
fi
umask 022;
fi
#generate a signature certificate to root ca,without -x509.

if [ -e "$tlspath"/"$clicsr"  ] ;then
 echo "The client already have signature certificate request file,"$clicsr" under "$tlspath",please check"
 else
openssl req -new -key "$tlsprivatepath"/"$prikey" -out "$tlspath"/"$clicsr"
fi
#send request file to CA
read -p "which CA would you send(default:192.168.32.61): " serip
if [ -z ${serip:-} ];then
serip=192.168.32.61
fi
expect -c "
   spawn  scp  "$tlspath"/"$clicsr" root@"$serip":"$CApath"/certs/
   expect {
           \"*assword\" {set timeout 500; send \"Pass123456\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
;;
4)
read -p "enter which requst file in "$CApath"/certs you want want server to generate as certification(eg:cent7.csr): " clientrsq
read -p "enter new client cetification name(eg:cent7.crt): " crtname
[ -e "$CApath"/certs/"$crtname" ] && { echo $crtname exist,please check;exit 6; }
read -p "enter many days would the cert be avlid(eg:365): " days
if [ -e "$CApath"/certs/"$clientrsq" ];then
#attention,no only $crtname be generated,but also serial.pem file will be generate under dir newcerts

 openssl ca -in  "$CApath"/certs/"$clientrsq" -out "$CApath"/certs/"$crtname" -days "$days"
else
  echo "$clientrsq does no exist in "$CApath"/certs,please check"
fi

read -p "which client would you send(eg:192.168.32.61): " clip
expect -c "
   spawn  scp   "$CApath"/certs/"$crtname"  root@"$clip":"$tlspath"
   expect {
           \"*assword\" {set timeout 500; send \"Pass123456\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"

;;
5)
read -p "Please input the serial number you want to revoke(eg:03): " sernum
echo "you can run cmd  openssl x509 -in cent7bt.crt -noout -text  to check the serial number,cent7bt.crt is the certification you want to revoke"
openssl ca -revoke /etc/pki/CA/newcerts/"$sernum".pem
crlnum=$(cat /etc/pki/CA/crlnumber)
[ -z $crlnum ] && echo 01 > /etc/pki/CA/crlnumber;
openssl ca -gencrl -out /etc/pki/CA/crl/crl.pem;
#check the the crl list
#openssl   crl  -in /etc/pki/CA/crl/crl.pem  -noout  -text
;;


*)
  echo  "your input is wrong,please check"
  ;;
esac


unset ip
unset crtname
unset CApath
unset clinetsrq



