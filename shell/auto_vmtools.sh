#!/bin/bash
wget http://samba.hns.net/other/VMwareTools-9.4.10-2068191.tar.gz
tar -xf /root/VMwareTools-9.4.10-2068191.tar.gz
cd vmware-tools-distrib
./vmware-install.pl << EOF






EOF
