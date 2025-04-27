[TOC]

### 查看CPU数量
```bash
# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq
# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l
```

### curl 
- -o 保存结果进自定义名字文件里面
- -x 设置代理
- -l 只返回head信息
- -O 保存结果进文件里面
- -C 断点续传
- -L 请求时跟随链接跳转
- -T 上传文件 curl -T picture.jpg -u 用户名:密码 ftp://www.linux.com/img/
- -H 自定义头信息，例如指定host  -H 'Host: baidu.com'
- -A (or --user-agent): 设置 "User-Agent" 字段.
- -b (or --cookie): 设置 "Cookie" 字段.
- -e (or --referer): 设置 "Referer" 字段.
- -s 静默模式
- -k (or --insecure)不验证证书进行https请求
- --connect-timeout 建立连接超时时间
- -m 数据传输超时时间

```bash
curl -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST http://localhost:3000/data

```

### crontab
1. 配置crontab
    vim /etc/crontab

2. 获取所有的job任务
```bash
for u in `cat /etc/passwd | cut -d":" -f1`;do crontab -l -u $u;done 
# 或者
cd /var/spool/cron && cat *

# and
cat /etc/crontab
```
3. crontab
```bash
* * * * * # 每分钟执行 
0 * * * * # 每小时执行 
0 0 * * * # 每天执行
0 0 * * 0 # 每周执行
0 0 1 * * # 每月执行
0 0 1 1 * # 每年执行
*/5 * * * * # 每5分钟执行 
10,20 * * * * # 每小时的第10和第20分钟执行
10,20 8-11 * * * # 上午8点到11点的第10和第20分钟执行
```

### websocket连通性测试
1. 
apt install node-ws (ubuntu16)
npm install -g wscat (centos)
wscat -c ws://IP:PORT
2. 
游览器
new WebSocket("wss://XXX.XXX.XXX.XXX:9944");

### journalctl
```bash
journalctl -ef -n 100 -p 4
# -e 从末行开始显示
# -f 持续跟进日志
# -u 查看某个Unit的日志
# _PID=1 查看指定进程的日志
# -g 等同于 grep
# --since "2012-10-30 18:17:16"
# -b 0 查看系统本次启动的日志
# -k 查看内核日志（不显示应用日志）
# -p 指定显示的日志级别
#     0: emerg
#     1: alert
#     2: crit
#     3: err
#     4: warning
#     5: notice
#     6: info
#     7: debug

# 检查当前journal使用磁盘量
journalctl --disk-usage
# 日志清理
journalctl --vacuum-time=2d
journalctl --vacuum-size=500M
```

### swap
```bash
# 创建用于交换分区的文件
dd if=/dev/zero of=/swapfile bs=1M count=2048 
# 设置交互分区
mkswap /swapfile 
# 立即启用交换分区文件: 
swapon /swapfile 
#  在 /etc/fstab 中添加如下一行，使之永久生效 
/swapfile swap swap defaults 0 0 
# 查看系统对 SWAP 分区的使用规则，为5则表示内存只剩百分之5时才开始使用swap
cat /proc/sys/vm/swappiness
```

### 虚拟化
1. PV AMI: 半虚拟化
2. HVM: aws目前使用的
3. XEM
4. KVM
- Linux Amazon 系统映像(AMI)使用两种虚拟化类型之一：半虚拟化 (PV) 或硬件虚拟机 (HVM)。

### 压缩
```bash
# 排除某个文件夹 --exclude=${filename}/filename

# 将大文件压缩并拆分成小文件进行打包(用 bzip2 压缩)
tar cjvf - ${filename} | split -b 500m - ${filename}.tar.bz2
# 解压出大文件
cat smallFile.tar.bz2* | tar -jxv

# 用 bzip2 格式压缩文件
tar  cjvf ${filename}.tar.bz2 ./${filename}
# 用 gzip 格式压缩文件
tar  czvf ${filename}.tar.gz ./${filename}
# 用 bzip2 格式解压文件
tar  xjvf ${filename}.tar.bz2 ./${filename}


# xz压缩工具，比gzip格式压缩比更大
# 对于文件夹，先使用tar cvf ${文件名}.tar ./${文件名} 创建${文件名}.tar文件，然后使用xz -zk将tar文件压缩成为.tar.xz文件。
# 先用xz -dk将tar.xz文件解压成tar文件，再用tar文件来解包。
xz -z ${文件名} # 不保留原文件压缩
xz -zk ${文件名} # 保留原文件压缩
xz -d ${文件名} # 不保留原文件解压
xz -dk ${文件名} # 保留原文件解压
# --threads 1 # 指定使用的线程数量
```

