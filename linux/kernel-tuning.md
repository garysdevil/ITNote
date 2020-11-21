## 内核参数
- 配置位置 /etc/sysctl.conf
```bash
sysctl  -a  # 显示当前所有可用的内核参数
sysctl  kernel.hostname  # 读特定的内核参数，比如kernel.hostname
sysctl  -p  # 从配置文件/etc/sysctl.conf中加载内核参数

sysctl -w net.ipv4.ip_forward=1 # 临时改变某个指定参数的值
echo 1 >  /proc/sys/net/ipv4/ip_forward # 临时改变某个指定参数的值
```


1. ulimit
确保非root账号打开文件数量也是65536
nofile表示最大文件句柄数,表示能够打开的最大文件数目
/etc/security/limits.conf
```conf
* soft nofile 65536
* hard nofile 65536
```
/etc/profile
```conf
ulimit -SHn 65536
```
source /etc/profile
