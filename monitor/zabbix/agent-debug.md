
[TOC]

- zabbix调试测试工具

## zabbix-get
- 实现从zabbix-agent端获取数据
```bash
# 安装
yum install zabbix-get -y
# 检测本地是否能连接上zabbix-agent
zabbix_get -s ${IP} -p 10050 -k agent.ping
# 批量向zabbix-agent发送数据
zabbix_get -s ${IP} -i data.txt
```

## zabbix_sender
- 实现向zabbix-server主动推送数据
```bash
# 安装
rpm -i http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum install zabbix-sender
# 发送一个KV键值对
zabbix_sender -z ${IP} -s "aa" -k aa.bb -o 43
# 发送多个KV键值对
zabbix_sender -z ${IP} -i 文件路径
# -z 指zabbix server ip
# -s 指主机的hostname 
# -k 指对应的key值 
# -o 表示要主动推送的数据
# -i 从文件里面读取hostname key value
```

## snmp检测工具
```bash
snmpwalk -v 2c -c public ${IP} 
#   -v 指定版本（必填项）
#   -c 指定密钥 community string（必填项）
```