#!/bin/bash

apt-get -y install bc

if [ -n "$1" ];then
  	eth_name=$1
else 
  	eth_name=eth0
fi
if [ -n "$2" ];then
	sen_num=$2
else
	sen_num=5
fi
j=0
i=0
value=0

	send_o=`ifconfig $eth_name | grep bytes | awk '{print $6}' | awk -F : '{print $2}'`
	recv_o=`ifconfig $eth_name | grep bytes | awk '{print $2}' | awk -F : '{print $2}'`
	send_n=$send_o
	recv_n=$recv_o
traffic_fun(){
	send_l=`ifconfig $eth_name | grep bytes | awk '{print $6}' | awk -F : '{print $2}'`
	recv_l=`ifconfig $eth_name | grep bytes | awk '{print $2}' | awk -F : '{print $2}'`
	sleep 1
	send_n=`ifconfig $eth_name | grep bytes | awk '{print $6}' | awk -F : '{print $2}'`
	recv_n=`ifconfig $eth_name | grep bytes | awk '{print $2}' | awk -F : '{print $2}'`
	if [ $value -eq 0 ] ;then
	 	i=`expr 1 + $i`
	else
	 	i=`expr 1 + $i + $value + $sen_num`
	fi
	send_r=`expr $send_n - $send_l`
	recv_r=`expr $recv_n - $recv_l`
	total_r=`expr $send_r + $recv_r`
	send_ra=`expr \( $send_n - $send_o \) / $i`
	recv_ra=`expr \( $recv_n - $recv_o \) / $i`
	total_ra=`expr $send_ra + $recv_ra`
	sendn=`ifconfig $eth_name | grep bytes | awk -F \( '{print $3}' | awk -F \) '{print $1}'`
	recvn=`ifconfig $eth_name | grep bytes | awk -F \( '{print $2}' | awk -F \) '{print $1}'`
	clear
	echo -e "\e[33m========================================================================\e[m\n" | tee -a /tmp/test01
	echo -e "-------------网络流量分析（Network Traffic Analysis）--------------" | tee -a /tmp/test01
	echo  "当前值:   发送速率: $send_r B/s  接收速率: $recv_r B/s  总速率: $total_r B/s"  | tee -a /tmp/test01
	echo  "平均值:   发送速率: $send_ra B/s  接收速率: $recv_ra B/s  总速率: $total_ra B/s"  | tee -a /tmp/test01 
	echo  "总流量:   发送流量 : $sendn 接收流量: $recvn"  | tee -a /tmp/test01
	echo -e "\n" | tee -a /tmp/test01
	diskio_fun
	cpu_fun
	mem_fun
	sleep $sen_num
}


diskio_fun(){
	echo -e "--------------IO性能分析（IO performance analysis）---------------" | tee -a /tmp/test01
	ran=`expr $(($RANDOM%2)) + 2`
	value=`expr $ran - 1`
	bb=`vmstat 1 $ran >/tmp/xxx01 ; cat /tmp/xxx01| tail -n 1 | awk '{print $2}'`
	si=`cat /tmp/xxx01| tail -n 1 | awk '{print $7}'`
	so=`cat /tmp/xxx01| tail -n 1 | awk '{print $8}'`
	bi=`cat /tmp/xxx01| tail -n 1 | awk '{print $9}'`
	bo=`cat /tmp/xxx01| tail -n 1 | awk '{print $10}'`
	wa=`cat /tmp/xxx01| tail -n 1 | awk '{print $16}'`
	bt=`expr $bi + $bo`
	echo -e "等待资源的进程数:$bb  磁盘调入内存:$si  内存调入磁盘:$so  读磁盘:$bi块/s\n写磁盘:$bo块/s  IO等待占用cpu的百分比:$wa"| tee -a /tmp/test01 
	j=`expr $j + 1`
	mod=`expr $j % 30`


	if (( ( $mod == 0 &&  $si != 0 || $so != 0  ) || $bt > 1000 || $wa > 20 || $bb > 4 )) ;then
		echo -e "\e[31mIO性能不好！！！badbadbad\e[m\n" | tee -a /tmp/test01
	else 
		echo -e "\e[32mIO性能正常^ _ ^\e[m\n" | tee -a /tmp/test01
	fi
}


cpu_fun(){
	echo -e "--------------CPU性能分析（CPU performance analysis）--------------" | tee -a /tmp/test01
	cpu_num=`cat /proc/cpuinfo  | grep processor | wc -l`
	rr=`cat /tmp/xxx01| tail -n 1 | awk '{print $1}'`
	us=`cat /tmp/xxx01| tail -n 1 | awk '{print $13}'`
	cs=`cat /tmp/xxx01| tail -n 1 | awk '{print $14}'`
	ts=`expr $us + $cs`
	echo -e "运行或等待cpu时间片的进程数:$rr \n用户进程消耗cpu的时间百分比:$us\n内核进程消耗cpu的时间百分比:$cs\n系统负载参考值:`uptime | awk -F : '{print $5}'`" | tee -a /tmp/test01


	if (( $rr > $cpu_num || $ts > 80 )) ;then
		echo -e "\e[31mcpu资源不足！！！badbadbad\e[m\n" | tee -a /tmp/test01
	else
		echo -e "\e[32mcpu 资源足够 ^ _ ^\e[m\n" | tee -a /tmp/test01
	fi
}


mem_fun(){
	echo -e "-------------内存性能分析（MEM performance analysis）--------------" | tee -a /tmp/test01
	used_mem=`free -m | grep "buffers/cache" | awk '{print $3}'`
	free_mem=`free -m | grep "buffers/cache" | awk '{print $4}'`
	total_mem=`expr $free_mem + $used_mem`
	total_mem=`expr $total_mem`
	mem_usage=$(echo "scale=2;$free_mem/$total_mem*100" | bc -l)
	mem_usage=`echo $mem_usage | awk -F . '{print $1}'`
	echo -e "实际使用的内存:$used_mem"m"  实际剩余的内存:$free_mem"m"" | tee -a /tmp/test01

	if (( $mem_usage <  20 )) ;then
		echo -e "\e[31mMEM资源紧缺！！！badbadbad\e[m\n" | tee -a /tmp/test01
	else
		echo -e "\e[32mMEM资源足够 ^ _ ^\e[m\n" | tee -a /tmp/test01
	fi


}


#while : ; do
	traffic_fun
#done
