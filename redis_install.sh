#!/bin/bash
#redis 安装脚本

yum -y install wget tcl gcc*
wget http://download.redis.io/releases/redis-4.0.9.tar.gz
tar zxf redis-4.0.9.tar.gz -C /usr/local
cd /usr/local/redis-4.0.9 && make && make test
echo 512 > /proc/sys/net/core/somaxconn
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
echo never > /sys/kernel/mm/transparent_hugepage/enabled
sysctl -p