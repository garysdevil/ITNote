---
created_date: 2021-07-24
---

[TOC]

## 网络时间协议 ntp

- 协议说明：https://en.wikipedia.org/wiki/Network_Time_Protocol
- 功能：进行时钟同步，保证服务器之间的时间是一致的。
- 使用UDP协议，端口123

1. 安装

```bash
yum -y install ntp
```

2. 配置
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

```conf
pool ntp.sjtu.edu.cn iburst # 上海交通大学网络中心NTP服务器地址
pool time.nist.gov iburst # 美国标准技术研究院 NTP 服务器
```

4. 手动调整时钟

   - 需要先关闭ntp服务
     ntpdate 服务器地址

5. 查看服务状态
   systemctl status ntpd.service

6. 查看同步状态
   ntpq -p
   ntpstat

## 时区

- 时区参考 https://time.123cha.com/knowledge/6.html

- 整个地球分为二十四时区，每个时区都有自己的本地时间。每隔经度15°划分一个时区。

- 通用协调时(UTC, Universal Time Coordinated)

- UTC 世界标准时间 ～= GMT

1. GMT 格林尼治标准时间 Greenwich Mean Time
   - +0
   - 东零时区/西零时区，是西经15度到东经15度的地方，格林威治是英国伦敦泰晤士河南岸的一个地方。
2. CST 北京时间
   - UTC/GMT +08
   - 东八时区。
3. CET/CEST 中欧标准时间 Central European Time
   - UTC/GMT +01 (夏令时)
   - UTC/GMT +02 (冬令时)
   - 东一时区。大部分欧洲国家和部分北非国家在使用。
4. ET/EST 美国东部时间 Eastern Standard Time
   - UTC/GMT -04 (夏令时) 2022-3-13 3:00:00 ～ 2022-11-6 2:00:00
   - UTC/GMT -05 (冬令时)
   - 西五时区。纽约、华盛顿等城市在使用。
5. PT/PST 太平洋标准时间 Pacific Time Zone
   - UTC/GMT -08 (冬令时)
   - UTC/GMT -07 (夏令时)
   - 西八时区。太平洋沿岸美国的4个州在使用，代表城市洛杉矶、旧金山、圣地亚哥、拉斯维加斯、西雅图。

```bash
# 1. 查看每个time zone当前的时间
zdump Hongkong

# 2. 设置时区
ln -sf /usr/share/zoneinfo/posix/Asia/Shanghai /etc/localtime
# 或者 tzselect

timedatectl list-timezones |grep Shanghai    # 查找中国时区的完整名称
timedatectl set-timezone Asia/Shanghai # 临时设置，重启后失效
ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
```

## 时间

1. 查看机器上的硬件时间(always in local time zone)

```bash
hwclock --show
```

2. 查看操作系统的时间

```bash
date -d "yesterday" +%Y-%m-%d
date -d '2 days ago' +%Y-%m-%d # 显示2天前的时间
date '+%Y-%m-%d %H:%M:%S'
```
