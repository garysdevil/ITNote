# zookeeper 
## 概念
1. 需求与愿景
    1. 分布式架构出现后，越来越多的分布式系统会面临数据一致性的问题.
    2. zookeeper作为分布式协调框架，存储数据，保证分布式系统数据的最终一致性。
    3. 功能包括： 配置维护、域名服务、分布式同步、组服务等

2. 集群的节点必须是基数
    1. 防止脑裂
    2. 容错(n-1)/2

## 运维
1. 默认端口 2181

2. 查看集群状态
echo status | nc localhost 2181

# Kafka

## 概念
1. Kafka 可以作为 消息队列，消息总线，数据存储平台
2. topic里的数据会被保存在ZK里

3. 版本
    - 0.8以前的kafka，消费的进度(offset)是写在zk中的，所以consumer需要知道zk的地址，这个方案有性能问题。0.9以及后来的版本都统一由broker管理消费进度，所以consumer就直接请求bootstrap-server，不再需要和 zookeeper 通信了。

## 运维

- 部署kafka客户端
```bash
sudo yum install java-1.8.0
wget https://archive.apache.org/dist/kafka/2.2.1/kafka_2.12-2.2.1.tgz
tar -xzf kafka_2.12-2.2.1.tgz
```

- 默认端口 9092

## Kafka操作指令
### 基本操作
1. 启停
```bash
# 起zk
bin/zookeeper-server-start.sh config/zookeeper.properties &
# 起kafka
bin/kafka-server-start.sh -daemon ../config/server.properties
# 停kafka
bin/kafka-server-stop.sh
```
2. zk级别操作
```bash
Topic='test-topic-1'
IP=

# 1. 列出所有的topic # 通过zookeeper端口
bin/kafka-topics.sh --zookeeper ${IP}:2181 --list

# 2. 创建topic # 通过zookeeper端口
bin/kafka-topics.sh --create --zookeeper ${IP}:2181 --topic ${Topic} --partitions 2 --replication-factor 1

# 3. 删除topic # 通过zookeeper端口
bin/kafka-topics.sh --delete --zookeeper ${IP}:2181 --topic ${Topic}
```

3. kafka级别操作

client.properties
```conf
# cp /usr/lib/jvm/JDKFolder/jre/lib/security/cacerts /tmp/kafka.client.truststore.jks
security.protocol=SSL
ssl.truststore.location=/tmp/kafka.client.truststore.jks
```
```bash
# 1. 往topic里面发送消息
bin/kafka-console-producer.sh --broker-list ${IP}:9092 --topic ${Topic} # 交互式
echo "hello" | bin/kafka-console-producer.sh  --broker-list ${IP}:9092 --sync --topic ${Topic} # 非交互式
# --producer.config client.properties # 加密认证

# 2. 消费topic消息
bin/kafka-console-consumer.sh  --bootstrap-server ${IP}:9092 --topic ${Topic} --from-beginning
# --from-beginning  # 表示消费topic里的所有数据
# --consumer.config client.properties # 加密认证

# 查看消费者consumer group列表
./bin/kafka-consumer-groups.sh  --bootstrap-server ${IP}:9092 --list

# 查看消费者详情
./bin/kafka-consumer-groups.sh  --bootstrap-server --bootstrap-server ${IP}:9092 --describe --group ${group_name}
# CURRENT-OFFSET 当前已消费的条数
# LOG-END-OFFSET 总条数
# LAG 未消费的条数

# 获取当前topic消息数量
bin/kafka-run-class.sh kafka.tools.GetOffsetShell --topic ${topic_name}  --time -2 --broker-list ${IP}:9092  --partitions 0
# --time -1 获取指定topic所有分区当前的最大位移，表示的是历史上该topic生产的最大消息数量
# --time -2 获取当前最早位移，表示被删除的消息数量
# 当前topic消息数量 = $(--time -1）- $(--time -2)
```