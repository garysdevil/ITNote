- 参考文档
https://prometheus.io/docs/prometheus/latest/querying/functions/
https://blog.csdn.net/changzhehuan7809/article/details/100969240

- 数据类型
    - query 瞬时向量
    - query_range 区间向量
    - scalar 标量
    - series 元数据
### 表达式
1. rate()
    - 含义：配合counter类型数据，取counter在这个时间段中的平均每秒增量。
    - 场景：监控网络接受字节数的情况，在9:10到9:20期间累计量增加了1000bytes，加入rate([1m])函数后就会使用1000除以60秒，计算出数据大约为16bytes。
    - 案例：rate(  node_network_receive_bytes[1m] )  # 获取1分钟内每秒的增量
1. irate()
    - 含义：配合counter类型数据，取counter在这个时间段中最近两个数据点来算速率。
2. increase() 
    - 含义：和rate()函数一样也是配合Counter使用。区别就是它是取其中一段时间的增量而不是平均值.
    - 案例：increase(node_cpu[1m])  # 获取CPU总使用时间1分钟的增量

3. sum()
    - 场景：在工作中CPU大多是多核的，而node_cpu会将每个核的数据都单独显示出来，我们其实不会关注每个核的单独情况，而是关心总的CPU情况。使用sum()函数进行求和后可以得出一条总的数据。
    - 案例：sum( increase(node_cpu[1m]) )
4. count()
    - 案例 count(count_netstat_wait_connections > 200) # 当CPU使用率大于80%的机器达到200台就进行报警
5. topk()
    - 含义：从大量数据中取出排行前N的数值
    - 案例：topk(3,count_netstat_wait_connections)  # Gauge类型
6. bottomk()
    含义：从大量数据中排序取出后N个数值
5. absent()
    含义：如果传递给它的向量具有任何元素，则返回空向量; 如果传递给它的向量没有元素，则返回值为1的1元素向量。

5. delta()
    含义：计算范围向量v中每个时间系列元素的第一个和最后一个值之间的差值，返回具有给定增量和等效标签的即时向量。 
    案例：delta(cpu_temp_celsius{host="zeus"}[2h])

6. changes()
    含义： 计算范围向量v中 时间序列数据 被更改的次数

6. histogram_quantile()

7. time()
time() returns the number of seconds since January 1, 1970 UTC. Note that this does not actually return the current time, but the time at which the expression is to be evaluated.

### 常用表达式
1. 一段时间内的平均值排序
sort_desc(sum(avg_over_time(aws_elb_request_count_sum[1h]))without(availability_zone))
#### K8s Pod常用
- Pod 的cpu使用率
sum(rate(container_cpu_usage_seconds_total{image!=""}[1m])) by (pod_name, namespace) / (sum(container_spec_cpu_quota{image!=""}/100000) by (pod_name, namespace)) * 100

- Pod 内存使用率
sum(container_memory_rss{image!=""}) by(pod_name, namespace) / sum(container_spec_memory_limit_bytes{image!=""}) by(pod_name, namespace) * 100 != +inf

- Pod 文件系统使用量
sum(container_fs_usage_bytes{image!=""}) by(pod_name, namespace) / 1024 / 1024 / 1024
#### node 常用
- node cpu 使用率
(100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)) > 80


### 查询-操作数据库

1. 瞬时向量查询格式：
curl http://localhost:9090/api/v1/query_range?query=xxx&&time=时间戳
示范：
curl http://localhost:9090/api/v1/query?query=gluster_volume_heal_count
curl -g 'http://localhost:9090/api/v1/query?query=up{job="test"}'
curl -g http://localhost:9090/api/v1/query?query="gluster_volume_heal_count{volume='vol_b13542d3dc9366b65b2713a8b11f83f6'}[2m]"

2. 区间向量查询格式：
curl http://localhost:9090/api/v1/query_range?query=xxx&start=xxx&end=xxx&step=xxx

3. 标量
示范：
count(go_gc_duration_seconds)

4. 元数据
curl curl -g 'http://localhost:9090/api/v1/series?match[]=xxx&start=xxx&end=xxx
示范：
curl -g 'http://localhost:9090/api/v1/series?match[]=gluster_volume_heal_count{volume="vol_b13542d3dc9366b65b2713a8b11f83f6",brick_path="/var/lib/heketi/mounts/vg_c19e716af761047bb57c2f3392bd71d0/brick_eba56e37e81f691bc4b8b2ad026ec76a/brick"}'

5. 其它
获取所有的标签：
curl http://127.0.0.1:9090/api/v1/labels
获取某个标签的值
curl http://127.0.0.1:9090/api/v1/label/标签名称/values
获取所以的instance
curl http://127.0.0.1:9090/api/v1/targets?state=active|dropped|any
获取所有的告警规则和记录规则
curl http://127.0.0.1:9090/api/v1/rules?type=alert|record
获取所有正在发生的告警
curl http://localhost:9090/api/v1/alerts
返回元数据
curl http://localhost:9090/api/v1/metadata?metric=指标名称
查询当前alertmanager的状态
curl http://localhost:9090/api/v1/alertmanagers
获取当前的配置
curl http://localhost:9090/api/v1/status/config
运行信息
curl http://localhost:9090/api/v1/status/runtimeinfo

数据状态变为deleted，如果不指定start和end就指定所有匹配的数据
curl -X POST -g 'http://localhost:9090/api/v1/admin/tsdb/delete_series?match[]=up&match[]=process_start_time_seconds{job="prometheus"}'


清空被删除的数据
curl -XPOST http://localhost:9090/api/v1/admin/tsdb/clean_tombstones
