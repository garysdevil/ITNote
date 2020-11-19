获取公网IP ： 
curl cip.cc 
curl ipinfo.io

scp  -i 指定密钥文件  -C 允许压缩 源文件  目的地址

查看CentOS版本 cat /etc/issue 或者 cat /etc/redhat-release 
查看Ubunto版本 cat /etc/lsb-release

扫描其它机器的公钥：ssh-keyscan
生成公钥：ssh-keygen
authorized_keys   id_rsa  id_rsa.pub  know_hosts
authorized_keys,并修改 authorized_keys 权限为 600,当前目录权限为 700

yum -y install openssh-clients 此软件含ssh-copy-id指令
ssh-copy-id -i ~/.ssh/id_rsa.pub 被免密登陆的主机的IP

yum install bind-utils -y 此软件含nslookup指令

抓包
tcpdump -n -i eth0 'port 80' -s0 -w <path/to/file>
-X 告诉tcpdump命令，需要把协议头和包内容都原原本本的显示出来（tcpdump会以16进制和ASCII的形式显示），这在进行协议分析时是绝对的利器。
-s snaplen         snaplen表示从一个包中截取的字节数。0表示包不截断，抓完整的数据包。默认的话 tcpdump 只显示部分数据包,默认68字节。

交换机：
dis arp 显示ip地址和物理地址的对应关系

进入容器
docker inspect -f {{.State.Pid}} 容器名或者容器id  
nsenter  -n --target  PID名称

设置时区 
timedatectl list-timezones |grep Shanghai    # 查找中国时区的完整名称
timedatectl set-timezone Asia/Shanghai # 临时设置，重启后失效
ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime

# 查看物理CPU个数
cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
# 查看每个物理CPU中core的个数(即核数)
cat /proc/cpuinfo| grep "cpu cores"| uniq
# 查看逻辑CPU的个数
cat /proc/cpuinfo| grep "processor"| wc -l

curl 
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



获取所有的任务
for u in `cat /etc/passwd | cut -d":" -f1`;do crontab -l -u $u;done 
或者
cd /var/spool/cron && cat *

端口探测
nc -v -z ip port
一个简单的静态web页面服务器
while true;do  nc -l 88  < somepage.html; done


查看所有块设备信息 lsblk -m
查看所有已经格式化多的磁盘blkid 

blkid #系统中正在用或可以用的设备
查看磁盘分区 ： cat /proc/partitions
lsblk
fdisk -l

lsof（list open files）是一个列出当前系统打开文件的工具

linux环境测网速
curl -O https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py

ps apt-get install procps
netstat apt-get install net-tools

压缩并拆分成小文件
tar czf - test | split -b 500m - test.tar.bz2
cat test.tar.bz2* | tar -jxv


/etc/security/limits.conf
```
* soft nofile 65530
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096
```
重启服务器


sed -i "s/project-perform/project-prd/g" `find ./ | grep yaml`


变量的提取和替换
${var#*/} 去掉变量var从左边算起的第一个'/'字符及其左边的内容
${var##*/} 去掉变量var从左边算起的最后一个'/'字符及其左边的内容
${var%/*}
${var%/*}
for name in `ls *.Linux`;do mv $name ${name%.*};done


linux 上验证websocket的连通性
1. 
apt install node-ws (ubuntu16)
npm install -g wscat (centos)
wscat -c ws://IP:PORT
2. 
游览器
new WebSocket("wss://XXX.XXX.XXX.XXX:9944");

ssh -i key.pem root@IP
ssh-add 把专用密钥添加到ssh-agent的高速缓存中
ssh-agent 是一个代理程序，它能帮助我们管理我们的私钥。
ssh-agent bash
ssh-add -k key.pem


开机自启脚本
 /etc/rc.d/rc.local
查看rc-local.service是否启动 systemctl | grep rc-local.service

```bash
# 只要./test.lock的当前状态未被外部改变，其它flock ./test.lock的就执行失败，直到当前的flock执行结束
flock -xn ./test.lock -c "sh ./test.sh"
-n # 非阻塞模式，当获取锁失败时，返回1而不是等待
-x -e  # 获取一个排它锁，或者称为写入锁，为默认项
```


虚拟化
1. PV AMI: 半虚拟化
2. HVM: aws目前使用的
3. XEM
4. KVM
- Linux Amazon 系统映像(AMI)使用两种虚拟化类型之一：半虚拟化 (PV) 或硬件虚拟机 (HVM)。

```bash
# 创建用于交换分区的文件
dd if=/dev/zero of=/swapfile bs=1M count=2048 
# 设置交互分区
mkswap /swapfile 
# 立即启用交换分区文件: 
swapon /swapfile 
#  在 /etc/fstab 中添加如下一行，使之永久生效 
/swapfile swap swap defaults 0 0 
# 查看系统对 SWAP 分区的使用原则
cat /proc/sys/vm/swappiness
```
- Linux Amazon 系统映像(AMI)使用两种虚拟化类型之一：半虚拟化 (PV) 或硬件虚拟机 (HVM)。

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

配置临时网卡
ifconfig eth0:0 192.168.6.100 netmask 255.255.255.0 up
ifconfg eth0:0 down

# route
https://ivanzz1001.github.io/records/post/linuxops/2018/11/14/linux-route
Linux系统的route命令用于显示和操作IP路由表（show/manipulate the IP routing table)。要实现两个不同的子网之间的通信，需要一台连接两个网络的路由器，或者同时位于两个网络的网关来实现。
在Linux系统中，设置路由通常是为了解决以下问题：该Linux系统在一个局域网中，局域网中有一个网关，能够让机器访问internet，那么就需要将网关地址设置为该Linux机器的默认路由。

Destination: 目标网络(network)或者目标主机(host)
Gateway: 网关地址，*表示并未设置网关地址；
Genmask: 目标网络。其中’255.255.255’用于指示单一目标主机；’0.0.0.0’用于指示默认路由，表示所有地址通过对应的网关进行转发


 ps -eo pid,lstart,etime,cmd |grep nginx




lld 
作用：用来查看程式运行所需的共享库,常用来解决程式因缺少某个库文件而不能运行的一些问题。

lld 文件名
-v
第一列：程序需要依赖什么库 
第二列: 系统提供的与程序需要的库所对应的库 
第三列：库加载的开始地址


lib 包含目标文件(object files)与库。
lib32 表示32位，32位的目标文件和库。
lib64 表示32位，64位的目标文件和库。
libexec 包含不由用户和shell script直接执行的二进制文件。


参考
https://medium.com/fcamels-notes/%E8%A7%A3%E6%B1%BA-linux-%E4%B8%8A-c-c-%E7%9A%84-undefined-symbol-%E6%88%96-undefined-reference-a80ee8f85425
使用 C/C++ 程式分成三個步驟: 編譯 (compile) → 連結 (link) → 執行 (載入 symbol)

配置动态链接库的搜索路径 /etc/ld.so.conf
重新刷新动态链接库的搜索路径 /sbin/ldconfig

动态库以.so为扩展名，静态库以.a为扩展名