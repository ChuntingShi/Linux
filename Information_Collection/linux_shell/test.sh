#!/bin/bash
#author:xiaoshi
#time:2018-05-09

#Screen terminal reset
reset_terminal=$(tput sgr0)
#操作系统的版本
os=`uname -o`
echo -e '\e[1;31m' "操作系统的版本：" $reset_terminal $os
#操作系统的版本类型
os_name=`cat /etc/issue`
echo -e '\e[1;32m' "操作系统版本类型:" $reset_terminal $os_name
#操作系统的位数
architecture=`uname -m`
echo -e '\e[1;33m' "操作系统的位数:" $reset_terminal $architecture
#操作系统的内核版本
kernerelesase=`uname -r`
echo -e '\e[1;34m' "操作系统的内核版本:" $reset_terminal $kernerelesase
#操作系统主机名
hostname=`uname -n`
echo -e '\e[1;35m' "操作系统主机名：" $reset_terminal $hostname
#操作系统的主机IP地址
internalip=`hostname -I`
echo -e '\e[1;36m' "操作系统的主机IP地址：" $reset_terminal $internalip
#操作系统的DNS
nameservers=`cat /etc/resolv.conf |grep "nameserver" | awk '{print $NF}'`
echo -e '\e[1;37m' "操作系统的DNS：" $reset_terminal $nameservers
#判断网络是否通
ping -c 2 www.baidu.com &>/dev/null  && echo -e '\e[1;32m' "Internet:成功" || echo -e '\e[1;31m' "Internet:失败"
#当前登录用户数
who=`who`
echo -e '\E[47m' "当期登录用户数:" $reset_terminal $who
echo "======================================================================="
#获得系统内存
system_mem_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)
echo -e '\E[43m'"操作系统使用的内存：" $reset_terminal $system_mem_usages M
#应用程序使用的内存
app_mem_usages=`awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo `
echo -e '\E[44m'"应用程序使用的内存：" $reset_terminal $app_mem_usages M
#cpu负载均衡的值
load_average=$(top -n 1 -b |grep "load average" | awk '{print $10 $11 $12}')
echo -e '\E[45m'"cpu负载均衡的值：" $reset_terminal $load_average
echo "======================================================================="
#硬盘使用情况的分析
disk_usages=$(df -h |grep -vE 'Filesystem|tmpfs' | awk '{print $1 " " $5}')
echo -e '\E[46m'"硬盘使用情况的分析：" $reset_terminal $disk_usages

