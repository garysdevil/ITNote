### 网络时间协议
- 协议说明 https://en.wikipedia.org/wiki/Network_Time_Protocol
- 功能 进行时钟同步，保证服务器之间的时间是一致的。
1. 安装
yum -y install ntp
- 使用UDP协议，端口123
2.  配置
vi /etc/ntp.conf
```conf 
# 配置可以来同步时钟的网络段
# Hosts on local network are less restricted.
restrict 10.118.12.0 mask 255.255.255.0 nomodify
# 假如此服务器没有上层的时钟同步服务器，则一定要有以下配置
server 127.127.1.0
fudge 127.127.1.0 stratum 0
```
3. 时钟服务器地址
ntp.sjtu.edu.cn 上海交通大学网络中心NTP服务器地址
time.nist.gov 美国标准技术研究院 NTP 服务器

4. 手动调整时钟
    - 需要先关闭ntp服务
    ntpdate 服务器地址

5. 查看服务状态
    systemctl status ntpd.service

6. 查看同步状态
    ntpq -p
    ntpstat

### 关于时间
1. 查看每个time zone当前的时间
    zdump Hongkong

2. 设置时区
    ln -sf /usr/share/zoneinfo/posix/Asia/Shanghai /etc/localtime
    或者 tzselect

3. 查看机器上的硬件时间(always in local time zone)
    hwclock --show