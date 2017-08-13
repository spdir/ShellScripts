#!/bin/bash
#__Auther__="ZhiChao Ma"
#LAMP环境搭建

#安装Apache服务
bash Apache_install.sh
#安装mysql数据库
bash Mysql_install.sh
#初始化工作目录
pwd_dir=`pwd`
#######################[初始化变量]#######################
#mysql安装目录
mysql_install_dir='/usr/local/mysql'
#Apache安装目录
apache_install_dir='/usr/local/httpd'
#php源码包名称及解压出的文件夹名称
php_package_name='php-5.3.28.tar.gz'
php_code_package_dir='php-5.3.28'
#源码的解压路径
package_dir='/usr/src/'
#PHP的安装路径
php_install_dir='/usr/lcoal/php'
#phpMyAdmin源码包的名称
phpMyAdmin_package_name='phpMyAdmin-4.2.5-all-languages.tar.gz'
phpMyAdmin_code_package_dir='phpMyAdmin-4.2.5-all-languages'
#依赖包文件名称
subjoin_package_file1='zlib-devel-1.2.3-29.el6.x86_64.rpm'
subjoin_package_file2='libxml2-devel-2.7.6-14.el6.x86_64.rpm'
#扩展工具包
libmcrypt_package='libmcrypt-2.5.8.tar.gz'
libmcrypt_dir='libmcrypt-2.5.8'
mhash_package='mhash-0.9.9.9.tar.gz'
mhash_dir='mhash-0.9.9.9'
mcrypt_package='mcrypt-2.6.8.tar.gz'
mcrypt_dir='mcrypt-2.6.8'
#ZendGuardLoader优化模块
ZendGuardLoader_package='ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz'
ZendGuardLoader_package_dir='ZendGuardLoader-php-5.3-linux-glibc23-x86_64'
###########################[END]#################################

#检查依赖包
rpm -q zlib-devel &> /dev/null
if [ $? -ne 0 ]
then
    rpm -ivh $subjoin_package_file1 --nodeps &> /dev/null
fi

rpm -q libxml2-devel &> /dev/null
if [ $? -ne 0 ]
then
    rpm -ivh $subjoin_package_file2 --nodeps &> /dev/null
fi
#卸载rpm方式安装的php包
rpm -e {php,php-cli,php-ldap,php-common,php-mysql} --nodeps &> /dev/null
#编译安装libmcrypt
tar zxf $libmcrypt_package -C $package_dir &> /dev/null
cd $package_dir$libmcrypt_dir
./configure &> /dev/null
make &> /dev/null
make install &> /dev/null
ln -s /usr/local/lib/libmcrypt.* /usr/bin/ &> /dev/null
cd $pwd_dir
#编译安装mhash
tar zxf $mhash_package -C $package_dir &> /dev/null
cd $package_dir$mhash_dir
./configure &> /dev/null
make &> /dev/null
make install &> /dev/null
ln -s /usr/local/lib/libmhash.* /usr/lib/ &> /dev/null
cd $pwd_dir
#编译安装mycrpt
tar zxf $mcrypt_package -C $package_dir &> /dev/null
cd $package_dir$mcrypt_dir
./configure &> /dev/null
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
./configure &> /dev/null
make &> /dev/null
make install &> /dev/null
cd $pwd_dir
#编译安装php
tar zxf $php_package_name -C $package_dir &> /dev/null
cd $package_dir$php_code_package_dir
./configure --prefix=$php_install_dir --with-mcrypt --with-apxs2=${apache_install_dir}/bin/apxs --with-mysql=$mysql_install_dir --with-config-file-path=$php_install_dir --enable-mbstring 	--enable-sockets &> /dev/null
make &> /dev/null
make install &> /dev/null
cp -f ${package_dir}${php_code_package_dir}/php.ini-development  ${php_install_dir}/php.ini 
cd $pwd_dir
#添加ZendGuardLoader优化模块
tar zxf $ZendGuardLoader_package -C $package_dir &> /dev/null
cp -f ${package_dir}${ZendGuardLoader_package_dir}/php-5.3.x/ZendGuardLoader.so ${php_install_dir}/lib/php/
#配置php.ini文件
sed -i 's/;default_charset = "iso-8859-1"/default_charset = "utf-8"/g' ${php_install_dir}/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' ${php_install_dir}/php.ini
echo "zend_extendsion=${php_install_dir}/lib/php/ZendGuardLoader.so" >> ${php_install_dir}/php.ini
echo 'zned_loader=1' >> ${php_install_dir}/php.ini
#配置httpd.conf文件
sed -i 's/     DirectoryIndex index.html/     DirectoryIndex index.php index.html/g' ${apache_install_dir}/conf/httpd.conf
sed -i '309aAddType application/x-httpd-php .php' ${apache_install_dir}/conf/httpd.conf
#部署phpMyAdmin
tar zxf $phpMyAdmin_package_name -C $package_dir &> /dev/null
mv $package_dir$phpMyAdmin_code_package_dir ${apache_install_dir}/htdocs/phpMyAdmin
cp -f ${apache_install_dir}/htdocs/phpMyAdmin/config.sample.inc.php ${apache_install_dir}/htdocs/phpMyAdmin/config.inc.php
#重新启动服务
service httpd stop &> /dev/null
sleep 1
service httpd start &> /dev/null
echo 'LAMP环境搭建成功'