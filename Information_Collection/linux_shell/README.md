Linux_shell
=============================================================
#  环境准备
`注意：此脚本帮助初学者学习shell脚本使用，此脚本禁止作为商业用途，谢谢合作。`<br>
#脚本入口<br>
#!/bin/bash<br>
#作者：小史<br>
#脚本编写时间：2018年5月10日星期四<br>
# 清屏防止屏幕上东西太多不美观：<br>
        clear<br>
# 定义变量作为高亮输出的变量<br>
    reset_terminal=$(tput sgr0)（屏幕终端重置） <br>
    #$()是执行里面的代码得到的结果
# Echo高亮显示
## 第一种方法输出：
        echo –e 终端颜色 + 显示内容 + 结束后的颜色 <br>
        echo -e '\E[32m' "你好！！！"
## 另一种结束高亮的方法
        echo -e '\E[32m' "你好！！！" $(tput sgr0) <br>
## 还有一种输出高亮的内容
        echo -e '\E[32m' "你好！我为你们豁出去了！！" '\E[0m' <br>
        echo –e “\e[1;35m  jeson say Hi~  \e[1;0m”（闭合颜色） <br>

# 输出解释
    echo –e “\e[1;35m  jeson say Hi~ ” $(tput sgr0) （屏幕终端重置，重置成默认的颜色） <br>
    \033 等价于 \e

# 操作系统的版本
    os=`uname  -o` <br>
    echo -e '\e[1;32m' "操作系统的版本:" $reset_terminal $os <br>
# 操作系统的版本类型
    os_name=`cat /etc/issue |grep  "Server"` <br>
    echo -e '\e[1;32m' "操作系统的版本类型:" $reset_terminal $os_name 
# 操作系统的位数
    architecture=`uname  –m` <br>
    echo -e '\e[1;32m' "操作系统位数:" $reset_terminal $architecture 
# 操作系统的内核版本
    kernerelesase=`uname  -r` <br>
    echo -e '\e[1;32m' "操作系统的内核版本:" $reset_terminal $kernerelesase
# 操作系统的主机名
## 第一种方法：
        hostname=`uname -n`
## 第二种方法：
        hostname=`hostname`
## 第三种方法：
        hostname=`echo $HOSTNAME`
## 命令输出：
        hostname=`uname –n` <br>
        echo -e '\e[1;32m' "操作系统的主机名:" $reset_terminal $hostname
# 操作系统的内网IP地址
## 第一种方法：
        hostname -I
## 第二种方法：
        Hostname –i 是读取了/etc/hosts这个文件
## 第三种方法是正则表达式(NF输出最后一行)：
        ifconfig |grep "inet addr" | grep -vE '127.0.0.1' | awk '{print $2}' | awk -F : '{print $NF}'
## 第四种方法：
        ifconfig | sed -n '2p' | cut -f 2 -d : | awk '{print $1}'
# 命令输出：
    internalip=`hostname –I` <br>
    echo -e '\e[1;32m' "操作系统的内网IP地址:" $reset_terminal $internalip
# 操作系统的DNS
## 命令输出：
        nameservers=`cat /etc/resolv.conf | grep "nameserver" | awk '{print $NF}'` <br>
        echo -e '\e[1;32m' "操作系统的DNS:" $reset_terminal $nameservers
# 判断网络是否通(将错误输出到黑洞中)
    ping -c 2 www.baidu.com &>/dev/null  && echo "Internet:成功" || echo "Internet:失败"
# 当期登录用户数（将用户数放到一个目录然后读取这个目录）
## 第一种方法：
        who>/tmp/who <br>
        echo -e '\E[32m' "当期登录用户数:" $reset_terminal  && cat /tmp/who <br>
        rm -rf /tmp/who
## 第二种写法：
        who=`who` <br>
        echo -e '\E[32m' "当期登录用户数:" $reset_terminal $who
```echo "======================================================================"```
# 获得系统内存
## 一、分析系统的运行状态
        >系统使用的内存和应用使用内存区别
        >>系统使用内存=Total-Free
        >>应用使用内存=Total-(Free+Cached+Buffers)
        >>内存中cache和buffer区别
        >功能 读取策略
        >>Cache	缓存主要用于打开的文件	最少使用原则（LRU）
        >>Buffer	分缓存主要用于目录项、inode等文件系统	先进先出策略
### 总内存获取：
            root@xiaoshi:~# awk '/MemTotal/{print $2}' /proc/meminfo
            2077012
#    空闲内存获取:
#        root@xiaoshi:~# awk '/MemFree/{print $2}' /proc/meminfo
#        1269836
#    合并输出总内存和空闲内存:
#        root@xiaoshi:~# awk '/MemTotal/{print $2}/MemFree/{print $2}' /proc/meminfo
#        2077012
#        1269792
#    计算得出我们的系统内存：
#        system_mem_usages=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}' /proc/meminfo)
#        echo -e '\E[32m'"操作系统使用的内存：" $reset_terminal $system_mem_usages M
#    应用程序使用的内存:
#        应用使用内存=Total-(Free+Cached+Buffers)
#    获取Cached的值
#        第一种方法：
#            root@xiaoshi:~# awk '/Cached/{print $2}' /proc/meminfo
#            439812
#            0
#        第二种方法：
#            root@xiaoshi:~# cat /proc/meminfo | grep Cached
#            Cached:           439812 kB
#            SwapCached:            0 kB
#        第三种方法：
#            root@xiaoshi:~# awk '/^Cached/{print $2}' /proc/meminf#o
#            439812
#    获取Buffers的值
#        root@xiaoshi:~# awk '/Buffers/{print $2}' /proc/meminfo
#        17116
#    获取应用内存
#        root@xiaoshi:~# awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo
#        345.309
#    命令输出：
#        app_mem_usages=`awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cached=$2}/Buffers/{buffers=$2}END{print (total-free-cached-buffers)/1024}' /proc/meminfo `
#        echo -e '\E[32m'"应用程序使用的内存：" $reset_terminal $app_mem_usages M
    #cpu负载均衡的值
#        root@xiaoshi:~# top -n 1 | grep "load average"
#
#        top - 17:31:28 up  3:34,  3 users,  load average: 0.08, 0.02, 0.01
#
#       root@xiaoshi:~# top -n 1 | grep "load average" | awk '{print $10 $11 $12}'
#        0.03,0.02,0.00
#
#        load_average=$(top -n 1 -b |grep "load average" | awk '{print $10 $11 $12}')
#        echo -e '\E[32m'"cpu负载均衡的值：" $reset_terminal $load_average
#        echo "====================================================================="
    #硬盘使用情况的分析
#    命令解释：
#        root@xiaoshi:~# df -h |grep -vE 'Filesystem'
#       tmpfs           203M  6.0M  197M   3% /run
#        /dev/sda1        16G  2.8G   13G  19% /
#        tmpfs          1015M     0 1015M   0% /dev/shm
#        tmpfs           5.0M     0  5.0M   0% /run/lock
#        tmpfs          1015M     0 1015M   0% /sys/fs/cgroup
#        tmpfs           203M     0  203M   0% /run/user/0
#
#        root@xiaoshi:~# df -h |grep -vE 'Filesystem|tmpfs'
#        udev            995M     0  995M   0% /dev
#        /dev/sda1        16G  2.8G   13G  19% /
#
#        root@xiaoshi:~# df -h |grep -vE 'Filesystem|tmpfs' | awk '{print $1 $5}'
#        udev0%
#        /dev/sda119%
#
#        root@xiaoshi:~# df -h |grep -vE 'Filesystem|tmpfs' | awk '{print $1 " " $5}'
#        udev 0%
#        /dev/sda1 19%
#    命令输出：
#        disk_usages=$(df -h |grep -vE 'Filesystem|tmpfs' | awk '{print $1 " " $5}')
#        echo -e '\E[32m'"硬盘使用情况的分析：" $reset_terminal $disk_usages
