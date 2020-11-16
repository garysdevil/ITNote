1. 宏
https://www.zabbix.com/documentation/3.4/zh/manual/config/macros
https://www.zabbix.com/documentation/3.4/manual/appendix/macros/supported_by_location
https://www.cnblogs.com/skyflask/p/7523535.html


2. 
- 参考文档 https://blog.csdn.net/clm_sky/article/details/90489340
```txt
告警升级执行过程中，如果出现动作禁用、基于触发器的事件删除、触发器禁用或删除、触发器相关的主机或监控项禁用、监控项禁用或删除、主机禁用等情况时，正在发送中的信息和告警升级中配置的其他信息会被发送。只是后面发送的信息中会加上(NOTE: Escalation cancelled)，比如说动作禁用时会在信息前加上NOTE: Escalation cancelled: action '<Action name>' disabled，通过这种方法通知用户取消告警升级。取消的原因也可以通过设置Debug Level = 3从日志文件中查看。
```