### gRPC测试工具
- https://github.com/bojand/ghz
- wget https://github.com/bojand/ghz/releases/download/v0.90.0/ghz-linux-x86_64.tar.gz
- 参数
    - -c 并发数量 default 50
    - -n 总共的请求数量 default 200
    - --call 请求的方法
    - --insecure
    - -m 元数据

### 内核报错
```bash

dmesg -T -w
# -w 等待新消息
# -T 显示易读的时间戳
# -l --level 日志等级  # dmesg --level=err,warn


cat /var/log/messages 
```

### ps & top & lsof 
```bash
# - ps指令的安装 
apt-get install procps

# 查看进程对应的所有线程
ps -T -p ${pid}

# 列出所有线程的pid、启动时间、运行时间
ps -eo pid,lstart,etime,cmd |grep nginx

# 列出所有线程的cpu、内存消耗
ps -A  -o comm,pmem,pcpu | sort | uniq -c | head -15

# 内存消耗从大到小
ps -eo pid,ppid,%mem,%cpu,cmd --sort=-%mem | head
ps -eo pid,ppid,%mem,%cpu,comm --sort=-%mem | head
```
```bash
# top 只显示一次CPU资源使用信息
top -n 1
# 查看所有线程
top -H
# 查看指定进程的所有线程
top -H -p ${pid}
# 
top -c -b -o +%MEM | head -n 20 | tail -15
top -b -o +%MEM | head -n 20 | tail -15
```
```bash
# lsof（list open files）是一个列出当前系统打开文件的工具
lsof  -i @fw.google.com:2150=2180
```

### htop
```bash
# 一个基于ncurses的交互进程查看器
htop
# -C --no-color　　　　 　　 使用一个单色的配色方案
# -d --delay=DELAY　　　　 设置延迟更新时间，单位秒
# -h --help　　　　　　  　　 显示htop 命令帮助信息
# -u --user=USERNAME　　  只显示一个给定的用户的过程
# -p --pid=PID,PID…　　　    只显示给定的PIDs
# -s --sort-key COLUMN　    依此列来排序
# -v –version　　　　　　　   显示版本信息 
```
- 交互式界面从左到右依次各项的含义
    1. PID      表示进程的标识号。
    2. USER     表示运行此进程的用户。
    3. PRI      表示进程的优先级。
    4. NI       表示进程的优先级别值，默认的为0，可以进行调整。
    5. VIRT     表示进程占用的虚拟内存值。
    6. RES      表示进程占用的物理内存值。
    7. SHR      表示进程占用的共享内存值。
    8. S        表示进程的运行状况，R表示正在运行、S表示休眠，等待唤醒、Z表示僵死状态。
    9. %CPU     表示该进程占用的CPU使用率。
    10. %MEM    表示该进程占用的物理内存和总内存的百分比。
    11. TIME+   表示该进程启动后占用的总的CPU时间。
    12. COMMAND 表示进程启动的启动命令名称。

