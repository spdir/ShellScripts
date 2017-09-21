#!/bin/bash
#chkconfig: - 99 20
#description: Nginx Service Control Script

PROG="/usr/local/nginx/sbin/nginx"      #主程序路径
PIDF="/usr/local/nginx/logs/nginx.pid"  #PID存放路径

case "$1" in
    start)
        $PROG
        ;;
    stop)
        kill -s QUIT $(cat $PIDF)
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    reload)
        kill -s HUP $(cat $PIDF)
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|reload}"
    exit 1
esac
exit 0
