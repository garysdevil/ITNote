
## 安装
1. 数据库启用binlog

2. 数据库配置maxwell用户和数据库
```sql
create database maxwell;
create user 'maxwell'@'%' identified BY 'maxwell';
grant all on maxwell.* TO 'maxwell'@'%';
grant select, replication client, replication slave on *.* to 'maxwell'@'%'; 
```

3. 安装maxwell-1.33
    - java-11 
    - https://github.com/zendesk/maxwell/releases/download/v1.33.1/maxwell-1.33.1.tar.gz

4. 启动maxwell
```bash
./bin/maxwell  --user='maxwell' --password='password' --port=3306 --host='localhost' --producer=stdout


./bin/maxwell --user='maxwell' --password='password' --port=3306 --host='mysql_host' --producer=kafka --kafka.bootstrap.servers=${kafka_host_1}:9092,${kafka_host_2}:9092 --kafka_topic=${topic_name} --filter='exclude: *.*, include: db1.table1, include: db2.table1'
# --producer=kafka
# --producer=stdout
# --producer=file
# --producer=redis
# --producer=rabbitmq

# --log_level=debug # [debug | info | warn | error]

# --config 指定配置文件

# --init_position
# 手动指定maxwell要从哪个binlog，哪个位置开始。默认从最新的binlog文件开始。指定的格式FILE:POSITION:HEARTBEAT。只支持在启动maxwell的命令指定，比如 --init_postion=mysql-bin.0000456:4:0

# 若需要运行多个Maxwell，需要为每个实例配置不同的client_id和replica_server_id，以存储不同的binlog位点；否则已有的maxwell实例会报错退出。
# --client_id=maxwell #默认
# --replica_server_id=6379 #默认
```

5. 通过配置文件启动maxwell ./bin/maxwell --config config.properties
```conf
# tl;dr config
log_level=warn

#producer=stdout
producer=kafka
kafka.bootstrap.servers=${IP}:${PORT},${IP_1}:${PORT_2}
kafka_topic=${Topic_Name}

# mysql login info
host=${IP}
user=maxwell_1_33
password=maxwell_1_33
# name of the mysql database where maxwell keeps its own state
schema_database=maxwell_1_33

filter= exclude: *.*, include: db1.table1
```