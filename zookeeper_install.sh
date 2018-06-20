#!/bin/#!/usr/bin/env bash
# zookeeper 集群安装脚本，三台配置一样，将脚本放在三台机器上进行运行即可
#zookeeper install dir >> /usr/local/zookeeper-3.4.9
#data dir >> /data/zookeeper/data
#hostnam: App-a App-b App-c
hostname=''

iptables -F && iptables-save
yum -y install wget net-tools
wget http://192.168.1.118/zookeeper-3.4.9.tar.gz	#这里是自己开的端口，需要自行更换
tar zxf zookeeper-3.4.9.tar.gz -C /usr/local
#创建zookeeper data存放目录
mkdir -p /data/zookeeper/data
#创建zookeeper配置文件
echo "tickTime=2000
initLimit=10
syncLimit=5
clientPort=2181
autopurge.snapRetainCount=500
autopurge.purgeInterval=24
dataDir=/data/zookeeper/data
dataLogDir=/data/zookeeper/logs
server.1=192.168.1.222:2888:3888
server.2=192.168.1.223:2888:3888
server.3=192.168.12.224:2888:3888
" > /usr/local/zookeeper-3.4.9/conf/zoo.cfg
#创建id编号
HOSTNAME=`hostname`
if [ hostnam != '' ]; then
	HOSTNAME=${hostname}
fi
if [ $HOSTNAME = "App-a" ]; then
	echo 1 > /data/zookeeper/data/myid
elif [ $HOSTNAME = "App-b" ]; then
	echo 2 > /data/zookeeper/data/myid
elif [ $HOSTNAME = "App-c" ]; then
	echo 3 > /data/zookeeper/data/myid
fi

#修改zkENV.sh文件
sed -i "s/    ZOO_LOG_DIR=\"\.\"/    ZOO_LOG_DIR=\"\/data\/zookeeper\/logs\"/g" /usr/local/zookeeper-3.4.9/bin/zkEnv.sh
sed -i "s/    ZOO_LOG4J_PROP=\"INFO,CONSOLE\"/    ZOO_LOG4J_PROP=\"INFO,ROLLINGFILE\"/g" /usr/local/zookeeper-3.4.9/bin/zkEnv.sh
#修改zkServer.sh文件
sed -i 's/ZOOBIN="${BASH_SOURCE-$0}"/ZOOBIN=`readlink -f "${BASH_SOURCE-$0}"`/g' /usr/local/zookeeper-3.4.9/bin/zkServer.sh
#修改zkCli.sh文件
sed -i 's/ZOOBIN="${BASH_SOURCE-$0}"/ZOOBIN=`readlink -f "${BASH_SOURCE-$0}"`/g' /usr/local/zookeeper-3.4.9/bin/zkCli.sh
#启动服务
/usr/local/zookeeper-3.4.9/bin/zkServer.sh start
#查看状态
netstat -anput | grep 2181
sleep 100
/usr/local/zookeeper-3.4.9/bin/zkServer.sh status
