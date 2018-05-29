#!/bin/bash
#数据库增量备份日志
#crond：00 00 * * * /home/oracle/shell/rman_bak/rman_backup.sh >/dev/null 2>&1
#dir tree: /home/oracle/shell/rman_ba/full
cd /home/oracle/shell/rman_bak
. /home/oracle/.bash_profile
export ORACLE_SID=oriepay

rman target / log="/home/oracle/shell/rman_bak/rman_backup.log" << eof
run {
delete noprompt backupset;
backup as compressed backupset  incremental level 0  filesperset 1 format '/home/oracle/shell/rman_bak/full/db_0_%d_%s_%t' database ;
sql 'alter system archive log current';
backup current controlfile format '/home/oracle/shell/rman_bak/full/ctl_%d_%s';
backup as compressed backupset  filesperset 50 format '/home/oracle/shell/rman_bak/full/log_%d_%s_%t' archivelog all delete input;
backup spfile format '/home/oracle/shell/rman_bak/full/spfile_%d_%s';
}

eof
