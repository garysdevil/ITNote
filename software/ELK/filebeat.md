# Filebeat
参考文档
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html
- https://www.cnblogs.com/cjsblog/p/9495024.html
- https://segmentfault.com/a/1190000019714761 博客剖析
- https://www.elastic.co/guide/en/beats/filebeat/6.4/filebeat-module-nginx.html 模块

## 概念
- 语言：Golang
- 基于libbeat库进行开发而成。

1. 日志收集，主要由两个组件组成：inputs 和  harvesters
    - version 7.x
    1. 一个 harvester 负责读取一个文件的内容。每个文件启动一个 harvester 。
    2. 一个 input 找到所有要读取的源，负责管理 harvesters。 每个input都在自己的Go协程中运行。


2. 工作流程
    - 不同的harvester goroutine采集到的日志数据都会发送至一个全局的队列queue中，queue的实现有两种：基于内存和基于磁盘的队列，目前基于磁盘的队列还是处于alpha阶段，filebeat默认启用的是基于内存的缓存队列。 
    - 每当队列中的数据缓存到一定的大小或者超过了定时的时间（默认1s)，会被注册的client从队列中消费，发送至配置的后端。目前可以设置的client有kafka、elasticsearch、redis等。
    
3. 组成结构
    - input: 找到配置的日志文件，启动harvester
    - harvester: 读取文件，发送至spooler
    - spooler: 缓存日志数据，直到可以发送至publisher
    - publisher: 发送日志至后端，同时通知registrar
    - registrar: 记录日志文件被采集的状态

4. 内部机制
    1. 保存文件状态在注册表文件registry中
    2. 至少投递一次

## 注意
1. 如果使用容器部署filebeat，需要将registry文件挂载到宿主机上，否则容器重启后registry文件丢失，会使filebeat从头开始重复采集日志文件。

## 安装
1. 通过yum安装
```bash
# 参考 https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch
echo '[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md' >> /etc/yum.repos.d/elastic.repo
yum install filebeat -y
systemctl start filebeat
systemctl enable filebeat
```

## 配置
- 版本 7.X
### input 从日志文件读取数据
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
    exclude_lines: ['127.0.0.1']  # 排除包含此字段的行

    # 自定义键值对输出到output
    # fields:  
    #     mykey: myvalue 
    # tags: ["tag1", "tag2", "tag3"]

    enabled: true # 默认是true；false 则不采集

    # multiline.pattern: '^\< | ^[[:space:]] | ^[[:space:]]+(at|\.{3})\b|^Caused by: | ^\[[0-9]{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\]'  # 正则，自定义，“|” 表示可以匹配多种模式
    multiline.pattern: '^{'
    multiline.negate: true # 默认是false，匹配pattern的行合并到上一行；true，不匹配pattern的行合并到上一行
    multiline.match: after # 合并到上一行的末尾或开头
    max_lines: 500 # default 500;可合并的最大行数
    max_bytes: 10485760 # default 10MB

    tail_files: true # 默认是false； true 从新文件的最后位置开始读取,而不是从开头读取新文件
    ignore_older: 1h # default disabled # 忽略指定时间段以外修改的日志内容，例如 2h 或 5m
    clean_inactive: 24h # 删除不活跃的文件状态
    clean_removed: true # default true;

    # 以下两个参数在7.x版本后被其它参数取代了
    force_close_files: true  # default false; true 只要filebeat检测到文件名字发生变化，就会关掉这个handle；可以防止由于文件被删除但句柄还在从而导致磁盘占用空间不被释放
    close_older: 30m # default 1h 如果一个文件在某个时间段内没有发生过更新，则关闭监控的文件handle

    processors: # 过滤器
    - drop_fields: # 删除一些字段
        fields: ["log"]

