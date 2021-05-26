

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
-o 保存结果进自定义名字文件里面
-x 设置代理
-l 只返回head信息
-O 保存结果进文件里面
-C 断点续传
-L 请求时跟随链接跳转
-T 上传文件 curl -T picture.jpg -u 用户名:密码 ftp://www.linux.com/img/
-H 自定义头信息，例如指定host  -H 'Host: baidu.com'
-A (or --user-agent): 设置 "User-Agent" 字段.
-b (or --cookie): 设置 "Cookie" 字段.
-e (or --referer): 设置 "Referer" 字段.
-s 静默模式
-k (or --insecure)不验证证书进行https请求

### crontab
1. 配置crontab
    vim /etc/crontab

2. 获取所有的job任务
```bash
for u in `cat /etc/passwd | cut -d":" -f1`;do crontab -l -u $u;done 
# 或者
cd /var/spool/cron && cat *
```
3. crontab
```bash
* * * * * # 每分钟执行 

0 * * * * # 每小时执行 

0 0 * * * # 每天执行

0 0 * * 0 # 每周执行

0 0 1 * * # 每月执行

0 0 1 1 * # 每年执行

10,20 * * * * # 每小时的第10和第20分钟执行

10,20 8-11 * * * # 上午8点到11点的第10和第20分钟执行
```

### 磁盘
1. 查看所有块设备信息 lsblk -m
2. 打印磁盘信息 blkid 
3. 查看磁盘分区
cat /proc/partitions
lsblk
fdisk -l

### shell
- 变量的提取和替换
```bash
${var#*/} # 去掉变量var从左边算起的第一个'/'字符及其左边的内容
${var##*/} # 去掉变量var从左边算起的最后一个'/'字符及其左边的内容
${var%/*}
${var%/*}
for name in `ls *.Linux`;do mv $name ${name%.*};done
```
- 判断符号
```
-e filename 如果 filename存在，则为真
-d filename 如果 filename为目录，则为真 
-f filename 如果 filename为常规文件，则为真
-L filename 如果 filename为符号链接，则为真
-r filename 如果 filename可读，则为真 
-w filename 如果 filename可写，则为真 
-x filename 如果 filename可执行，则为真
-s filename 如果文件长度不为0，则为真
-h filename 如果文件是软链接，则为真
filename1 -nt filename2 如果 filename1比 filename2新，则为真。
filename1 -ot filename2 如果 filename1比 filename2旧，则为真。
-eq 等于
-ne 不等于
-gt 大于
-ge 大于等于
-lt 小于
-le 小于等于
```

### 设置时区 
timedatectl list-timezones |grep Shanghai    # 查找中国时区的完整名称
timedatectl set-timezone Asia/Shanghai # 临时设置，重启后失效
ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

### websocket连通性测试
1. 
apt install node-ws (ubuntu16)
npm install -g wscat (centos)
wscat -c ws://IP:PORT
2. 
游览器
new WebSocket("wss://XXX.XXX.XXX.XXX:9944");

### journalctl
journalctl -ef -n 100 -p 4
--since "2012-10-30 18:17:16"
-b 0 查看系统本次启动的日志
-k 查看内核日志（不显示应用日志）
-u 查看某个Unit的日志
_PID=1 查看指定进程的日志
-p 指定显示的日志级别
    0: emerg
    1: alert
    2: crit
    3: err
    4: warning
    5: notice
    6: info
    7: debug

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

### 公钥
扫描其它机器的公钥：ssh-keyscan
生成公钥：ssh-keygen -C "备注信息"
authorized_keys   id_rsa  id_rsa.pub  know_hosts
authorized_keys,并修改 authorized_keys 权限为 600,当前目录权限为 700


### 将大文件压缩并拆分成小文件
tar czf - test | split -b 500m - test.tar.bz2
cat test.tar.bz2* | tar -jxv

### ssh-agent
- 参考 https://wiki.archlinux.org/index.php/SSH_keys_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

- 普通登入方式 ssh -i 私钥文件路径 ${username}@${ip}
- ssh-agent 是一个代理程序，它能帮助我们管理我们的私钥
- ssh-add 把私钥密钥添加到ssh-agent的高速缓存中
```bash
eval $(ssh-agent) # ssh-agent bash --login -i  # ssh-agent bash
# 将私钥添加到高速缓存中
ssh-add -k 私钥文件路径
```

