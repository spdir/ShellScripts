#!/bin/bash
#__Author__="ZhiChao Ma"
#安装Mysql服务
#初始化当前所处的路径
pwd_dir=`pwd`
#######################[初始化变量]#######################
#mysql源码包的名称
mysql_package_name='mysql-5.5.22.tar.gz'
#cmake源码包的名称
cmake_package_name='cmake-2.8.6.tar.gz'
#mysql安装路径
mysql_install='/usr/local/mysql'
#mysql解压出源码包目录的名称
mysql_package_dir='mysql-5.5.22'
#cmake解压出源码包目录的名称
cmake_pachage_dir='cmake-2.8.6'
#源码包解压存放路径
code_package_dir='/usr/src/'
#安装依赖包的方式rpm(脚本当前目录下需要存在所需的包文件)/yum(需要配置本地yum源,或网络yum源)
<<<<<<< HEAD
install_way='rpm'
=======
>>>>>>> df3500a537a65e89f1f8f7accad61e7b7ad94378
#依赖包的文件名称
subjoin_package_file='ncurses-devel-5.7-3.20090208.el6.x86_64.rpm'
###########################[END]############################

#卸载rpm方式的安装的mysql服务
rpm -e mysql-server --nodeps &> /dev/null
#检查依赖包并对其安装
rpm -q ncurses-devel &> /dev/null
if [ $? -ne 0 ]
then
	if [ $install_way = 'rpm' ]
	then
    	rpm -ih $subjoin_package_fiel --nodeps
    else
    	yum -y install ncurses-devel &> /dev/null
    fi
fi

#编译安装cmake
tar zxvf $cmake_package_name -C $code_package_dir &> /dev/null
cd $code_package_dir$cmake_pachage_dir
./configure &> /dev/null
gmake &> /dev/null
gmake install &> /dev/null
cd $pwd_dir
#编译安装msyql
tar zxf $mysql_package_name -C $code_package_dir &> /dev/null
cd $code_package_dir$mysql_package_dir
cmake -DCMAKE_INSTALL_PREFIX=$mysql_install -DSYSCONFDIR=/etc/ -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWHIT_CHARSETS=all &> /dev/null
make &> /dev/null
make install &> /dev/null
#配置msyql
userdel mysql &> /dev/null
useradd -M -s /sbin/nologin mysql &> /dev/null
chown -R mysql:mysql  $mysql_install &> /dev/null
cp -f ${mysql_install}/support-files/my-medium.cnf /etc/my.cnf
ln -s ${mysql_install}/bin/* /usr/local/bin/
cp ${mysql_install}/support-files/mysql.server /etc/rc.d/init.d/mysqld
chkconfig --add mysqld
chkconfig mysqld on
#初始化mysql
$mysql_install/scripts/mysql_install_db --user=mysql --basedir=$mysql_install --datadir=${mysql_install}/data/ &> /dev/null

service mysqld start &> /dev/null
echo 'mysql install successful'
