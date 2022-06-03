- 参考文档 https://www.cnblogs.com/jjzd/p/7010214.html
### zabbix的master
```conf
Server=XXX.XXX.XXX.XXX
Hostname=XXX.XXX.XXX.XXX
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix
DBPassword=zabbix
```
### zabbix的agent
```conf
# vim /etc/zabbix/zabbix_agentd.conf  更改
StartAgents=1  # 客户端agent模式，设置为0表示关闭被动模式，被监控端的 zabbix_agentd 不监听

Server=XXX.XXX.XXX.XXX # 被动模式下，需要配置的server的IP
ServerActive=XXX.XXX.XXX.XXX # 主动模式下，需要配置的server的IP
Hostname=XXX.XXX.XXX.XXX # 在一个监控集群里要保证其唯一性;主动模式下,server端的hostname要和此配置一样

EnableRemoteCommands=1  # 设置来自zabbix服务器的远程命令被执行
LogRemoteCommands=1 # 记录RemoteCommands的日志
# 以zabbix用户执行指令 su -s /bin/bash -c "ls" zabbix  || sudo -u zabbix ls
# 如果需要执行root才可以执行的指令 visudo 添加配置 zabbix  ALL=(ALL)       NOPASSWD: ALL

UnsafeUserParameters=1  # 是否启用自定义key;zabbix监控mysql、tomcat等数据时需要自定义key

Include=/etc/zabbix/zabbix_agentd.d/*.conf # 默认位置
AlertScriptsPath=/usr/lib/zabbix/alertscripts # 自定义告警的默认位置

RefreshActiveChecks=120    #主动模式下zabbix-agent到服务器获取监控项的周期，默认120s

# 自定义监控项
UserParameter=item_name[*],$(shell)
```