- 交互式界面指令
    1. F1 或者h    查看帮助文档。
    2. F2 或者S    设置htop
    3. / 或者F3    搜索进程。
    4. \ 或者F4    增量进程过滤器。
    5. t 或者F5    显示树形结构。
    6. F6 +,-     按照某个指标进行排序。
    7. ] 或者F7    可提高nice值可以提高对应进程的优先级
    8. [ 或者F8    可减少nice值可以提高对应进程的优先级
    9. k 或者 F9   杀掉进程。
    10. q 或者F10  结束htop。
    11. u         只显示一个给定的用户的进程。
    12. H         显示或隐藏用户线程。
    13. K         显示或隐藏内核线程。
    14. F         跟踪进程。
    15. P         按CPU 使用排序。
    16. M         按内存使用排序。
    17. T         按Time+ 使用排序。

### sysstat
- 分析服务器的性能和资源的使用效率。可以监控CPU、硬盘、网络等数据.
```bash
# 安装
# git://github.com/sysstat/sysstat
apt-get install sysstat
yum -y install sysstat
sar -V
```

```sh
# --human 格式化输出 # --dev=sda 查看指定的块设备
# -d 查看磁盘 # -u 查看CPU # -r 查看内存 # -b 块设备的 I/O
# 每10秒钟输出一次磁盘 I/O 情况，持续输出5次
sar -d 10 --human
```
```sh
# iostat 工具提供CPU使用率及硬盘吞吐效率的数据
# -x 显示扩展统计信息（包括设备的详细IO情况）
# -k 数据单位为 kb
iostat -d -k ${Device}
# pidstat: 关于运行中的进程/任务、CPU、内存等的统计信息
```

```sh
# 用于监控和分析各个进程的资源使用情况，包括 CPU、内存、IO 等
pidstat -d 5 --human

```


### awk
- 概览
    - 字段 Item
    - 记录 Record
```bash
# 内置变量
# FS：输入Item分隔符，默认为空白字符
# OFS：输出Item分隔符，默认为空白字符
# RS：输入Record分隔符，默认为\n
# ORS：输出Record分隔符，默认为\n

# NF：当前当前 Record 的 Item 的个数
# NR：当前处理的 Record 的行号

# FNR：Record的数量
# FILENAME：当前文件名
# ARGC：命令行参数的个数

# 指定分隔符
awk -v FS=":" '{print $3}'

awk 'NR==5 {print}'  # awk 打印第 5 行内容
awk 'END {print}'  # awk 打印最后一行内容

# 替换操作 = sed 's/one/two'
awk '{sub(/one/,"two");print}'
# 过滤操作 = grep -E 'one|two'
awk '(/one|two/)'

# 求$1平均值
awk '{sum+=$1} END {print "Average = ", sum/NR}'
# 求$1最大值
awk 'BEGIN {max = 0} {if ($1>max) max=$1 } END {print "Max=", max}'
# 求$1最小值
awk 'BEGIN {min = 1999999} {if ($1<min) min=$1} END {print "Min=", min}'

# 统计各个IP的访问量，并排序
awk '{list[$1]++}END{for(i in list) print i,list[i] }' ip.list | sort -n -r -k 2n
awk '{list[$1]++}END{for(i in list) print list[i],i }' ip.list | sort -n -r -k 2n

# 统计每日es的数据量(初略) /_cat/indices?v&s
awk '/20210708|2021.07.08/&&$10~/gb/ {print; sub(/gb/,"",$10); total=total+$10; i++;print} END{printf"num=%d size=%dgb\n",i,total}'
# 统计每日es的数据量(详细)2
cat data.txt | awk '/20210703|2021.07.03/&&$10~/mb|gb/&&$3!~/es_/  \
{i++; \
if($10~/gb$/){print $0;sub(/gb/,"",$10);total=total+$10*1024}  \
else{sub(/mb$/,"",$10); total+=$10}  \
} \
END{printf"num=%d size=%fgb\n",i,total/1024}'
```

### 数学计算
```bash
echo "2/3" | bc -l
# scale=3 保留几位小数
echo "scale=3; ${num}*5/60/60" | bc -l
```

### taskset CPU隔离
- taskset 设置和查看CPU和进程间的亲和性
```bash
# 查看线程和CPU间的亲和性
taskset -p ${PID}
# ffffffffffffffffff 表示可以使用任意的CPU逻辑核

# 查看进程的CPU亲和性范围
taskset -cp ${PID}

# 查看进程内的所有线程可以使用的CPU范围
taskset -acp ${PID}

# 设置线程的CPU亲和性为指导的CPU逻辑核
start=0
end=3
taskset -cp ${start}-${end}  ${PID} # start到end
taskset -cp ${start},${end}  ${PID} # start核和end核
taskset -c ${start}-${end}  ${Command} # start到end

# -p 通过${PID}查看指定的线程
# -c 查看线程可以使用的CPU范围
# -a 获取给定进程pid的所有线程的cpu亲和性。
```

```bash
# 参考 http://t.csdn.cn/iUoHT

# 一 隔离CPU，避免其它线程run在被隔离的CPU上。(作用于用户态上)
# 修改Linux内核的启动参数isolcpus。 isolcpus将从线程调度器中移除选定的CPU，这些被移除的CPU称为"isolated" CPU。若想要在被隔离的CPU上run进程，必须调用CPU亲和度相关的syscalls。
vim /etc/default/grub # redhat vim/boot/grub/grub.conf
# GRUB_CMDLINE_LINUX="isolcpus=0,1,2,3,4,5,6"
GRUB_CMDLINE_LINUX="isolcpus=0-34,40-79"
# 更新/boot/grub/grub.cfg文件 # 查看 /boot/grub/grub.cfg 的时间戳验证是否更新成功
update-grub # grub-mkconfig -o /boot/grub/grub.cfg # 或者重启

# 二 被隔离的CPU虽然没有线程run在上面，但是仍会收到interrupt。绑定所有的interrupts到非隔离的CPU上，避免被隔离的CPU收到interrupt。(作用于内核态上)

# 三 把特定的线程绑定到某一被隔离的CPU上。(作用于用户态上)
# 通过taskset指定CPU亲和性

```

### screen
- screen 窗口退出后会继续运行在后台，可以替代nohup
```bash
# 创建一个screen
screen -l
# 创建一个screen，并进行命名
screen -S  ${screenName}
# 查看已经存在的screen
screen -ls
# 切换到某个screen
screen -r ${screenName}

# -m 强制创建一个新的 screen 会话，即使当前已经有同名的会话存在。
# -d 以“分离模式”（detached mode）运行，会话会在后台启动，不会附加到当前终端。

# -L：开启日志记录
# -Logfile mylog.txt：指定日志文件名（默认是 screenlog.0）
screen -L -Logfile mylog.txt -S ${screenName}


# 将screen切回后台: Ctr+a 按下后再按下d
```

## 未归类
获取公网IP ： 
curl cip.cc 
curl ipinfo.io

查看CentOS版本 cat /etc/issue 或者 cat /etc/redhat-release 
查看Ubunto版本 cat /etc/lsb-release

yum install bind-utils -y 此软件含nslookup指令

进入容器
docker inspect -f {{.State.Pid}} 容器名或者容器id  
nsenter  -n --target  PID名称


linux环境测网速
curl -O https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py


netstat apt-get install net-tools


```bash
# 只要./test.lock的当前状态未被外部改变，其它flock ./test.lock的就执行失败，直到当前的flock执行结束
flock -xn ./test.lock -c "sh ./test.sh"
-n # 非阻塞模式，当获取锁失败时，返回1而不是等待
-x -e  # 获取一个排它锁，或者称为写入锁，为默认项
```

查看内核报错
- 参考
https://blog.csdn.net/zhaohaijie600/article/details/45246569 
```log
php-fpm-7.1[60143]: segfault at 0 ip 00007fbc4e998ff1 sp 00007ffe5b9c3238 error 4 in libc-2.17.so[7fbc4e82a000+1c3000]
```
1. 程序名  php-fpm-7.1
2. 线程PID  60143
3. 标识应该是由内存访问越界造成的  segfault  
4. 具体的错误  error 4
    1. error 4 转为二进制 error 100
    2. error ${bit2}${bit1}${bit0}
        1. bit2: 值为1表示是用户态程序内存访问越界，值为0表示是内核态程序内存访问越界. 
        2. bit1: 值为1表示是写操作导致内存访问越界，值为0表示是读操作导致内存访问越界.
        3. bit0: 值为1表示没有足够的权限访问非法地址的内容，值为0表示访问的非法地址根本没有对应的页面，也就是无效地址.
    

查看/tmp目录下每个子目录文件的数量
for i in /tmp; do echo $i; find $i |wc -l|sort -nr; done


除特定文件外删除所有
rm -rf !(.a|.|..)


ping 缺失
apt-get install iputils-ping

```bash
# 遍历获取 Linux 某目录下所有子目录及文件信息
find . -print0 | xargs -0 stat --printf="%f %N %W %Y %s\n"
# 删除7天前被修改的文件，不能省略分号   -f指文件 -d指目录   
find ./ -type f  -mtime +7 -exec rm -rf {} \;
# 将7天内修改的文件移进新文件夹
find ./ -type f -mtime -7 | xargs -I file mv file ./new

```

```bash
sed -i "s/project-perform/project-prd/g" `find ./ | grep yaml`
# 替换以字符串name开头的行
var='gary'
sed -i "/^name/c\name=$var" 文件名
```

- 删除Evicted状态的Pod
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod


- 查看网络连接
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'


- 查看某个节点的所有pod的top
```bash
nodename=XXXX
kubectl get pods -o wide | grep ${nodename} | awk {'print $1'} | xargs -n1 kubectl top pods --no-headers

# xargs 详解
# -d 指定分隔符
# -p 等待输入yes后才执行一条语句
```

```bash
# 默认参数为 -15

# 重新加载进程
kill -1 ${PID} 
kill -s HUP ${PID}

# 中断进程（同 Ctrl + c）
kill -2 ${PID}

# 退出进程（同 Ctrl + \） 进程各个线程的堆栈信息被保存进 /proc/${pid}/cwd/antBuilderOutput.log
kill -3 ${PID}
kill -s QUIT ${PID}

# 杀死进程。进程立刻被关闭，运行中的数据将丢失。
kill -9 ${PID} 
kill -KILL ${PID} 

# 终止进程。进程可以用一段时间来正常关闭，一个程序的正常关闭一般需要一段时间来保存进度并释放资源。
kill -15 ${PID} 
```


- linux系统语言中英文切换
    ```bash
    # 永久切换
    vim /etc/locale.conf # 或者 vim /etc/sysconfig/i18n
    # 然后更改配置 LANG=en_US.UTF-8 或者 LANG=zh_CN.UTF-8
    source /etc/locale.conf

    # 临时切换
    export LANG="zh_CN.UTF-8" # 中文
    export LANG="en_US.UTF-8" # 英文
    ```

- cpu负载，cpu使用率
    ```bash
    ps -aux
    # 系统中可运行（R）和不可中断（D）进程
    # R：正在CPU上运行或者正在等待CPU的进程状态
    # D：不可中断是指一些正在处于内核关键流程的进程，如果盲目打断，会造成不可预知的后果，比如正在写磁盘的进程，盲目被打断，可能会造成读写不一致的问题。
    CPU的使用率 = 单位时间内CPU执行任务的时间 / 单位时间
    CPU平均负载 = 特定时间内运行队列中的平均进程数量（可运行状态和不可中断状态的进程）
    ```

### 排查问题
- dmesg 并发量太大导致三次握手时超过资源限制，需要调整内核参数
```log
SYN flooding on port 80. Sending cookies.  Check SNMP counters.
```

### 休眠问题
```bash
# 关掉所有的休眠服务
systemctl mask sleep.target suspend.target hibernate.target hybridsleep.target
```


### grep
```bash
# -E 使用正则表达式
# -i 忽视大小写
# -v 取反
```

- 通过主线程名字查看所有子线程
    - ps -ef | grep ${process_name} | grep -v grep | awk '{print $2}' | xargs ps -T -p


### jq
```bash
jq .元素名字.元素名字
jq .[数组索引]
jq '.元素名字.元素名字 | .[数组索引]'
jq -r # 输出字符串原始值而不是字符串 JSON 序列化后的值
```

### linux默认编辑器
```bash
# 更改默认编辑器 方式一
update-alternatives --config editor 
# 更改默认编辑器 方式二
select-editor
# 临时更改默认编辑器
export EDITOR="/usr/bin/vim"
```

### iotop 进程IO监控
```bash
iotop -oP 
# -o 只显示有I/O行为的线程
# -P 只显示进程
```

### 日志颜色
```bash
apt install expect
# 保留日志的颜色进文件内
unbuffer 可执行程序 >> log
unbuffer 可执行程序 | tee log
```

### prlimit 
- prlimit 这个命令用来设置或者获取某进程的资源限制数.

```bash
# 查看pid为9999的进程的可打开的文件数
prlimit --pid=9999

# 设置pid为9999的进程的可打开的文件最大数为102400(soft & hard)
prlimit --pid=9999 --nofile=102400:102400
```

### linux和windows
```bash
# Windows 和 Linux 之间文本格式转换
# yum install -y dos2unx
dos2unix ${filename}
```

### 升级内核
```bash
# Update and upgrade existing packages
sudo apt update && sudo apt full-upgrade -y

# Install a newer kernel version, example for Ubuntu 20.04
# sudo apt install --install-recommends linux-generic-hwe-20.04 -y

# Reboot the system
# sudo reboot

dpkg --configure -a; apt --fix-broken install -y; DEBIAN_FRONTEND=noninteractive apt install --install-recommends linux-generic-hwe-20.04 -y && reboot
```

### linux 命令
1. selinux
```bash
# 查看当前selinux功能情况
sestatus -v
# 1永久改变selinux的状态（重启后生效）
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/#&/' /etc/selinux/config
# 2临时改变selinux的状态
setenforce 0
```

## 增加用户
```sh
# 自动在/home目录下会自动创建同名文件夹
# 自动创建同名用户组
# /bin/bash
adduser ${用户名}

# /bin/sh
useradd ${用户名}

# 删除用户
userdel  -r  ${用户名}
```



# Unix命令行程序和内建指令
文件系统	
▪ cat	▪ cd	▪ chmod	▪ chown
▪ chgrp	▪ cksum	▪ cmp	▪ cp
▪ du	▪ df	▪ fsck	▪ fuser
▪ ln	▪ ls	▪ lsattr	▪ lsof
▪ mkdir	▪ mount	▪ mv	▪ pwd
▪ rm	▪ rmdir	▪ split	▪ touch
▪ umask			
程序	
▪ at	▪ bg	▪ chroot	▪ cron
▪ exit	▪ fg	▪ jobs	▪ kill
▪ killall	▪ nice	▪ pgrep	▪ pidof
▪ pkill	▪ ps	▪ pstree	▪ sleep
▪ time	▪ top	▪ wait	
使用环境	
▪ env	▪ finger	▪ id	▪ logname
▪ mesg	▪ passwd	▪ su	▪ sudo
▪ uptime	▪ w	▪ wall	▪ who
▪ whoami	▪ write		
文字编辑	
▪ awk	▪ comm	▪ cut	▪ ed
▪ ex	▪ fmt	▪ head	▪ iconv
▪ join	▪ less	▪ more	▪ paste
▪ sed	▪ sort	▪ strings	▪ talk
▪ tac	▪ tail	▪ tr	▪ uniq
▪ vi	▪ wc	▪ xargs	
Shell 程序	
▪ alias	▪ basename	▪ dirname	▪ echo
▪ expr	▪ false	▪ printf	▪ test
▪ true	▪ unset		
网络	
▪ inetd	▪ netstat	▪ ping	▪ rlogin
▪ netcat	▪ traceroute		
搜索	
▪ find	▪ grep	▪ locate	▪ whereis
▪ which			
杂项	
▪ apropos	▪ banner	▪ bc	▪ cal
▪ clear	▪ date	▪ dd	▪ file
▪ help	▪ info	▪ size	▪ lp
▪ man	▪ history	▪ tee	▪ tput
▪ type	▪ yes	▪ uname	▪ whatis