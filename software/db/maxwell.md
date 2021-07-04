1. 数据库启用binlog

2. 数据库配置maxwell用户和数据库
```sql
create user 'maxwell'@'%' identified BY '123456';
grant all on maxwell.* TO 'maxwell'@'%';
grant select, replication client, replication slave on *.* to 'maxwell'@'%'; 
```

3. 启动maxwell
```bash
/usr/local/lib/maxwell/maxwell-1.29.2/bin/maxwell --user='maxwell' --password='password' --port=33306 --host='mysql_host' --producer=kafka --kafka.bootstrap.servers=${kafka_host_1}:9092,${kafka_host_2}:9092 --kafka_topic=${topic_name} --filter='exclude: *.*, include: db1.table1, include: db2.table1'
# --producer=kafka
# --producer=stdout
# --producer=file
# --producer=redis
# --producer=rabbitmq

# --log_level=debug # [debug | info | warn | error]

# --init_position
# 手动指定maxwell要从哪个binlog，哪个位置开始。默认从最新的binlog文件开始。指定的格式FILE:POSITION:HEARTBEAT。只支持在启动maxwell的命令指定，比如 --init_postion=mysql-bin.0000456:4:0

# 若需要运行多个Maxwell，需要为每个实例配置不同的client_id和replica_server_id，以存储不同的binlog位点；否则已有的maxwell实例会报错退出。
# --client_id=maxwell #默认
# --replica_server_id=6379 #默认
```