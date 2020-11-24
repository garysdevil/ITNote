
[TOC]
官网文档
https://prometheus.io/docs/introduction/overview/
blog：
https://prometheus.io/blog/
https://www.jianshu.com/p/2c49e59c6fdd
数据存储
https://blog.csdn.net/yetugeng/article/details/83304514
数据类型
https://blog.csdn.net/polo2044/article/details/83277299
## 基本
### 一 prometheus概览
1. 适用场景：
    样本值为纯数字。https://prometheus.io/docs/introduction/faq/#why-are-all-sample-values-64-bit-floats-i-want-integers
1. 特性
    支持远程读写
    通过集群部署支持高可用 https://prometheus.io/docs/introduction/faq/#can-prometheus-be-made-highly-available
    支持扩展/联邦制 https://prometheus.io/docs/introduction/faq/#why-are-all-sample-values-64-bit-floats-i-want-integers
    
    多维数据模型【时序由 metric（指标） 名字和 k/v 的 labels 构成】。
    灵活的查询语句（PromQL）。
    无依赖存储。
    采用 http 协议，使用 pull 模式拉取数据。
    监控目标，可以采用服务发现或静态配置的方式。
    支持多种统计数据模型。

1. 组件
    - prometheus server 
    - pushGateway
    - alertmanager
    - exporters
    - client libraries
2. 数据存储：
    - TSDB （时间序列数据库）
    - 
3. Merics 指标类型：
https://prometheus.io/docs/concepts/metric_types/
https://frezc.github.io/2019/08/03/prometheus-metrics/
- 样本值都是以 float64的浮点类型 存储在时序数据库里面。
    - Counter（计数器）
        采样值只增不减
    - Guage（仪表盘）
        采样值可增可减
    - Histogram（直方图）
        分组计数，采样值小于le值的个数 <basename>_bucket{le="<upper inclusive bound>"}
        所有观测值的总和 <basename>_sum
        已观察到的事件的计数 <basename>_count (identical to <basename>_bucket{le="+Inf"} above)
    - Summary（摘要）
        分组统计百分比，百分比小于quantile的采样值 <basename>{quantile="<φ>"}
        所有观测值的总和 <basename>_sum
        已观察到的事件的计数 <basename>_count

4. job 和 instance
https://prometheus.io/docs/concepts/jobs_instances/
    - instance 表示每一个采集器，由IP+端口组成
    - job 表示一种相同类型的instance
每个instance都自带的metrics
up{job="<job-name>", instance="<instance-id>"}
scrape_duration_seconds{job="<job-name>", instance="<instance-id>"}
scrape_samples_post_metric_relabeling{job="<job-name>", instance="<instance-id>"}
scrape_samples_scraped{job="<job-name>", instance="<instance-id>"}
scrape_series_added{job="<job-name>", instance="<instance-id>"}

5. Prometheus Server 配置
    - 服务发现
    - relable

### 二 Prometheus Server

#### 管理Prometheus的API与指令
- 1，2，3也使用于AlertManager，PushGateway和prometheus-webhook-dingtalk
1. 健康检查
    curl http://localhost:9090/-/healthy
2. 数据可查询性检查
    curl http://localhost:9090/-/ready
3. 热加载配置文件
    curl -X POST http://localhost:9090/-/reload
4. 关闭组件
    curl -X POST http://localhost:9090/-/quit
5. 获取告警项/实例
    curl -s http://localhost:9090/alerts | grep active
    curl -s http://localhost:9090/alerts | grep  -A 1 job_header
    curl -s http://localhost:9090/alerts | grep -C 3 instance
    curl -s http://localhost:9090/targets | grep -A 2 table-container

6. 正确的关闭进程 kill -TERM 进程号

7. 重新加载配置 kill -1 进程号  or kill HUP 进程号

#### Prometheus Server相关配置的语法检查器 
1. 下载安装工具
go get github.com/prometheus/prometheus/cmd/promtool

