#!/bin/bash
#auth csa
#usage: for example ,the qpid progress takes up to use mem: "bash single_progress_mem_used.sh qpidd"
#实现程序单进程或多进程内存使用情况查看，和模糊匹配查某一类进程使用内存情况

daemon_name="$1"
#get progress pid
get_progress_pid(){
	pid_num=`ps -ef| grep $daemon_name|grep -v "$0"| grep -v grep|awk '{print $2}'|xargs`
}

#one program has one-progress or one program has multi-progress
get_progress_mem(){
	mem_list=""
	get_progress_pid
	for k in `echo "$pid_num"`
	do
		mem=`cat /proc/$k/status | grep VmRSS |awk '{print $2}'`
		mem_list="$mem $mem_list"
	done
	sum_usedmem=`echo "$mem_list" | awk 'BEGIN{sum=0}{for(i=1;i<=NF;i++)sum+=$i}END{print sum}'`
	sum_usedmem=`awk "BEGIN{print $sum_usedmem*1000}"`
	#the unit is B
	echo "mem_useage:$sum_usedmem"
}

get_progress_mem
