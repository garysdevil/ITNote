### 优化
- 参考文档
https://www.zabbix.com/documentation/3.4/manual/config/items/queue
https://blog.csdn.net/bbwangj/article/details/80981098

1. queue: 表示item从数据库读取数据的耗时
2. queue延迟的原因
    - 子节点性能
    - 子节点与主节点之间的通行质量
    - 子节点与主节点之间的时间差
    - 数据库数据量过大

3. 性能优化参考文档 - 未研究
https://www.cnblogs.com/luoahong/articles/7911543.html
https://www.cnblogs.com/guarderming/p/10219897.html
https://www.cnblogs.com/yaoyaojcy/p/8259827.html

### 常见日志错误
1. cannot send list of active checks to "XXX.XXX.XXX.XXX": host [XXX.XXX.XXX.XXX] not found
    - zabbix server的web界面的主机里面的主机名称和agent里配置的Hostname不一致。
    - zabbix server已经不监控这台主机了，但这台主机的agent依然活着且向zabbix server发送监控数据。