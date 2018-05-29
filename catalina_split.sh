#!/usr/bin/env bash
#crond: 1 0 * * * source /data/pay/catalina_split.sh >> /tmp/bak.log

function split() {
    TOMCAT_LOG_DIR=$1
    TIME=`date "+%Y-%m-%d"`
    cp -p $TOMCAT_LOG_DIR/catalina.out $TOMCAT_LOG_DIR/catalina-$TIME.log
    echo > $TOMCAT_LOG_DIR/catalina.out
}

tomcat_path_array=(
/data/pay/tomcat-auto-8095/logs
......
)

for one_tomcat in "${tomcat_path_array[@]}"
do
  split $one_tomcat
  NOW_TIME=`date "+%Y-%m-%d-%R"`
  echo "[$NOW_TIME]-> $one_tomcat >> OK"
done
echo '--------------------------------------------------------------------------'
