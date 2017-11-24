#!/bin/bash
DiskName='/dev/vg00/lv00'
SnaName='/dev/vg00/databak'
MountDir='/usr/local/mysql/data'
DestBackDir='/back'

lvcreate -s -L 100M -n databak $DiskName
mount -o ro $SnaName $MountDir
tar -zcf mysql+`date +"%y-%m-%d %T"`.tar.gz $DestBackDir
umont $SnaName $MountDir
lvremove $SnaName
