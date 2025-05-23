---
created_date: 2022-06-10
---

[TOC]

## 报错记录

1. 告警阶段触发器被disable

   - 参考文档 https://blog.csdn.net/clm_sky/article/details/90489340

   ```txt
   告警升级执行过程中，如果出现动作禁用、基于触发器的事件删除、触发器禁用或删除、触发器相关的主机或监控项禁用、监控项禁用或删除、主机禁用等情况时，正在发送中的信息和告警升级中配置的其他信息会被发送。只是后面发送的信息中会加上(NOTE: Escalation cancelled)，比如说动作禁用时会在信息前加上NOTE: Escalation cancelled: action '<Action name>' disabled，通过这种方法通知用户取消告警升级。取消的原因也可以通过设置Debug Level = 3从日志文件中查看。
   ```

2. 500 ,zabbix web 报错

   - /etc/httpd/logs/error_log

   ```log
   [Thu Jul 22 23:39:44.152344 2021] [:error] [pid 22975] [client 116.228.132.228:55395] PHP Fatal error:  Allowed memory size of 134217728 bytes exhausted (tried to allocate 77 bytes) in /usr/share/zabbix/include/classes/api/CRelationMap.php on line 104, referer: http://zabbix.abcrender.com/hostinventories.php?ddreset=1
   ```

   - 更改 memory_limit 为 512M\
     /etc/httpd/conf.d/zabbix.conf

   ```conf
   php_value memory_limit 256M  # PHP 单个脚本单次执行最大可用内存限制。默认限制为 256MB。
   ```

   - systemctl restart httpd

3. zabbix-agent2的异常日志

   - /var/log/zabbix/zabbix_agent2.log里的异常日志。不影响软件正常使用。

   ```log
   2022/06/01 16:57:48.542067 [101] active check configuration update from [101.43.98.179:10051] started to fail (Cannot read message: 'read tcp 117.148.141.247:57509->101.43.98.179:10051: i/o timeout')
   ```

   - 无可奈何的解决方案： 注释掉/etc/zabbix/zabbix_agent2.conf里的ServerActive=，关闭主动模式.
   - 方案： 更改配置，增加超时的时间 Timeout
   - https://www.zabbix.com/forum/zabbix-troubleshooting-and-problems/417103-refreshactivechecks-i-o-timeout?view=stream

4. cannot send list of active checks to "XXX.XXX.XXX.XXX": host [XXX.XXX.XXX.XXX] not found

   - zabbix server的web界面的主机里面的主机名称和agent里配置的Hostname不一致。
   - zabbix server已经不监控这台主机了，但这台主机的agent依然活着且向zabbix server发送监控数据。
