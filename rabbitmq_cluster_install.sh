#!/usr/bin/env bash
#CentOS 7
#config RabbitMQ node type(master/salve)
nodeType="masker"
#config rabbitmq hostname
Master_hostname=""
Slave_hostname=""

systemctl stop firewalld && systemctl disable firewalld
#install erlang
yum -y remove erlang
echo "[rabbitmq-erlang]
name=rabbitmq-erlang
baseurl=https://dl.bintray.com/rabbitmq/rpm/erlang/20/el/7
gpgcheck=1
gpgkey=https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc
repo_gpgcheck=0
enabled=1
" > /etc/yum.repos.d/erlang-19.repo
yum clean all && yum makecache
yum -y install erlang socat
wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.4/rabbitmq-server-3.7.4-1.el7.noarch.rpm
if [ $? != 0 ];then
  exit
fi
yum -y localinstall rabbitmq-server-3.7.4-1.el7.noarch.rpm
systemctl start rabbitmq-server && systemctl enable rabbitmq-server
echo 'REZVGMYZCNSAXMVJOLJG' > /var/lib/rabbitmq/.erlang.cookie
systemctl restart rabbitmq-server

rabbitmqctl add_user admin hefupal && rabbitmqctl set_user_tags admin administrator
rabbitmq-plugins enable rabbitmq_management
rabbitmqctl set_policy -p / ha-all '^' '{"ha-mode":"all"}'
rabbitmqctl set_permissions -p / admin  ".*" ".*" ".*"

if [ $nodeType == 'master' ];then
  rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app
elif [ $nodeType == 'slave' ];then
  sleep 100
  rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl join_cluster rabbit@$Master_hostname && rabbitmqctl start_app
fi

netstat -anptu | grep 15672 && netstat -anptu | grep 5672
sleep 30
rabbitmqctl cluster_status
