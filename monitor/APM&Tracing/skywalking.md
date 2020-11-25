
- 参考
https://skywalking.apache.org/
https://skywalking.apache.org/zh/blog/2019-03-29-introduction-of-skywalking-and-simple-practice.html
https://blog.csdn.net/wuzhiwei549/article/details/108856398

埋点方式：无侵入
客户端支持：Java, C#, PHP, Node.js, Go

## 组件与架构
- 参考
https://github.com/apache/skywalking/blob/master/docs/en/concepts-and-designs/overview.md

1. Probes 负责采集与格式化数据 对于不同的语言会有不同的agent插件
2. Platform backend 后端逻辑层 OAP
3. Storage 存储  默认自带存储H2, 推荐ElasticSearh
4. UI 前端

- 链路跟踪支持： 
后端服务 游览器 服务网格

## 运行机制
1. 历史数据
Skywalking的数据TTL策略是通过线程定时调用ES API条件删除历史数据。  
目前配置是：链路数据存放7天，每5分钟删除7天前的数据。
工程师发现的缺陷：ES删除缓慢，导致数据堆积。恶性循环下导致本来设置的TTL时间为90分钟，结果却堆积了近5天数据。目前直接把TTL时间改为了7天，数据删除依然缓慢，几乎没有删除掉，导致数据堆积越来越多。


## 安装
- 参考
https://github.com/apache/skywalking/blob/master/docs/en/setup/README.md
### 裸安装
1. wget https://archive.apache.org/dist/skywalking/8.2.0/apache-skywalking-apm-es7-8.2.0.tar.gz
wget https://apache.website-solution.net/skywalking/8.2.0/apache-skywalking-apm-8.2.0.tar.gz 
https://archive.apache.org/dist/skywalking/8.2.0/apache-skywalking-apm-8.2.0.tar.gz

2. 查看后端使用的数据存储
grep "storage:" -A 2 ./config/application.yml

3. UI 、 OAP backend 和 agent 所在的服务器要时钟一致

4. 启动-程序直接在后台运行
./bin/startup.sh

5. 默认端口
8080  UI端口
11800 agent连接的OAP的gRPC端口
12800  rest端口;UI连接OAP的端口
### 配置
- https://github.com/apache/skywalking/blob/master/docs/en/setup/backend/backend-setup.md

config/elasticsearch.yml
```yaml
storage:
  selector: ${SW_STORAGE:elasticsearch7} # 选择后端存储

recordDataTTL: ${SW_CORE_RECORD_DATA_TTL:3} # Unit is day
metricsDataTTL: ${SW_CORE_METRICS_DATA_TTL:7} # Unit is day
```
### 容器安装
- 参考  
https://github.com/apache/skywalking/blob/master/docker/docker-compose.yml
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html 
```yaml
version: '3.5'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.9.0
    container_name: elasticsearch
    restart: always
    ports:
      - 9200:9200
    environment:
      # discovery.type: single-node
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1
  oap:
    image: apache/skywalking-oap-server:8.2.0-es7
    container_name: oap
    depends_on:
      - elasticsearch
    links:
      - elasticsearch
    restart: always
    ports:
      - 11800:11800
      - 12800:12800
    environment:
      SW_STORAGE: elasticsearch7
      SW_STORAGE_ES_CLUSTER_NODES: elasticsearch:9200
      SW_HEALTH_CHECKER: default
      SW_TELEMETRY: prometheus
    healthcheck:
      test: ["CMD", "./bin/swctl", "ch"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
  ui:
    image: apache/skywalking-ui:8.2.0
    container_name: ui
    depends_on:
      - oap
    links:
      - oap
    restart: always
    ports:
      - 8080:8080
    environment:
      SW_OAP_ADDRESS: oap:12800

```

### yum安装
https://pkgs.org/search/?q=ecl-skywalkin

## UI与功能
- 参考
https://github.com/apache/skywalking/blob/master/docs/en/ui/README.md


## Telemetry
- 参考
https://blog.csdn.net/changqing1234/article/details/103669835

是一项远程的从物理设备或虚拟设备上高速采集数据的技术。设备通过推模式（Push Mode）周期性的主动向采集器上推送设备的接口流量统计、CPU或内存数据等信息，相对传统拉模式（Pull Mode）的一问一答式交互，提供了更实时更高速的数据采集功能。

## H2
- 参考  
https://www.cnblogs.com/cnjavahome/p/8995650.html
- H2 是一个用 Java 开发的嵌入式数据库，它本身只是一个类库，即只有一个 jar 文件，可以直接嵌入到应用项目中。
- 主要有如下三个用途：
    1. H2可以同应用程序打包在一起发布，这样可以非常方便地存储少量结构化数据。
    2. 用于单元测试。启动速度快，而且可以关闭持久化功能，每一个用例执行完随即还原到初始状态。
    3. 作为缓存，即当做内存数据库，作为NoSQL的一个补充。当某些场景下数据模型必须为关系型，可以拿它当Memcached使，作为后端MySQL/Oracle的一个缓冲层，缓存一些不经常变化但需要频繁访问的数据，比如字典表、权限表。