2. 语法检查
./promtool check config prometheus.yml
./promtool check rules prometheus.rules.yml

#### Prometheus简单测试
1. 下载安装测试工具
git clone https://github.com/prometheus/client_golang.git 
cd client_golang && go get -d && go build

2. 启动agent
./random -listen-address=:8081 &

### 三 PushGateway
1. 常用API
- 推送数据进PushGateway
echo "test_metric 2333" | curl --data-binary @- http://127.0.0.1:9091/metrics/job/test_job
curl -XPOST --data-binary @data.txt http://127.0.0.1:9091/metrics/job/nginx/instance/172.27.0.3

- 删除PushGateway上的数据
curl -X DELETE http://127.0.0.1:9091/metrics/job/nginx/instance/172.27.0.3

### 四 prometheus告警工具
#### Alertmanager
- 概览
接收器receiver，分组group
- 
https://github.com/prometheus/alertmanager

1. cli工具amtool
- 查看所有正在发生的告警
  ./amtool alert --alertmanager.url http://127.0.0.1:9093 alertname="通过告警名称进行过滤" instance=~"通过实例名称进行正则表达式过滤"
- 查看所有告警路由
  ./amtool config routes --alertmanager.url http://127.0.0.1:9093
- 配置文件语法检查 
  ./amtool check-config alertmanager.yml
- 配置文件语法的检查和信息查看
  ./amtool check-config alertmanager.yml
2. 常用API：https://github.com/prometheus/alertmanager/blob/master/api/v2/openapi.yaml
- 查看所有正在发生的告警
curl http://localhost:9093/api/v2/alerts

- 重新加载配置文件
curl -X POST http://127.0.0.1:9093/-/reload

3. 配置讲解
    group_wait: 30s  指定同一组的告警信息等待多长时间后再发送
    group_interval: 1s  指定同一组的告警信息间隔多久发送
    repeat_interval: 1h  指定告警多久没回复后再次发送信息

4. Inhibitor 抑制

5. Silencer 静默

### k8s监控组件 
  监控指标        具体实现                   举例
  pod性能         cadvisor                  容器的cpu、内存利用率（k8s内部提供）
  node性能        node-exporter             node节点的cpu、内存利用率
  k8s资源对象     kube-state-metrics        pod/deployment/service
  性能分析工具    heapster->metrics-server   器集群监控和性能分析工具
- cadvisor各个指标含义：
https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md
- 从 v1.8 开始，资源使用情况的监控可以通过 Metrics API的形式获取，具体的组件为Metrics Server，用来替换之前的heapster，heapster从1.11开始逐渐被废弃。
Kubernetes 的核心监控数据，需要通过 API server 的 /apis/metrics.k8s.io/ 路径获取，只有部署了 Metrics Server 应用程序后这个 API 才可用。
Metrics Server 是集群级别的资源利用率数据的聚合器，直接取代了 Heapster 项目。Metrics Server 并不是 API server 的一部分，而是通过 Aggregator 插件机制注册到主 API server 之上，然后基于 kubelet 的 Summary API 收集每个节点的指标数据，并存在内存里以指标 API 格式提供
metrics-server 应用程序默认会从 kubelet 的 10250 端口基于 HTTP API 获取指标数据，如果不修改可能会导致其部署完成后无法正常获取数据。
### 数据的获取
- Prometheus通过HTTP接口的方式从各种客户端获取数据，这些客户端必须符合Prometheus监控数据格式。
1. 侵入式埋点监控
通过在客户端集成，Kubernetes API直接通过引入Prometheus go client，提供/metrics接口查询kubernetes API各种指标
2. 通过exporter方式
在外部将原来 各种中间件的监控支持 转化为Prometheus的监控数据格式。
可以理解成监控适配器，将不同指标类型和格式的数据统一转化为Prometheus能够识别的指标类型。

### 配置监控对象
1. 通过静态文件配置
2. 通过动态发现机制，自动注册监控对象。

