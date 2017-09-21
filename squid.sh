#!/bin/bash
#chkconfig: 2345 90 25     #可以使用-，-的意思是所有运行级别
#description: Squid - Internet Object Cache
#Author:ZhiChaoMa
#config: /etc/squid.conf
#pidfile: /usr/local/squid/var/run/squid.pid  


PID="/usr/local/squid/var/run/squid.pid"   #程序运行才会有pid文件，反之则无 
CONF="/etc/squid.conf"
CMD="/usr/local/squid/sbin/squid"

case "$1" in
    start)
        netstat -anpt | grep squid $> /dev/null
        if [ $? -eq 0 ]
            then
                echo "Squid is running"
            else
            $CMD
        fi
        ;;
    stop)
        $CMD -k kill $> /dev/null       #调用squid命令停止服务
        rm -rf $PID $> /dev/null        #删除pid文件
        ;;
    status)
        [ -f $PID ] &> /dev/null        #检测pid文件是否存在
        if [ $? -eq 0 ]                 #假如文件存在则0等于0，执行netstat命令展示端口
            then
                netstat  -aupt | grep squid
            else
                echo "Squid is not running"
        fi
        ;;
    restart)
        $0 stop $> /dev/null            #注意：$0 stop的意思是调用之前定义的stop
        echo "正在关闭Squid..."
        $0 start $> /dev/null
        echo "正在启动Squid..."
        ;;
    reload)
        $CMD -k reconfigure             #重新加载,但不中断服务，配置更改后，建议用这种方式加载
        ;;
    check)
        $CMD -k parse                   #检查配置文件语法是否错误
        ;;
    *)
        echo "用法：$0 {start | stop | restart | reload | check | status}"   # $0代表脚本名字/etc/squid.conf的用法
        ;;
esac
