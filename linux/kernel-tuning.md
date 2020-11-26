## 内核参数
- 配置位置 /etc/sysctl.conf 和 /etc/sysctl.d
```bash
sysctl  -a  # 显示当前所有可用的内核参数
sysctl  kernel.hostname  # 读特定的内核参数，比如kernel.hostname
sysctl  -p  # 从配置文件/etc/sysctl.conf中加载内核参数

sysctl -w net.ipv4.ip_forward=1 # 临时改变某个指定参数的值
echo 1 >  /proc/sys/net/ipv4/ip_forward # 临时改变某个指定参数的值
```
1.  vm.max_map_count=262144
一个进程可以拥有的VMA(虚拟内存区域)的数量

2. fs.file-max = 2000000
全局文件打开数量

### ulimit
- 参考 
https://www.cnblogs.com/operationhome/p/11966041.html

1. /etc/security/limits.conf
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
2. /etc/profile
```conf
ulimit -n 102400  # 设置最大可以的打开文件描述符
ulimit -u unlimited # 设置用户可以创建的最大线程数
ulimit -s unlimited # the maximum stack size
ulimit -i 102400 # # 设置最大的等待信号
ulimit -SH 102400 # 设置软硬限制
ulimit -f unlimited # 设置创建文件的最大值。
```

3. 网上说还需要设置这些
echo "session  required  pam_limits.so"  >>  /etc/pam.d/common-session
echo "session  required  pam_limits.so" >> 

4. source /etc/profile