## 深入
### storage
1. block 的目录结构     
    2. chunks          　　是个目录、保存压缩后的timeseries数据，每个chunks大小为512M，超过会生成新的chunks
    3. meta.json           记录block块元信息，比如 样本的起始时间、chunks数量和数据量大小等
    4. index           　　通过metric名和labels查找时序数据在chunk文件中的位置
    5. tombstones  　　　　 删除操作会首先记录到这个文件

2. wal目录结构 临时存储在内存里数据的binlog日志
    1. 00000369  每个数据段最大为128M，老版本默认大小是256M
    2. heckpoint.000365 

为防止程序异常而导致数据丢失，采用了WAL机制，即2小时内记录的数据存储在内存中的同时，还会记录一份日志，存储在block下的wal目录中。当程序再次启动时，会将wal目录中的数据写入对应的block中，从而达到恢复数据的效果。

### Memory
1. 内存使用测量
https://www.robustperception.io/how-much-ram-does-prometheus-2-x-need-for-cardinality-and-ingestion
#### 内存溢出问题

1. https://developer.aliyun.com/article/765358
异常恢复问题：Prometheus使用binlog的方式将实时写入的数据持久化，在crash的时候会重新回放binlog来恢复。但由于数据在内存中保存2小时，一次恢复的时间可能很长，而一旦是因为OOM问题重启，Prometheus将无限重启下去。


2. 参考资料
https://stackoverflow.com/questions/56115912/why-does-prometheus-consume-so-much-memory
https://groups.google.com/g/prometheus-users/c/K-63dBkJwuY?pli=1
https://www.cnblogs.com/chenmingming0225/p/12634250.html

3. memory limiting
Prometheus 2.x has no memory limiting, because it doesn't have a separate cache memory like 1.x had.
Prometheus 1.x, the memory flag was not a limit, but a target. It would easily use more than the target limit.

4. 内存与磁盘
storage.tsdb.max-block-duration	设置数据块最大时间跨度，默认为最大data chunks保留时间的 10%
storage.tsdb.min-block-duration	设置数据块最小时间跨度，默认 2h 的数据量。内存中的head block在此范围之后它们将被持久化。监控数据是按块（block）存储，每一个块中包含该时间窗口内的所有样本数据

5. 1.X version  github说没有内存限制效果
https://www.bookstack.cn/read/prometheus-manual/operating-storage.md
https://www.cnblogs.com/davygeek/p/6668706.html
storage.local.memory-chunks  设定prometheus内存中保留的chunks的最大个数，默认为1048576，即为1G大小  
storage.local.series-file-shrink-ratio
storage.local.max-chunks-to-persist 该参数控制等待写入磁盘的chunks的最大个数，如果超过这个数，Prometheus会限制采样的速率，直到这个数降到指定阈值的95%。建议这个值设定为storage.local.memory-chunks的50%。Prometheus会尽力加速存储速度，以避免限流这种情况的发送。

#### 内存消耗
1. prometheus tsdb has a memory block which is named: "head", because head stores all the series in latest hours, it will eat a lot of memory.
prometheus按照block块的方式来存储数据，每2小时为一个时间单位，首先会存储到内存中，当到达2小时后，会自动写入磁盘中。（耗内存随着数据量增大，耗内存可能会很大）

2. each block on disk also eats memory, because each block on disk has a index reader in memory, dismayingly, all labels, postings and symbols of a block are cached in index reader struct, the more blocks on disk, the more memory will be cupied.
每个block都会将一些索引信息存放在内存中（耗内存稳定）


3. 大量的查询和数据的读取（中）
https://www.robustperception.io/new-features-in-prometheus-2-5-0
2.5版本后新增 --query.max-samples
--query.max-samples=50000000



### 自身的监控
scrape_samples_scraped  目标暴露的样本数量
scrape_samples_post_metric_relabeling 指标重打标签后，剩余的样本数量
scrape_duration_seconds 抓取目标消耗的时间
up 如果实例可达则取值1，否则0



