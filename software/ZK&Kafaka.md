# Kafka

## 概念
Kafka可以作为 消息队列，消息总线，数据存储平台
topic里的数据会被保存在ZK里

1. 版本
0.8以前的kafka，消费的进度(offset)是写在zk中的，所以consumer需要知道zk的地址，这个方案有性能问题。0.9以及后来的版本都统一由broker管理消费进度，所以consumer就直接请求bootstrap-server，不再需要和 zookeeper 通信了。
## Kafka操作指令
### 基本操作
kafka-console-producer.sh 是用来测试用的脚本，可以模拟kafka消息的发送端。

```bash
# 1. 列出所有的topic
bin/kafka-topics.sh --zookeeper localhost:2181 --list

# 2. 消费topic消息
bin/kafka-console-consumer.sh  --bootstrap-server ${IP}:9092 --topic ${topic} --from-beginning
--from-beginning  # 表示消费topic里的所有数据

# 3. 创建topic
bin/kafka-topics.sh --create --zookeeper localhost:2181 --topic test-topic-1 --partitions 2 --replication-factor 1

# 2. 往topic里面发送消息
bin/kafka-console-producer.sh --broker-list ${IP}:9092 --topic ${topic}

# 4. 删除topic
bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic ${topic}

```

### Others
```
# 压测方法，生产消息

./bin/kafka-producer-perf-test.sh --topic test-rep-one --throughput 1000000 --num-records 2000000 --record-size 350 --producer-props bootstrap.servers=172.16.202.124:9092

# 压测方法，消费消息

./bin/kafka-consumer-perf-test.sh --topic test-topic-1 --messages 1 --zookeeper localhost:2181


# 循环发送消息
while true
do
for i in {1..1500}
do
./bin/kafka-producer-perf-test.sh --topic test-topic-${i} --throughput 1000000 --num-records 200 --record-size 350 --producer-props bootstrap.servers=172.16.202.124:9092
done
done

# 循环消费消息
while true
do
for i in {1..1500}
do
./bin/kafka-consumer-perf-test.sh --topic test-topic-${i} --messages 200 --zookeeper localhost:2181
done
sleep 1s
done

# 循环创建topic
for i in {2..1500}
do
./bin/kafka-topics.sh  --create --zookeeper localhost:2181 --topic test-topic-${i} --partitions 2 --replication-factor 1
done
for i in {2..1500}
do
./bin/kafka-consumer-perf-test.sh --topic test-topic-1 --messages 400 --zookeeper localhost:2181
done
```

