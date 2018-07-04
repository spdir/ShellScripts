#!/bin/bash
#redis 安装脚本
#config redis type(master/slave)
redis_type=""
redis_master_ip=""
#---------------------------------------------------------------------------------#
iptables -F && iptables-save
yum -y install wget tcl gcc*
if [ ! -f "`pwd`/redis-4.0.9.tar.gz" ]; then
  wget http://download.redis.io/releases/redis-4.0.9.tar.gz
fi
tar zxf redis-4.0.9.tar.gz -C /usr/local
cd /usr/local/redis-4.0.9 && make && make test
echo 512 > /proc/sys/net/core/somaxconn
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl -p
cd /usr/local/redis-4.0.9 && mkdir {bin,etc,logs,data}
rm -rf {00-RELEASENOTES,BUGS,COPYING,MANIFESTO,CONTRIBUTING,INSTALL,README.md,Makefile,deps,tests,utils}
mv {runtest-cluster,runtest,runtest-sentinel} bin/
mv {redis.conf,sentinel.conf} etc/ && cd etc/
if [ ${redis_type} == 'master' ]; then
  wget http://www.hefupal.com:8082/config/redis/redis-master.conf --http-user=software --http-passwd=hefupal.software
  /usr/local/redis-4.0.9/src/redis-server /usr/local/redis-4.0.9/etc/redis-master.conf
  /usr/local/redis-4.0.9/src/redis-cli info replication
else
  wget http://www.hefupal.com:8082/config/redis/redis-slave.conf --http-user=software --http-passwd=hefupal.software
  sed -i "s/slaveof 172.16.56.0 6379/slaveof ${redis_master_ip} 6379/g" redis-slave.conf
  /usr/local/redis-4.0.9/src/redis-server /usr/local/redis-4.0.9/etc/redis-slave.conf
  sleep 30
  /usr/local/redis-4.0.9/src/redis-cli info replication
fi