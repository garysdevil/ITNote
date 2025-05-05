---
created_date: 2020-11-28
---

[TOC]


- 参考
    - http://www.brendangregg.com/linuxperf.html

## 内核参数
- 配置位置 /etc/sysctl.conf 和 /etc/sysctl.d
```bash
sysctl  -a  # 显示当前所有可用的内核参数
sysctl  kernel.hostname  # 读特定的内核参数，比如kernel.hostname
sysctl  -p  # 从配置文件/etc/sysctl.conf中加载内核参数

sysctl -w net.ipv4.ip_forward=1 # 临时改变某个指定参数的值
echo 1 >  /proc/sys/net/ipv4/ip_forward # 临时改变某个指定参数的值
```


```conf
# 1. 一个进程可以拥有的VMA(虚拟内存区域)的数量
vm.max_map_count = 262144

# 2. 全局文件打开数量
fs.file-max = 2000000

# 3. 大内存页的数量
vm.nr_hugepages = 2048
```

```bash
# 配置大内存叶
sysctl -w vm.nr_hugepages=2560
bash -c "echo vm.nr_hugepages=2560 >> /etc/sysctl.conf"
# 检查是否配置完成
cat /proc/meminfo | grep -i huge
```

## IO读优化
- 参考
    - https://www.kernel.org/doc/Documentation/block/stat.txt
    - https://cromwell-intl.com/open-source/performance-tuning/disks.html

```bash
# 更改最大IO请求大小硬件支持的最大值/sys/block/${disk}/queue/max_hw_sectors_kb
echo ${max_hw_sectors_kb} /sys/block/${disk}/queue/max_sectors_kb # 默认为 128 KB

# I/O 请求队列长度（调大能增加硬盘吞吐量，但要占用更多内存）
echo 1024 /sys/block/${disk}/queue/nr_requests

# 为了增加连续读取的吞吐量，可以增加预读数据量。预读的实际值是自适应的，所以使用一个较高的值，不会降低小型随机存取的性能。
# 如果LINUX判断一个进程在顺序读取文件，那么它会提前读取进程所需文件的数据，放在缓存中。
echo 8192 > /sys/block/${disk}/queue/read_ahead_kb # 更改预读大小为8MB。默认为 128 KB

# 更改I/O调度算法
echo anticipatory  /sys/block/${disk}/queue/scheduler 

# 查看
cat /sys/block/${disk}/queue/
```
- I/O调度算法
    1. deadline (适合小文件读写，跳跃式读写，零散读写(数据库)) 
    2. anticipatory  (适合大文件读写，整块式，重复读写(web server))
    3. cfg (完全公平算法)  
    4. noop (没有算法，适用于SAN架构，不在本地优化)


## 更改HugePage大小
- HugePage是通过使用大页内存来取代传统的4KB内存页面，使得管理虚拟地址数变少，加快了从虚拟地址到物理地址的映射，通过摒弃内存页面的换入换出以提高内存的整体性能。
- 为了能以最小的代价实现大页面支持，Linux 操作系统采用了基于 hugetlbfs 特殊文件系统支持的 2MB 大页面。
```bash
getconf PAGESIZE # 查看内存页的大小，单位为bit

cat /proc/meminfo | grep Hugepagesize # 查看大内存页的大小

cat /proc/sys/vm/nr_hugepages # 查看大内存页的数量 

/sbin/sysctl -w vm.nr_hugepages=2500 # 设置大内存页为2500个
```

## 更改系统可以打开的最大文件句柄数
- 参考 
    - https://www.cnblogs.com/operationhome/p/11966041.html

1. ``vim /etc/security/limits.conf``
```conf
; 注意/etc/security/limits.d文件夹内的配置会覆盖/etc/security/limits.conf的配置
; nofile 表示最大文件句柄数,不能设置为 unlimited，可以设置的最大值为 1048576(2**20)
; nproc 表示可以创建的线程数
; core 限制内核文件的大小
; unlimited # 设置最大的等待信号
; soft指的是当前系统生效的设置值，软限制也可以理解为警告值。
; hard表名系统中所能设定的最大值。soft的限制不能比hard限制高。

* hard nofile 102400
* soft nofile 102400
* hard nproc unlimited
* soft nproc unlimited
* soft core 0
* hard core 0
* soft sigpending	255983
* hard sigpending	255983
```
2. ``vim /etc/profile``
```conf
ulimit -n 102400  # 设置最大可以的打开文件描述符
ulimit -u unlimited # 设置用户可以创建的最大线程数
ulimit -s unlimited # the maximum stack size
ulimit -i 102400 # # 设置最大的等待信号
ulimit -SH 102400 # 设置软硬限制
ulimit -f unlimited # 设置创建文件的最大值。
```

3. 网上说还需要设置这些 ``echo "session  required  pam_limits.so"  >>  /etc/pam.d/common-session``

4. 使配置生效``source /etc/profile``


```bash
# 查看内核资源限制
ulimit -a

# 查看当前系统支持打开的最大句柄数
more /proc/sys/fs/file-max

# 查看打开句柄总数
lsof -n|awk '{print $2}'|wc -l

# 查看系统中进程占用的句柄数，根据打开文件句柄的数量降序排列，其中第二列为进程ID
lsof -n|awk '{print $2}'|sort|uniq -c|sort -nr|more


# 查看句柄数量的最大限制
cat /proc/sys/fs/file-max # 系统层面
ulimit -n # 用户层面
cat /proc/${PID}/limits # 进程层面
```