#!/bin/bash
#oracle 12c
#主机的内网地址
HostIP=""
OracleUserPasswd=""


yum install -y binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 glibc glibc.i686 glibc-devel glibc-devel.i686 ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libX11 libX11.i686 libXau libXau.i686 libXi libXi.i686 libXtst libXtst.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libxcb libxcb.i686 make nfs-utils net-tools smartmontools sysstat unixODBC unixODBC-devel gcc gcc-c++ libXext libXext.i686 zlib-devel zlib-devel.i686 unzip wget vim
#config hosts
echo "${HostIP}  DB" >> /etc/hosts
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'
setenforce 0
systemctl stop firewalld && systemctl disable firewalld
groupadd oinstall && groupadd dba && groupadd oper && useradd -g oinstall -G dba,oper oracle && echo "$OracleUserPasswd" | passwd oracle --stdin
mkdir -p /data/app/oracle/product/12.2.0/db_1 && chmod -R 775 /data/app/oracle && chown -R oracle:oinstall /data/app
echo "fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
" >> /etc/sysctl.conf  && sysctl -p

echo "oracle   soft   nofile    1024
oracle   hard   nofile    65536
oracle   soft   nproc    16384
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32768
oracle   hard   memlock    134217728
oracle   soft   memlock    134217728
" >> /etc/security/limits.d/20-nproc.conf
echo "session  required   /lib64/security/pam_limits.so
session  required   pam_limits.so
" >> /etc/pam.d/login

echo "if [ $USER = "oracle" ]; then
  if [ $SHELL = "/bin/ksh" ]; then
   ulimit -p 16384
   ulimit -n 65536
  else
   ulimit -u 16384 -n 65536
  fi
fi
" >> /etc/profile

echo '# Oracle Settings
export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_HOSTNAME=DB
export ORACLE_UNQNAME=oriepay
export ORACLE_BASE=/data/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.2.0/db_1
export ORACLE_SID= oriepay
export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
' >> /home/oracle/.bash_profile && source /home/oracle/.bash_profile

unzip /tmp/linuxx64_12201_database.zip -d /tmp
chown -R oracle:oinstall /tmp/database
mkdir /home/oracle/response && cd /home/oracle/response
wget https://gitee.com/spdir/ConfigFile/raw/master/Config/Oracle/db_install.rsp
wget https://gitee.com/spdir/ConfigFile/raw/master/Config/Oracle/dbca_single.rsp
wget https://gitee.com/spdir/ConfigFile/blob/master/Config/Oracle/netca.rsp
chown -R oracle:oinstall /home/oracle/response

#su - oracle -c "/tmp/database/runInstaller -force -silent -noconfig -responseFile /home/oracle/response/db_install.rsp" 1> /tmp/oracle.out && echo -e "\033[42;31moracle starting\033[0m" && cat /tmp/oracle.out
#while true; do
# #  if [ $? == 0 ];then
#     source `cat /tmp/oracle.out  | grep sh | awk -F ' ' '{print $2}' | head -1`
#     source `cat /tmp/oracle.out  | grep sh | awk -F ' ' '{print $2}' | tail -1`
#     su - oracle -c "netca /silent /responsefile /home/oracle/response/netca.rsp"
#     netstat -anptu | grep 1521
#     if [ $? != 0 ];then
#       su - oracle -c "lsnrctl start"
#       if [ $? != 0 ];then
#         exit
#       fi
#     fi
#     #此安装过程会输入三次密码，超级管理员，管理员，库(这些密码也可以在配置文件中写)
#     su - oracle -c "dbca -silent -createDatabase  -responseFile dbca_single.rsp"
#     exit
#   fi
# done
