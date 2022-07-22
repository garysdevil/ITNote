

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

### 磁盘
1. 查看所有块设备信息 lsblk -m
2. 打印磁盘信息 blkid 
3. 查看磁盘分区
cat /proc/partitions
lsblk
fdisk -l

### shell
- 数组长度
```bash
#!/bin/bash
array_name=(
  "137.184.202.162:4132"
  "218.17.62.53:4132"
  "141.95.85.71:4132"
)
# 输出数组长度
echo ${#array_name[*]}
echo ${#array_name[@]}
# 输出数组所有的值
echo ${arr[@]} 
#  遍历数组
for ipport in ${array_name[@]};do
    echo $ipport;
done
```

- 变量的提取和替换
```bash
${var#*/} # 去掉变量var从左边算起的第一个'/'字符及其左边的内容
${var##*/} # 去掉变量var从左边算起的最后一个'/'字符及其左边的内容
${var%/*}
${var%/*}
for name in `ls *.Linux`;do mv $name ${name%.*};done
```

- 变量字符串分割
```bash
    # 分割ip和端口号
    ipport="127.0.0.1:8080"
    ip=${ipport%:*}
    port=${ipport#*:}
    echo "${ip} ${port}"
```

- 去掉字符串两边的双引号
```bash
    echo '"127.0.0.1:8080"' > ipport.txt
    
    ipport_raw=$(cat ipport.txt)
    # 去掉两边的双引号
    len_temp_1=${#ipport_raw}
    len_temp_2=$(echo "${len_temp_1}-2" | bc -l)
    ipport=${ipport_raw:1:${len_temp_2}}
    echo $ipport
```

- 判断/比较符号
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
```bash
#!/bin/bash
source /etc/profile
if [ $num -gt 182 ]; then
    touch "$num"
fi
```

#### linux select 指令建立菜单
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
# --since "2012-10-30 18:17:16"
# -b 0 查看系统本次启动的日志
# -k 查看内核日志（不显示应用日志）
# -u 查看某个Unit的日志
# _PID=1 查看指定进程的日志
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

### 公钥
```bash
# 扫描其它机器的公钥
ssh-keyscan
# 生成公钥
ssh-keygen -C "备注信息"
# authorized_keys   id_rsa  id_rsa.pub  know_hosts
```

### 压缩
```bash
# 将大文件压缩并拆分成小文件进行打包(用 bzip2 压缩)
tar cjvf - bigFile | split -b 500m - smallFile.tar.bz2
# 解压出大文件
cat smallFile.tar.bz2* | tar -jxv

# 用 bzip2 格式压缩文件
tar  cjvf FileName.tar.bz2 ./Filename
# 用 gzip 格式压缩文件
tar  czvf FileName.tar.bz2 ./Filename
# 用 bzip2 格式解压文件
tar  xjvf FileName.tar.bz2 ./Filename


# xz压缩工具，比gzip格式压缩比更大
# 对于文件夹，先使用tar cvf ${文件名}.tar ./${文件名} 创建${文件名}.tar文件，然后使用xz -zk将tar文件压缩成为.tar.xz文件。
# 先用xz -dk将tar.xz文件解压成tar文件，再用tar文件来解包。
xz -z ${文件名} # 不保留原文件压缩
xz -zk ${文件名} # 保留原文件压缩
xz -d ${文件名} # 不保留原文件解压
xz -dk ${文件名} # 保留原文件解压
# --threads 1 # 指定使用的线程数量 
```

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
# git://github.com/sysstat/sysstat
apt-get install sysstat
yum -y install sysstat
sar -V

# iostat 工具提供CPU使用率及硬盘吞吐效率的数据；  #比较核心的工具
iostat -d -k ${Device}
# pidstat: 关于运行中的进程/任务、CPU、内存等的统计信息
# ...
```


### awk
```bash
# 内置变量
# FS：输入字段分隔符，默认为空白字符
# OFS：输出字段分隔符，默认为空白字符
# RS：输入记录分隔符，默认为\n
# ORS：输出记录分隔符，默认为\n

# NF：当前记录的字段的个数
# NR：当前处理的文本记录的行号

# FNR：文件记录的数量
# FILENAME：当前文件名
# ARGC：命令行参数的个数

# 指定分隔符
awk -v FS=":" '{print $3}'

# 替换操作 = sed 's/one/two'
awk '{sub(/one/,"two");print}'
# 过滤操作 = grep -E 'one|two'
awk '(/one|two/)'

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

### 传文件
```bash
# 本地快速拷贝文件夹
tar cvf – 源文件夹路径 | tar xvf – -C 目的文件夹路径
```

