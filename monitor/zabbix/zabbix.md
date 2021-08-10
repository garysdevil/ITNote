1. 宏
https://www.zabbix.com/documentation/3.4/zh/manual/config/macros
https://www.zabbix.com/documentation/3.4/manual/appendix/macros/supported_by_location
https://www.cnblogs.com/skyflask/p/7523535.html



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

    - 更改 memory_limit 为 512M  
    /etc/httpd/conf.d/zabbix.conf
    ```conf
    php_value memory_limit 256M  # PHP 单个脚本单次执行最大可用内存限制。默认限制为 256MB。
    ```
    systemctl restart httpd

## Discovery rule
1. 写脚本返回json格式的数据
```json
{"data":[{"{#custom_name}":"value1"},{"{#custom_name}":"value12"}]}
```

2. 在web界面配置Discovery rule

3. 在web界面配置Item prototypes
    - 可以使用Discovery rule里返回的变量 item_name_{#custom_name}[参数1, ${custom_name}]

3. 在web界面配置Trigger prototypes