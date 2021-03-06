#!/bin/bash
my_ip="172.16.80.135"
shellpath=$(cd $(dirname $0);pwd)
if [ $# -ne 2 ];then
        echo "Usage:$0 tag sub_host"
        exit 1
fi
hostlist=($2)
res=0
IFS=","
num=0
mkdir -p /etc/scripts/logs
for host in ${hostlist[@]}
do
	if [ "$host" != "$my_ip" ];then
	declare -A status
	#ssh www@$host "/etc/scripts/client_deploy.sh $1" > /etc/scripts/logs/$host@$1 2>&1
	rsync -c -avz --progress /data/release/vnnox/$1/* rsync@$host::vnnox/$1/ --password-file=/etc/rsync.pass > /etc/scripts/logs/$host@$1 2>&1
	exit_code=$?
	if [ $exit_code -ne 0 ];then
		status=(['host']=$host ['exit_code']=$exit_code [msg]=$(cat /etc/scripts/logs/$host@$1) ['term']='\n')
		hosts_status[$num]=${status[*]}
		echo $status
		num=`expr $num + 1 `
		res=`expr $res + ${status['exit_code']}`
	fi
	fi
done
echo "${hosts_status[*]}"