```bash
# scp  -i 指定密钥文件 -C 允许压缩 源文件 目的地址
scp -P22 home.tar 192.168.205.34:/home/home.tar
# -r 拷贝目录

# rsync支持在本地计算机与远程计算机之间，或者两个本地目录之间同步文件
rsync -P --rsh=ssh home.tar 192.168.205.34:/home/home.tar
rsync -P -e'ssh -p 22' home.tar 192.168.205.34:/home/home.tar
# -P 可以实现意外中断后，下次继续传。当于 --partial --progress
# -r 拷贝目录
# -a 参数可以替代-r，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）,从而做到增量同步
# --exclude='文件名' 排除某些文件或目录
# -e 指定协议
# --partial 允许恢复中断的传输
# --append 文件接着上次中断的地方，继续传输
# --append-verify 跟--append参数类似，但会对传输完成后的文件进行一次校验。如果校验失败，将重新发送整个文件。非常影响传输速度。
# -z 同步时压缩数据
# -S 传输稀疏文件 sparse file
# --bwlimit=1024 # 单位为KB/s

# 通过ssh协议远程同步目录时的参数
--append-verify -P -a -z -e'ssh -p 22'
```

### 稀疏文件
- 稀疏文件 sparse file
    - 稀疏文件就是在文件中留有很多空余空间，留备将来插入数据使用。如果这些空余空间被ASCII码的NULL字符占据，并且这些空间相当大，那么，这个文件就被称为稀疏文件，而且，并不分配相应的磁盘块。
    - Linux中常见的qcow2文件和raw文件，都是稀疏文件。
```bash
# 创建稀疏文件，将创建一个5MB大小的文件，但不在磁盘上存储数据（仅存储元数据）
spare_file_path=spare_file
# dd命令创建
dd of=${spare_file_path} bs=1k seek=5120 count=0
# truncate命令创建
truncate -s 5M sparse_file_name
# qemu-img命令创建
qemu-img create -f qcow2 ${spare_file_path}.qcow2 5M

# 查看稀疏文件的大小
qemu-img info ${spare_file_path}
```

### 传稀疏文件
```bash
# 拷贝稀疏文件的几种方式 # 两台机器的文件系统必须相同，否则下面的指令无效

# 进行拷贝稀疏文件测试 稀疏文件大小：virtual size: 1.93 GiB, disk size: 860 MiB, 传输速度维持在11.27MB/s左右

# rsync传输
rsync -P -S -e'ssh -p 22' 0  10.10.1.42:~/ # 2m55.485s

# rsync压缩传输
rsync -P -S -z -e'ssh -p 22' 0  10.10.1.42:~/ # 0m46.092s # 显示的传输速度为 43.35MB/s，应该是由于压缩原因，实际上是传输大小减小了
rsync -P -S -z  0  10.10.1.42:~/  # 0m50.225s

# tar打包，rsync传输
tar Scvf 0.tar 0 && rsync -P -S -e'ssh -p 22' 0.tar  10.10.1.42:~/ && ssh 10.10.1.42 tar xvf ~/0.tar # 1m23.187s

# tar打包压缩，rsync传输
tar Sczvf 0.tar.gz 0 && rsync -P -S -e'ssh -p 22' 0.tar.gz  10.10.1.42:~/ && ssh 10.10.1.42 tar xzvf ~/0.tar.gz # 1m7.679s

# tar打包压缩, scp传输
tar Scjvf - 0 | ssh 10.10.1.42 tar xjvf - -C ./  # 1m41.213s
tar Sczvf - 0 | ssh 10.10.1.42 tar xzvf - -C ./  # 0m46.807s

# 最佳实践
time rsync -P -S -a -z  -e'ssh -p 22' ./aa  10.10.3.76:/tank1/
```



### GPU
- 参考
    - nvcc https://blog.csdn.net/hxxjxw/article/details/119838078

- CUDA（Compute Unified Device Architecture）
    - 由NVIDIA推出的通用并行计算架构。提供了一套应用软件接口（API）。其主要应用于英伟达GPU显卡的调用。
    - https://forums.developer.nvidia.com/

- ROCM
    - 由AMD推出的通用并行计算架构。提供了一套应用软件接口（API）。其主要应用于AMD GPU显卡的调用。

- PCI Peripheral Component Interconnect(外设部件互连标准)

```bash
# lspci指令

lspci | grep -i vga -A 12 # 查看显卡信息

lspci -vnn | grep VGA -A 12 # 查看显卡信息

lspci -v -s ${62:00.0} # 查看指定显卡的详细信息

lspci -vnn | grep VGA -A 12 | grep 'Family' # 查看显卡信息
# Subsystem: Gigabyte Technology Co., Ltd ASPEED Graphics Family [1458:1000] 
# 1458 代表厂商 ID
# 1000 代表 PCI

lspci | grep -i nvidia # 查看nvidia GPU信息
```