### systemctl
/usr/lib/systemd/system/XXXXX.service
```
[Unit]
Description=XXXXX
Documentation=XXXXX
After=network.target

[Service]
User=myuser
Group=myuser

Type=simple
Environment="变量名=变量值"
ExecStart=/bin/sh -c -- "/usr/bin/java -jar /opt/application/XXXXX/XXXXX.jar 1>> /opt/application/XXXXX/logs/XXXXX.out.log 2>> /opt/application/XXXXX/logs/XXXXX.err.log"
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### supervisorctl
1. Supervisor（http://supervisord.org/）是用Python开发的一个client/server服务，是Linux/Unix系统下的一个进程管理工具，不支持Windows系统。它可以很方便的监听、启动、停止、重启一个或多个进程。用Supervisor管理的进程，当一个进程意外被杀死，supervisort监听到进程死后，会自动将它重新拉起。
2. 安装

3. 启动Supervisor服务
supervisord -c /etc/supervisord.conf
4. 进入交互界面
supervisorctl

### linux select 指令建立菜单
```bash
#!/bin/bash 

fruits=( 
"apple" 
"pear" 
"orange" 
"watermelon" 
) 

# echo "Please guess which fruit I like :" 
# select var in ${fruits[@]} 
# do 
# if [ $var = "apple" ]; then 
#     echo "Congratulations, you are my good firend!" 
#     break 
# else 
#     echo "Try again!" 
# fi 
# done 

select var in ${fruits[@]} 
do 
case $var in
    "apple"|"pear"|"orange") echo "123";break;
    ;;
    "watermelon")
    echo "4" 
    ;;
    *)
    echo "5"
    exit 1 
    ;; 
esac
done 

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


cat /var/log/messages 
```

### ps & top & lsof 
- ps指令的安装 
    - apt-get install procps
- 
ps -eo pid,lstart,etime,cmd |grep nginx

- 列出所有线程的cpu、内存消耗
ps -A  -o comm,pmem,pcpu | sort | uniq -c | head -15

- 内存消耗从大到小
    - ps -eo pid,ppid,%mem,%cpu,cmd --sort=-%mem | head
    - ps -eo pid,ppid,%mem,%cpu,comm --sort=-%mem | head

    - top -c -b -o +%MEM | head -n 20 | tail -15
    - top -b -o +%MEM | head -n 20 | tail -15

- lsof（list open files）是一个列出当前系统打开文件的工具

    - lsof  -i @fw.google.com:2150=2180

### awk
```bash
awk 'BEGIN{ORS="\n"}{print $0}'
# ORS 输出时的结束符，默认为\n
```

### 脚本
1. 循环日期
```bash
#!/bin/bash
startDate=20210401
endDate=20230401
startSec=`date -d "$startDate" "+%s"`
endSec=`date -d "$endDate" "+%s"`
for((i=$startSec; i<=$endSec; i+=86400))
do
    firstday=`date -d "@$i" "+%Y%m%d"`
    echo ${firstday}
    # y=$[$i+86400]
    # secondday=`date -d "@$y" "+%Y%m%d"`
    # echo ${secondday}
done
```

## 未归类
获取公网IP ： 
curl cip.cc 
curl ipinfo.io

scp  -i 指定密钥文件  -C 允许压缩 源文件  目的地址

查看CentOS版本 cat /etc/issue 或者 cat /etc/redhat-release 
查看Ubunto版本 cat /etc/lsb-release

yum -y install openssh-clients 此软件含ssh-copy-id指令
ssh-copy-id -i ~/.ssh/id_rsa.pub 被免密登陆的主机的IP

yum install bind-utils -y 此软件含nslookup指令

进入容器
docker inspect -f {{.State.Pid}} 容器名或者容器id  
nsenter  -n --target  PID名称


linux环境测网速
curl -O https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py


netstat apt-get install net-tools

```bash
sed -i "s/project-perform/project-prd/g" `find ./ | grep yaml`
# 替换以字符串name开头的行
var='gary'
sed -i '/^name/c'name=$var'' 文件名
```

开机自启脚本
 /etc/rc.d/rc.local
查看rc-local.service是否启动 systemctl | grep rc-local.service

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

查看所有目录包含隐含目录的大小
du -sh * .[^.]*
只查看隐含目录的大小
du -sh .[!.]*

除特定文件外删除所有
rm -rf !(.a|.|..)


ping 缺失
apt-get install iputils-ping

遍历获取 Linux 某目录下所有子目录及文件信息
find . -print0 | xargs -0 stat --printf="%f %N %W %Y %s\n"


- 删除Evicted状态的Pod
kubectl get pods | grep Evicted | awk '{print $1}' | xargs kubectl delete pod

- 日期
date -d "yesterday" +%Y-%m-%d

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