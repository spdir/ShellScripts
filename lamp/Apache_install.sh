#! /bin/bash
#__Auther__="ZhiChao Ma"
#Apache服务安装
#######################[初始化变量]#######################
#Apache源码包的名称
package_name='httpd-2.2.17.tar.gz'	
#Apache源码包解压的路径
package_dir1='/usr/src/'	
#Apache源码包解压的出来的源码文件夹的名称
package_dir2='httpd-2.2.17'
#Apache服务的安装目录
install_dir='/usr/local/httpd'
###########################[END]#################################
#删除rpm安装的httpd包
rpm -e httpd --nodeps &> /dev/null
#编译安装Apache
tar zxf $package_name -C $package_dir1
cd $package_dir1$package_dir2
./configure --prefix=$install_dir --enable-so --enable-rewrite --enable-charset-lite --enable-cig &> /dev/null
make &> /dev/null
make install &> /dev/null
#配置
ln -s ${install_dir}/bin/* /usr/local/bin
cp ${install_dir}/bin/apachectl /etc/init.d/httpd
chmod +x /etc/init.d/httpd
#添加系统服务
sed -i '3i#chkconfig:2345 25 25' /etc/init.d/httpd
sed -i '3a#description:This is Apache Server' /etc/init.d/httpd
chkconfig --add httpd
chkconfig httpd on
#启动服务
${install_dir}/bin/apachectl start &> /dev/null
echo 'Apache install successful'