```bash
# lshw指令  就是读取 /proc 里面的一些文件来显示相关的信息

lshw -C display
lshw -C display -short

lshw -c video | grep configuration # 查看所有的显卡驱动名称
modinfo ${driver} # 通过显卡驱动名称查看显卡驱动的详情
```

```bash
# CUDA toolkit 
# https://developer.nvidia.com/cuda-downloads
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#environment-setup # 安装完设置环境变量
# CUDA的编译器
apt update
apt install nvidia-cuda-toolkit
nvcc --version # 查看cuda编译器版本
```

```bash
# 安装NVIDIA CUDA驱动
# add-apt-repository ppa:graphics-drivers/ppa --yes
# apt update
# apt install nvidia-driver-510
# apt install nvidia-driver-* # 选择一个驱动器
nvidia-smi -L # 查看NVIDIA显卡型号
nvidia-smi -l 1 # # 查看NVIDIA GPU使用率，每秒刷新一次

nvidia-smi dmon # 设备状态持续显示输出
nvidia-smi pmon # 进程状态持续显示输出

ls /usr/src | grep nvidia  # 查看服务器安装的驱动版本信息
cat /proc/driver/nvidia/version  # 查看运行中的驱动版本信息

# 执行nvidia-smi指令时报错 NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running. 解决办法
apt-get install dkms
dkms install -m nvidia -v $(ls /usr/src | grep nvidia | awk -v FS='-' '{print $2}')
# 如果还是报错，则重启

```
- CUDA编程
    - 在GPU上执行的函数通常称为核函数。
    - 以线程格（Grid）的形式组织，每个线程格由若干个线程块（block）组成，而每个线程块又由若干个线程（thread）组成。
    - 以block为单位执行的。
    - 


### 数学计算
```bash
echo "2/3" | bc -l
# scale=3 保留几位小数
echo "scale=3; ${num}*5/60/60" | bc -l
```

### taskset
```bash
# 查看线程和CPU间的亲和性
taskset -p ${PID}
# ffffffffffffffffff 表示可以使用任意的CPU逻辑核

# 查看线程可以使用的CPU范围
taskset -cp ${PID}

# 设置线程的CPU亲和性为指导的CPU逻辑核
start=0
end=3
taskset -cp ${start}-${end}  ${PID} # start到end
taskset -cp ${start},${end}  ${PID} # start核end

# -p 通过${PID}查看指定的线程
# -c 查看线程可以使用的CPU范围
```

### ssh 
```bash
ssh -p22 127.0.0.1 -i 私钥文件路径
```

- vi ~/.ssh/config
```conf
# 定义ssh登入时默认使用的私钥
IdentityFile ~/.ssh/私钥文件名
```

- 问题：用SSH客户端连接linux服务器时，经常会话连接中断。
- 解决方案：设置服务器向SSH客户端连接会话时发送的频率和时间。
```bash
#vi /etc/ssh/sshd_config
ClientAliveInterval 60 # 定义了每隔多少秒给SSH客户端发送一次信号
ClientAliveCountMax 86400 # 定义了超过多少秒后断开与ssh客户端连接

# 重启SSH服务
#service sshd restart
```

## 未归类
获取公网IP ： 
curl cip.cc 
curl ipinfo.io

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

- screen ssh退出后可以运行在后台的窗口，可以替代nohup
```bash
# 创建一个screen
screen -S  ${screenName}
# 查看已经存在的screen
screen -ls
# 切换到某个screen
screen -r ${screenName}
# 将screen切回后台
Ctr+a 按下后再按下d
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

- 查看磁盘是否是SSD
    ```bash
    # ROTA为0表示不可以旋转，就是SSD
    lsblk -d -o name,rota
    ```

- 软链接
```bash
ln -s 源文件 目标文件
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

### Linux查看磁盘是固态还是机械
```bash
lsblk
# 1 代表是机械硬盘，0 则就是 ssd 
# 查看某个磁盘类型
cat /sys/block/{block_name}/queue/rotational
# 查看所有磁盘类型 方式一
grep ^ /sys/block/*/queue/rotational
# 查看所有磁盘类型 方式二
lsblk -d -o name,rota
```

### iotop 进程IO监控
```bash
iotop -oP 
# -o 只显示有I/O行为的线程
# -P 只显示进程
```

### hdparm
- ``hdparm``（即硬盘参数）是Linux的命令行程序之一，用于处理磁盘设备和硬盘。借助此命令，您可以获得有关硬盘，更改写入间隔，声学管理和DMA设置的统计信息。
```bash
disk=/dev/sda
hdparm  ${disk} # 显示指定硬盘的相关信息
hdparm -t ${disk} # 评估硬盘读取效率
```