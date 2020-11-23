## 内核参数
- 配置位置 /etc/sysctl.conf
```bash
sysctl  -a  # 显示当前所有可用的内核参数
sysctl  kernel.hostname  # 读特定的内核参数，比如kernel.hostname
sysctl  -p  # 从配置文件/etc/sysctl.conf中加载内核参数

sysctl -w net.ipv4.ip_forward=1 # 临时改变某个指定参数的值
echo 1 >  /proc/sys/net/ipv4/ip_forward # 临时改变某个指定参数的值
```
1.  vm.max_map_count=262144
限制一个进程可以拥有的VMA(虚拟内存区域)的数量

### ulimit
- 设置非root账号打开文件数量也是65536
nofile表示最大文件句柄数
1. /etc/security/limits.conf
```conf
* hard nofile 1024000
* soft nofile 1024000
* hard nproc unlimited
* soft nproc unlimited
* soft core 0
* hard core 0
* soft sigpending	255983
* hard sigpending	255983
```
2. /etc/profile
```conf
ulimit -n 1024000
ulimit -u unlimited
ulimit -s unlimited
ulimit -i 255983
ulimit -SH 655350
ulimit -f unlimited
```

3. 网上说还需要设置这些，本人没有设置也成功了
echo "session  required  pam_limits.so"  >>  /etc/pam.d/common-session
echo "session  required  pam_limits.so" >> 

4. source /etc/profile
