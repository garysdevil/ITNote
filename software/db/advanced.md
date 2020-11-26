
## MySQL Binlog 解析工具
参考 https://blog.csdn.net/weixin_34026484/article/details/91456781?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param
1. Maxwell是一个能实时读取MySQL二进制日志binlog，并生成 JSON 格式的消息，作为生产者发送给 Kafka，Kinesis、RabbitMQ、Redis、Google Cloud Pub/Sub、文件或其它平台的应用程序。它的常见应用场景有ETL、维护缓存、收集表级别的dml指标、增量到搜索引擎、数据分区迁移、切库binlog回滚方案等。官网(http://maxwells-daemon.io)、GitHub(https://github.com/zendesk/maxwell)


## Mysql 索引
通过不断的缩小想要获得数据的范围来筛选出最终想要的结果，例如字典

## 问题与解决措施
1. 
Reading table information for completion of table and column names 
You can turn off this feature to get a quicker startup with -A
MYSQL中数据库太大,导致读取预读库中表信息时间太长,从而显示这个提示 
改变数据库信息的操作,比如drop一个很大的表(几千万数据)而中途终止, 造成了锁表,从而显示这个提示  show processlist;