#! /bin/bash
#install codis redis cluster

yum -y install git autoconf wget
#install golang
echo "export GOROOT=/usr/local/go
export GOPATH=/usr/local/codis
export PATH=$PATH:$GOROOT/bin
" >> /etc/profile
source /etc/profile

wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz
tar zxf go1.10.2.linux-amd64.tar.gz -C /usr/local/
go version

#install codis
mkdir -p $GOPATH/src/github.com/CodisLabs && \
cd $_ && git clone https://github.com/CodisLabs/codis.git -b release3.2 && \
cd codis && make
ls


