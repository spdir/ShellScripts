#!/bin/bash
#redis 安装脚本

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
