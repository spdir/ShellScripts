#!/usr/bin/env bash
#install haproxy server
yum -y install openssl openssl-devel pcre pcre-devel zlib wget epel-release
if [ ! -f "`pwd`/haproxy-1.7.5.tar.gz" ]; then
  exit
fi
tar zxf haproxy-1.7.5.tar.gz -C /usr/local/src/
cd /usr/local/src/haproxy-1.7.5/
make TARGET=linux2628 USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_CRYPT_H=1 USE_LIBCRYPT=1 PREFIX=/usr/local/haproxy
make install PREFIX=/usr/local/haproxy
ln /usr/local/haproxy/sbin/haproxy /usr/local/sbin/
mkdir /usr/local/haproxy/{etc,ca}
wget wget http://www.xxx.com:8082/config/other/haproxy.conf --http-user=software --http-passwd=xxx.software -O /usr/local/haproxy/etc/haproxy.conf
