#!/bin/bash
#
PING() {
ping -c 1 -w 1 $1 &> /dev/null
}


u=0
d=0
for i in {2..255};do
 if PING 192.168.0.$;then
  echo -e "IP: \033[32m192.168.1.$i\033[0m is UP"
  let  u=$[$u+1]
 else
  echo -e "IP: \033[31m192.168.1.$i\033[0m is DOWN"
  let  d=$[$d+1]
 fi
done
  
echo "UP links = $u"
echo "DOWN links = $d"
