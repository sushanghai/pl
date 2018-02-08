#!/bin/bash
yum install parted -y
fdisk /dev/sda << EOF
n
p
3


t
3
8e
w
EOF
partx -a -v /dev/sda
pvcreate /dev/sda3
vgextend  VolGroup /dev/sda3
lvextend -L 150g /dev/mapper/VolGroup-lv_root
resize2fs /dev/mapper/VolGroup-lv_root
