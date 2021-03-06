#!/bin/bash
shellpath=$(cd $(dirname $0);pwd)
if [ $# -ne 2 ];then
        echo "Usage:$0 tag sub_host"
        exit 1
fi
hostlist=($2)
res=0
IFS=","
for host in ${hostlist[@]}
do
	declare -A status
	ssh $host "/etc/scripts/link.sh $1" >/etc/scripts/logs/$host@$1 2>&1
	exit_code=$?
        if [ $exit_code -ne 0 ];then
                status=(['host']=$host ['exit_code']=$exit_code [msg]=$(cat /etc/scripts/logs/$host@$1) ['term']='\v')
                hosts_status[$num]=${status[*]}
                num=`expr $num + 1 `
                res=`expr $res + ${status['exit_code']}`
        fi
done
echo "${hosts_status[*]}"
