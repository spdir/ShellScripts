#!/bin/bash
#安装JDK
wget http://192.168.1.118/jdk1.7.0_80.tgz
tar zxf jdk1.7.0_80.tgz -C /usr/local
echo 'export JAVA_HOME=/usr/local/jdk1.7.0_80
export JAVA_BIN=$JAVA_HOME/bin
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
' >> /etc/profile

source /etc/profile
java -version