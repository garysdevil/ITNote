# Filebeat
参考文档
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html
- https://www.cnblogs.com/cjsblog/p/9495024.html
- https://segmentfault.com/a/1190000019714761
## 概念
- 语言：Golang
- 基于libbeat库进行开发而成。
1. 工作流程
    不同的harvester goroutine采集到的日志数据都会发送至一个全局的队列queue中，queue的实现有两种：基于内存和基于磁盘的队列，目前基于磁盘的队列还是处于alpha阶段，filebeat默认启用的是基于内存的缓存队列。 
    每当队列中的数据缓存到一定的大小或者超过了定时的时间（默认1s)，会被注册的client从队列中消费，发送至配置的后端。目前可以设置的client有kafka、elasticsearch、redis等。
    
2. 代码的实现角度
    input: 找到配置的日志文件，启动harvester
    harvester: 读取文件，发送至spooler
    spooler: 缓存日志数据，直到可以发送至publisher
    publisher: 发送日志至后端，同时通知registrar
    registrar: 记录日志文件被采集的状态

3. 注意
    如果使用容器部署filebeat，需要将registry文件挂载到宿主机上，否则容器重启后registry文件丢失，会使filebeat从头开始重复采集日志文件。
## 组成

- version 7.x
### 日志收集，主要由两个组件组成：inputs 和  harvesters
1. 一个 harvester 负责读取一个文件的内容。每个文件启动一个 harvester 。
2. 一个 input 找到所有要读取的源，负责管理 harvesters 。 每个input都在自己的Go协程中运行。
- 内部机制
    1. 保存文件状态在注册表文件registry中
    2. 至少投递一次
- 配置示范 从日志文件读取
```yaml
filebeat.config: # 全局配置
    inputs: # 包含额外的input文件列表
        enabled: true
        path: inputs.d/*.yml
    modules: # 包含额外的module文件列表
        enabled: false
        path: ${path.config}/modules.d/*.yml

filebeat.inputs:
- type: log
    paths: # 采集的文件位置
        - /var/log/*.log
        - /var/path2/*.log
    fields:  # 自定义属性输出到output
        key: value 
    reload.enabled: false
    multiline.pattern: '^\<|^[[:space:]]|^[[:space:]]+(at|\.{3})\b|^Caused by:'  # 正则，自定义，一个表示可以匹配多种模式使用or 命令也就是“|”
    multiline.negate: false # 默认是false，匹配pattern的行合并到上一行；true，不匹配pattern的行合并到上一行
    multiline.match: after # 合并到上一行的末尾或开头
    processors: # 过滤器
    - drop_fields: # 删除一些字段
        fields: ["log"]



```

3. version 6.1 https://www.elastic.co/guide/en/beats/filebeat/6.1/configuration-filebeat-options.html
filebeat.yml
```yaml
filebeat.config:
  prospectors:
    path: ${path.config}/prospectors.d/*.yml # 包含的input配置

```


### 日志输出 output
    - 配置示范 输出到logstash
```yaml
    output.logstash:
    hosts: ["127.0.0.1:5044"]
    # 输出至Elastic Cloud
    cloud.id: ${ELASTIC_CLOUD_ID}
    cloud.auth: ${ELASTIC_CLOUD_AUTH}
```
 - xxx

### 模块
1. 
```bash
sudo bin/elasticsearch-plugin install ingest-geoip
sudo bin/elasticsearch-plugin install ingest-user-agent
```
重启Elasticsearc
1.使用
```yaml
filebeat.modules: # 使用模块
    - module: nginx
    access: # Access logs
        enabled: true
        # Set custom paths for the log files. If left empty,
        # Filebeat will choose the paths depending on your OS.
        var.paths:
        # Input configuration (advanced). Any input configuration option
        # can be added under this section.
        input:
    error: # 
```

## 指令
1. 查看支持哪些模块
./filebeat modules list
2. 启动nginx模块
./filebeat modules enable nginx
3. 禁用nginx模
./filebeat modules disable nginx

## 调优
正常启动filebeat，一般确实只会占用3、40MB内存。

- filebeat内存
1. 运行的容器个数较多，导致创建大量的harvester去采集日志。
2. 内存占据较大部分的是memqueue，所有采集到的日志都会先发送至memqueue聚集，再通过output发送出去。每条日志的数据在filebeat中都被组装为event结构，filebeat默认配置的memqueue缓存的event个数为4096，可通过queue.mem.events设置。
默认最大的一条日志的event大小限制为10MB，可通过max_bytes设置。
4096 * 10MB = 40GB 。极端场景下，filebeat至少占据40GB的内存。特别是配置了multiline多行模式的情况下，如果multiline配置有误，单个event误采集为上千条日志的数据，很可能导致memqueue占据了大量内存，致使内存爆炸。  