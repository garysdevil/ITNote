
## MySQL Binlog 解析工具
- 参考 
    - https://blog.csdn.net/weixin_34026484/article/details/91456781?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param

1. Maxwell
    - 是一个能实时读取MySQL二进制日志binlog，并生成 JSON 格式的消息，作为生产者发送给 Kafka，Kinesis、RabbitMQ、Redis、Google Cloud Pub/Sub、文件或其它平台的应用程序。
    - 常见应用场景有ETL、维护缓存、收集表级别的dml指标、增量到搜索引擎、数据分区迁移、切库binlog回滚方案等。
    - 官网(http://maxwells-daemon.io)、GitHub(https://github.com/zendesk/maxwell)


## Mysql 索引
通过不断的缩小想要获得数据的范围来筛选出最终想要的结果，例如字典

## 问题与解决措施
1. 
Reading table information for completion of table and column names 
You can turn off this feature to get a quicker startup with -A
MYSQL中数据库太大,导致读取预读库中表信息时间太长,从而显示这个提示 
改变数据库信息的操作,比如drop一个很大的表(几千万数据)而中途终止, 造成了锁表,从而显示这个提示  show processlist;


## TiDB
- https://zhuanlan.zhihu.com/p/71073707
- TiDB 是 PingCAP 公司受 Google Spanner / F1 论文启发而设计的开源分布式 HTAP (Hybrid Transactional and Analytical Processing) 数据库，结合了传统的 RDBMS 和NoSQL 的最佳特性。TiDB 兼容 MySQL，支持无限的水平扩展，具备强一致性和高可用性。TiDB 的目标是为 OLTP(Online Transactional Processing) 和 OLAP (Online Analytical Processing) 场景提供一站式的解决方案。


## sql审核平台
### Yearning
- 参考
    - https://github.com/cookieY/Yearning
    - https://guide.yearning.io/install.html

- 注意
    - Yearning 1.x版本需inception提供SQL审核及回滚功能
    - Yearning 2.0开始无需依赖Inception，已自己实现了SQL审核/回滚功能；仅依赖Mysql数据库，mysql版本必须5.7及以上版本
    - 只支持Mysql的审核
#### 部署
1. 下载解压  
wget https://github.com/cookieY/Yearning/releases/download/v2.3.1/Yearning-2.3.1-GA-linux-amd64.zip

2. 初始化数据库  
./Yearning -m

3. 默认参数启动  
    - ./Yearning -s
    - 默认端口 0.0.0.0:8000
