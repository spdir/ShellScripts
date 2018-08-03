#!/bin/bash
#Oracle 定时全备脚本
#create or replace directory FULLAMOUNT_BACKUP as '/home/oracle/FullAmount_backup';
#crotab
#  30 00 * * 1 /home/oracle/FullAmount_backup/Oracle_back.sh > /tmp/oralce_FullAmount_backup.log

#清空上次日志备份生成的临时日志文件
echo > /tmp/oralce_FullAmount_backup.log
#切换到数据备份的目录
cd /home/oracle/FullAmount_backup/
#获取当前时间
_NOW_TIME=`date "+%Y-%m-%d"`
#读取最后一次备份的时间
_LAST_HISTORT_TIME=`cat /home/oracle/FullAmount_backup/lastHistory.txt`
#备份demo库
expdp system/system123@orcl schemas=demo directory=FULLAMOUNT_BACKUP dumpfile=demo-${_NOW_TIME}.dmp logfile=demo-${_NOW_TIME}.log

#对最新备份的数据进行打包
mkdir tmp && mv *${_NOW_TIME}* tmp && \
tar czf OracleFullBack-${_NOW_TIME}.tar.gz tmp/* \
&& rm -rf tmp
#删除之前旧的备份
rm -rf OracleFullBack-${_LAST_HISTORT_TIME}.tar.gz
#更新记录最后一个备份时间的文件
echo ${_NOW_TIME} >  /home/oracle/FullAmount_backup/lastHistory.txt