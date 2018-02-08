#!/bin/bash
# ----------------+---------------------------------------+
# * Author        : Sunny
# * Email         : ghbsunny@sina.com
# * Create time   : 2017-08-01 
# * Last modified : 2017-08-26 
# * Filename      : reset.sh
# * Description   : set init environment before use system
# * version       : 1.1
# ----------------+---------------------------------------+
#you should remove the PATH var which did not use in /etc/profile after you excute the script for many times
#you should run .bashrc and /etc/profile to active them after run the script

#set var
export time=`date +%Y%m%d%H%M`
export os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`

#config in centos6 & 7

[ -e  /etc/yum.repos.d/repobak ] || mkdir /etc/yum.repos.d/repobak
mv -f /etc/yum.repos.d/*.repo /etc/yum.repos.d/repobak

cd ~
[ -e ~/bakfile ] || mkdir  bakfile
mv  ~/.bashrc  bakfile/.bashrc.$time.bak
[ -e ~/.vimrc ] &&  mv  .vimrc   bakfile/.vimrc.$time.bak
mv   /etc/issue  bakfile/issue.$time.bak
mv   /etc/issue.net  bakfile/issue.net.$time.bak
mv  /etc/motd   bakfile/motd.$time.bak


cat >> ~/.bashrc <<eof
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'
 alias ls='ls --color=auto'
 alias grep='grep --color=auto'
 alias cdnet='cd /etc/sysconfig/network-scripts/'
 alias editrepo='vim /etc/yum.repos.d/sunny.repo'
 alias cdrepo='cd /etc/yum.repos.d/'
 alias cdnfs='cd /nfsfile/share/script'
 alias cdshare='cd /sharedisk/script/'
 export PS1="[\[\e[31;40m\]\u\[\e[37;40m\]@\[\e[34;40m\]\h\[\e[37;40m\] \W]\\\\$\[\e[0m"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi


eof

#set vim edit window
cat >> ~/.vimrc << eof
"if there is quotation mark at the beginnig of line,the line is mark info
"pay attenton,if the new .sh file edit by vim,it will be set by below cmds
"if it is not new .sh file,vim will not effect by below cmds
"new .sh file will be added excuted property
"cursor will be the last line in a new .sh file which edit by vim

set nu
set sm
syntax on
set tabstop=4
set ai 
"set cursorline

autocmd BufNewFile *.sh exec ":call SetTitle()"

func SetTitle()
      if expand("%:e") == 'sh'
      call setline(1,"#!/bin/bash")
      call setline(2,"#")
      call setline(3,"#******************************************************************************")
      call setline(4,"#Author:               Sunny")
#Email:                ghbsunny@sina.com
      call setline(6,"#Date:                 ".strftime("%Y-%m-%d"))
      call setline(7,"#FileName:             ".expand("%"))
      call setline(8,"#version:              1.0")
      call setline(9,"#Your change info:      ")
      call setline(10,"#Description:          For")
      call setline(11,"#DOC URL:               ")
      call setline(12,"#Copyright(C):         ".strftime("%Y")."  All rights reserved")
      call setline(13,"#*****************************************************************************")
      call setline(14,"")
      endif
endfunc

" Define a function that can tell me if a file is executable
 function! FileExecutable (fname)
   execute "silent! ! test -x" a:fname
   return v:shell_error
   endfunction
" Automatically make Perl and Shell scripts executable if they aren't  already
 au BufWritePost *.sh,*.pl,*.cgi if FileExecutable("%:p") | :!chmod a+x %  ^@ endif

autocmd BufNewFile * normal G

eof

#set warn or hint info before login
cat >> /etc/issue <<eof
Alert:This is private machine
machine type:\m     kenernel: \r
tty:    \l     tty count:\u
system: \s     version:  \v
date:   \d     time:     \t
Hostname:    \n
[34m Welcome,Be careful before you commit any cmd [0m
eof
#set warn or hint info when it is login by telnet
cat >>/etc/issue.net<<eof
CentOS release 6.5 (Final)
Kernel \r on an \m
[31m U are login private server!Pay attention! [0m

eof

#set warn or hint info after login
cat >> /etc/motd <<eof
[31m Notice:please backup file before you change any thing[0m
[34m This is private machine![0m
[35m Do not do any harm to the host [0m
eof

#define yum source

yum_source (){

cat >> /etc/yum.repos.d/sunny.repo <<eof
[sunny]
name=sunny-media-yum-source-64
baseurl=file:///media/
gpgcheck=1
enabled=1
gpgkey=file:///media/RPM-GPG-KEY-CentOS-\$releasever

[sohu]
name=sohu-source
baseurl=http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.sohu.com/centos/\$releasever/os/\$basearch/RPM-GPG-KEY-CentOS-\$releasever


[sunnyftp]
name=sunny-build-ftp-for-yum
baseurl=ftp://172.18.254.71/pub/centos/\$releasever/
gpgcheck=1
enabled=0
gpgkey=ftp://172.18.254.71/pub/centos/\$releasever/RPM-GPG-KEY-CentOS-\$releasever

[aliyun]
name=aliyun_epel
baseurl=https://mirrors.aliyun.com/epel/\$releasever/\$basearch
gpgcheck=0
enabled=0

[epel]
name=class_epel
baseurl=http://172.16.0.1/fedora-epel/\$releasever/\$basearch/
enabled=0
gpgcheck=0


eof


}

case $os_version in  
6)

#set alias for edit the net-card
sed -i "/# Source/i alias editnet='vim /etc/sysconfig/network-scripts/ifcfg-eth0'" ~/.bashrc


##set yum warehouse

yum_source;


#close firewall and NM
service NetworkManager stop &>/dev/null;
chkconfig NetworkManager off &>/dev/null;
chkconfig iptables off &>/dev/null;
service iptables stop &>/dev/null;

;;
7)

#set alias for edit net-card
sed -i "/# Source/i alias editnet='vim /etc/sysconfig/network-scripts/ifcfg-ens33'" ~/.bashrc


##set yum warehouse

yum_source;

#close firewall
systemctl disable firewalld.service &>/dev/null
systemctl stop firewalld.service &>/dev/null

;;

esac


#set default user tom,and force tom to change complicate passwd when first login
id tom &>/dev/null || useradd tom &>/dev/null
echo "Pass5678" | passwd --stdin tom &>/dev/null
passwd -e tom &>/dev/nulll


#set PATH

sed -i  's/^export PATH=/#export PATH=/g' /etc/profile
sed -i  '/unset i/ i export PATH=$PATH:/root/script' /etc/profile


##close selinux
/usr/sbin/setenforce 0&>/dev/null;
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

##set auto-mount

sed  -i 's@^/dev/cdrom@#/dev/cdrom@g' /etc/fstab
echo "/dev/cdrom/             /media                  iso9660    defaults        0 0 " >> /etc/fstab
mount -a
##install software
rpm -q tree &> /dev/null || yum -y install tree &>/dev/null;
rpm -q ftp &> /dev/null || yum -y install ftp &>/dev/null;
rpm -q lftp &> /dev/null || yum -y install lftp &>/dev/null;
rpm -q telnet &> /dev/null || yum -y install telnet &>/dev/null;
rpm -q telnet-server &>/dev/null || yum -y install telnet-server &>/dev/null;
rpm -q xinetd &>/dev/null || yum -y install xinetd &>/dev/null;
rpm -q lrzsz &>/dev/null || yum -y install lrzsz &>/dev/null;
rpm -q autofs &>/dev/null || yum -y install autofs &>/dev/null;
rpm -q expect &>/dev/null || yum -y install expect &>/dev/null;
rpm -q mlocate &>/dev/null || yum -y install mlocate &>/dev/null;

#set service which start when boot
chkconfig autofs restart &>/dev/null
chkconfig autofs on &>/dev/null



#unset var

unset os_version
unset time

exit
