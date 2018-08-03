#!/usr/bin/env bash
#CentOS 7
#config RabbitMQ node type(m/s)
nodeType="m"
#config rabbitmq host
Master_ip=""
Slave_ip=""
Master_hostname=""
Slave_hostname=""
#config rabbitmq username/password
RabbitMQ_UserName=""
RabbitMQ_Password=""
#-----------------------------------------------------------------------------------------------#
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
yum -y install erlang socat epel-release
if [ ! -f "`pwd`/rabbitmq-server-3.7.4-1.el7.noarch.rpm" ]; then
  wget http://www.hefupal.com:8082/software/rabbitmq-server-3.7.4-1.el7.noarch.rpm --http-user=software --http-passwd=hefupal.software
fi
if [ $? != 0 ];then
  exit
fi
echo "
${Master_ip}    ${Master_hostname}
${Slave_ip}     ${Slave_hostname}
" >> /etc/hosts
yum -y localinstall rabbitmq-server-3.7.4-1.el7.noarch.rpm
systemctl start rabbitmq-server && systemctl enable rabbitmq-server
echo 'REZVGMYZCNSAXMVJOLJG' > /var/lib/rabbitmq/.erlang.cookie
if [ $? != 0 ]; then
	echo -e "\033[31mRabbitMQ Server start filed\033[0m"
	exit
fi
if [ $nodeType == 'm' ];then
  systemctl restart rabbitmq-server
  rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app
  rabbitmqctl add_user ${RabbitMQ_UserName} ${RabbitMQ_Password} && rabbitmqctl set_user_tags ${RabbitMQ_UserName} administrator
  rabbitmq-plugins enable rabbitmq_management
  rabbitmqctl add_vhost pay
  rabbitmqctl set_policy -p / ha-all '^' '{"ha-mode":"all"}'
  rabbitmqctl set_policy -p pay ha-all '^' '{"ha-mode":"all"}'
  rabbitmqctl set_permissions -p / admin  ".*" ".*" ".*"
  rabbitmqctl set_permissions -p pay admin  ".*" ".*" ".*"
elif [ $nodeType == 's' ];then
  systemctl restart rabbitmq-server
  sleep 100
  rabbitmqctl stop_app
  rabbitmqctl reset
  rabbitmqctl join_cluster --ram rabbit@${Master_hostname}
  rabbitmqctl start_app
fi
netstat -anptu | grep 15672 && netstat -anptu | grep 5672
sleep 30
rabbitmqctl cluster_status
