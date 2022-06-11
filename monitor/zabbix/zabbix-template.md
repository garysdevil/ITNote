[TOC]

- 记录zabbix监控模版修改

## Template Module Linux network interfaces by Zabbix agent active
1. 更改以下监控项原型 interval 为10s
   1. Interface {#IFNAME}: Bits received
   2. Interface {#IFNAME}: Bits sent

## Template Module Linux block devices by Zabbix agent active
1. 添加监控项原型 interval 为30s
   1. {#DEVNAME}: Disk kB_read
   2. {#DEVNAME}: Disk kB_write
   3. {#DEVNAME}: Disk tps

## Template Module Linux CPU by Zabbix agent active
1. 更改以下监控项 interval 为10s
   1. CPU idle time

## Template Module Linux memory by Zabbix agent active
1. 更改以下监控项 interval 为10s
    1. Available memory in %