---
created_date: 2020-11-16
---

[TOC]

## zabbix-server和zabbix-proxy间的通信机制
- 官方文档 https://www.zabbix.com/documentation/3.4/manual/concepts/proxy

1. zabbix-proxy 和 agent进行通信 获取监控数据，然后存入数据库proxy_history表中。
2. zabbix-server 和 zabbix-proxy进行通信，zabbix-proxy数据库里的数据通过TCP协议传输至zabbix-server的数据库里。

2. zabbix-server 和 zabbix-proxy 通过TCP协议进行连接。推测是短连接。
    - proxy主动模式，则proxy通过 data sender线程向server发送数据。
    - proxy为被动模式，则server通过proxy poller线程去获取数据。

## zabbix-proxy 配置文件
```conf
DataSenderFrequency=1 # 主动模式下，proxy向 zabbix-server 发送采集到的数据 的时间间隔。默认为1秒 。
ConfigFrequency=3600 # 主动模式下，proxy向 zabbix-server 拉取监控项配置进行更新 的时间间隔。默认为1小时。
ProxyOfflineBuffer=1 # 当proxy和server连接失败时，依然保留采集到的数据多长时间。 默认为1小时。
HousekeepingFrequency=4 # 每小时执行多少次数据清理的程序。默认为4次。
```