```

2. version 6.1 https://www.elastic.co/guide/en/beats/filebeat/6.1/configuration-filebeat-options.html
filebeat.yml
```yaml
filebeat.config:
  prospectors:
    path: ${path.config}/prospectors.d/*.yml # 包含的input配置

```


### output 数据输出 
1. 配置示范 输出到logstash
```yaml
    output.logstash:
        hosts: ["127.0.0.1:5044"]
        # 输出至Elastic Cloud
        cloud.id: ${ELASTIC_CLOUD_ID}
        cloud.auth: ${ELASTIC_CLOUD_AUTH}
```

2. 配置示范 输出到elasticsearch
```yaml
# 解析json格式日志
processors:
  - decode_json_fields:
      fields: ['message']
      target: ''
      overwrite_keys: true

setup.template.settings:
  index.number_of_shards: 1
  index.number_of_replicas: 0
setup.template.enabled: true
setup.template.name: "project-prod"
setup.template.pattern: "project-prod-*"
# 从7.0版开始，Filebeat在连接到支持生命周期管理的集群时默认使用索引生命周期管理（ILM）。
# 默认的elasticsearch索引生命周期为50GB+30天。 默认值为 auto， auto/true/false
# 默认会自动创建elasticsearch索引。filebeat-%{[agent.version]}-%{+yyyy.MM.dd}-000001
setup.ilm.enabled: false
# setup.ilm.policy_name: "mypolicy"

# 如果启用了Elasticsearch输出，Filebeat会自动加载推荐的模板文件fields.yml
# setup.template.fields: "./fields.yml"





# josn格式的配置文件
# if "myvalue" == [mykey] {}
# if "tag1" in [tags] {}
output.elasticsearch:
    hosts: ["IP:9200"]
    index: "project-default-%{[agent.version]}-%{+yyyy.MM.dd}" # 默认索引
    indices:
        - index: "warning-%{[agent.version]}-%{+yyyy.MM.dd}"
            when.equals:
                mykey: "WARN"
        - index: "error-%{[agent.version]}-%{+yyyy.MM.dd}"
            when.contains:
                tags: "ERR"
```

### others
```conf
# Filebeat自身日志配置
logging.level: debug
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644

```

### 标准输入标准输出
```yaml
filebeat.inputs:
- type: stdin
  enabled: true

output.console:
  pretty: true
  enable: true
```
### 模块
1. es
```bash
# 这两个插件用来捕获地理位置和浏览器信息，以供可视化组件所用
sudo bin/elasticsearch-plugin install ingest-geoip
sudo bin/elasticsearch-plugin install ingest-user-agent
```
重启Elasticsearc

2. 设置初始环境
```bash
# Setup index template, dashboards and ML jobs
./filebeat setup -e
```

3. 开启nginx模块
```bash
./filebeat modules enable nginx
```
```yaml
filebeat.config.modules: 
    path: ${path.config}/modules.d/*.yml # 需要加载的模块配置文件的位置
    # 直接在次配置文件里配置nginx模块进行日志收集
    - module: nginx
    access:
        enabled: true
        # Set custom paths for the log files. If left empty,
        # Filebeat will choose the paths depending on your OS.
        var.paths: ["/var/log/nginx/access*.log"]
        # Input configuration (advanced). Any input configuration option
        # can be added under this section.
    error:
        enabled: true
        var.paths: ["/var/log/nginx/error.log"]
```

## 模块 -- Elasticsearch Pipeline
- 参考
    - https://blog.csdn.net/xujiamin0022016/article/details/86306571

- 在ES 5.x之后的版本中，ES增量了Ingest node功能（对数据进行预处理）


## 指令
```bash
# 指定家目录 --path.home ./

# 1 查看支持哪些模块
./filebeat modules list
# 2 启动nginx模块
./filebeat modules enable nginx
# 3 禁用nginx模
./filebeat modules disable nginx

# 检验配置文件
filebeat test config filebeat.yml

# debug
./filebeat -c filebeat.yml
# -e: Filebeat日志输出到标准输出，默认输出到syslog和logs下 
# -c: 指定配置文件
# -d: 启用对指定选择器的调试 # 没用过
```

## 调优
正常启动filebeat，一般确实只会占用3、40MB内存。

- filebeat内存
1. 运行的容器个数较多，导致创建大量的harvester去采集日志。
2. 内存占据较大部分的是memqueue，所有采集到的日志都会先发送至memqueue聚集，再通过output发送出去。每条日志的数据在filebeat中都被组装为event结构，filebeat默认配置的memqueue缓存的event个数为4096，可通过queue.mem.events设置。
默认最大的一条日志的event大小限制为10MB，可通过max_bytes设置。
4096 * 10MB = 40GB 。极端场景下，filebeat至少占据40GB的内存。特别是配置了multiline多行模式的情况下，如果multiline配置有误，单个event误采集为上千条日志的数据，很可能导致memqueue占据了大量内存，致使内存爆炸。  