
- 参考
https://skywalking.apache.org/
https://skywalking.apache.org/zh/blog/2019-03-29-introduction-of-skywalking-and-simple-practice.html

埋点方式：无侵入
客户端支持：Java, C#, PHP, Node.js, Go

## 组件与架构
- 参考
https://github.com/apache/skywalking/blob/master/docs/en/concepts-and-designs/overview.md

Probes 负责采集与格式化数据 对于不同的语言会有不同的agent插件
Platform backend 后端逻辑层 OAP
Storage 存储  默认自带存储H2, 推荐ElasticSearh
UI 前端


链路跟踪支持： 后端服务 游览器 服务网格
## 安装
- 参考
https://github.com/apache/skywalking/blob/master/docs/en/setup/README.md
### 裸安装
1. wget https://archive.apache.org/dist/skywalking/8.2.0/apache-skywalking-apm-es7-8.2.0.tar.gz
https://apache.website-solution.net/skywalking/8.2.0/apache-skywalking-apm-8.2.0.tar.gz 
https://archive.apache.org/dist/skywalking/8.2.0/apache-skywalking-apm-8.2.0.tar.gz

2. 查看后端使用的数据存储
grep "storage:" -A 2 ./config/application.yml

3. UI 、 OAP backend 和 agent 所在的服务器要时钟一致

4. 启动
./bin/startup.sh
8080  UI端口
11800 agent连接的OAP的gRPC端口
12800  rest端口;UI连接OAP的端口
### 配置
config/elasticsearch.yml
```conf
   # 每个节点分片量
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
## Agent
### SkyAPM PHP
- 参考
https://github.com/SkyAPM/SkyAPM-php-sdk
https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md
#### 裸安装 v4.0.1
1. 安装文档 https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md
2. 遇到的错误
```
sudo apt install build-essential libssl-dev
sudo apt remove --purge cmake
# find last stable release at https://github.com/Kitware/CMake/releases and download the source .tar.gz,eg:
wget https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz
tar -zxvf cmake-3.18.4.tar.gz
cd cmake-3.18.4
./bootstrap
make 
sudo make install
```
```bash 
sudo yum install build-essential libssl-dev
# sudo apt remove --purge cmake
# find last stable release at https://github.com/Kitware/CMake/releases and download the source .tar.gz,eg:
wget https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz
tar -zxvf cmake-3.18.4.tar.gz
cd cmake-3.18.4
./bootstrap
make 
sudo make install
```
3. php配置
php.ini
```conf
[PHP]
; Loading extensions in PHP
extension=skywalking.so

; enable skywalking
skywalking.enable = 1

; Set skyWalking collector version (5 or 6 or 7 or 8)
skywalking.version = 8

; Set app code e.g. MyProjectName
skywalking.app_code = MyProjectName

; Set grpc address
skywalking.grpc=127.0.0.1:11800
```
#### 容器安装含有SkyAPM PHP扩展的PHP程序
docker run -d -e SW_OAP_ADDRESS=127.0.0.1:11800  -p 9000:9000 skyapm/skywalking-php

#### yum安装
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