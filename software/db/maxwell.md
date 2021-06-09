1. 
```bash
/usr/local/lib/maxwell/maxwell-1.29.2/bin/maxwell --user='maxwell' --password='password' --port=33306 --host='mysql_host' --producer=kafka --kafka.bootstrap.servers=${kafka_host_1}:9092,${kafka_host_2}:9092 --kafka_topic=${topic_name} --filter='exclude: *.*, include: db1.table1, include: db2.table1'
# --producer=kafka
# --producer=stdout
# --producer=file
# --producer=redis
# --producer=rabbitmq

# --log_level=debug # [debug | info | warn | error]

# --init_position
# 手动指定maxwell要从哪个binlog，哪个位置开始。指定的格式FILE:POSITION:HEARTBEAT。只支持在启动maxwell的命令指定，比如 --init_postion=mysql-bin.0000456:4:0
```