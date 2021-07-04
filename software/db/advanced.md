
## MySQL Binlog 解析工具
- 参考 
    - https://blog.csdn.net/weixin_34026484/article/details/91456781?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.channel_param

1. Maxwell
    - 是一个能实时读取MySQL二进制日志binlog，并生成 JSON 格式的消息，作为生产者发送给 Kafka，Kinesis、RabbitMQ、Redis、Google Cloud Pub/Sub、文件或其它平台的应用程序。
    - 常见应用场景有ETL、维护缓存、收集表级别的dml指标、增量到搜索引擎、数据分区迁移、切库binlog回滚方案等。
    - 官网(http://maxwells-daemon.io)、GitHub(https://github.com/zendesk/maxwell)

## 优化
### Mysql导致的访问延迟优化
- 成本由低到高

1. 第一 优化你的sql和索引
2. 第二 加缓存，memcached,redis
3. 第三 以上都做了后，还是慢，就做主从复制或主主复制，读写分离；可以在应用层做，效率高；也可以用三方工具，例如 360的atlas
4. 第四 如果以上都做了还是慢，mysql自带分区表，对应用是透明的，无需更改代码,但是sql语句是需要针对分区表做优化的，sql条件中要带上分区条件的列，从而使查询定位到少量的分区上，否则就会扫描全部分区； 
    - 分区表有一些坑；
5. 第五 如果以上都做了，那就做垂直拆分，根据你模块的耦合度，将一个大的系统分为多个小的系统，也就是分布式系统；
6. 第六 如果以上都做了，那就做水平切分，针对数据量大的表，这一步最麻烦，最能考验技术水平，要选择一个合理的sharding key,为了有好的查询效率，表结构也要改动，做一定的冗余，应用也要改，sql中尽量带sharding key，将数据定位到限定的表上去查，而不是扫描全部的表；

### Mysql 索引
通过不断的缩小想要获得数据的范围来筛选出最终想要的结果，例如字典

### mysql慢日志查询

    ```sql
    select CONVERT(sql_text using utf8),start_time from mysql.slow_log limit 3;
    select query_time,start_time from mysql.slow_log ORDER BY query_time desc limit 20;
    select db,count(*) as num from mysql.slow_log group by db;
    ```

## 问题与解决措施
1. 
Reading table information for completion of table and column names 
You can turn off this feature to get a quicker startup with -A
MYSQL中数据库太大,导致读取预读库中表信息时间太长,从而显示这个提示 
改变数据库信息的操作,比如drop一个很大的表(几千万数据)而中途终止, 造成了锁表,从而显示这个提示  show processlist;


## TiDB
- https://zhuanlan.zhihu.com/p/71073707
- TiDB 是 PingCAP 公司受 Google Spanner / F1 论文启发而设计的开源分布式 HTAP (Hybrid Transactional and Analytical Processing) 数据库，结合了传统的 RDBMS 和NoSQL 的最佳特性。TiDB 兼容 MySQL，支持无限的水平扩展，具备强一致性和高可用性。TiDB 的目标是为 OLTP(Online Transactional Processing) 和 OLAP (Online Analytical Processing) 场景提供一站式的解决方案。

## 锁
- InnoDB 引擎行锁是通过给索引上的索引项加锁来实现的，只有通过索引条件检索数据，InnoDB才使用行级锁，否则，InnoDB将使用表锁。

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

## MySQL表结构同步工具 
- 参考
    - https://github.com/hidu/mysql-schema-sync