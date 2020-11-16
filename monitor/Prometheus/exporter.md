## Exporter
### mysqld_exporter
https://github.com/prometheus/mysqld_exporter

1. 在mysql里创建用户
CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'password';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost' WITH MAX_USER_CONNECTIONS 3;
commit;
FLUSH PRIVILEGES;

2. 写mysqld_exporter的配置文件 vim .my.cnf
[client]
user=exporter
password=xieshigang
socket=/opt/mysql/datadir/mysql.sock

3. 启动
./mysqld_exporter --config.my-cnf=.my.cnf
/opt/mysqld_exporter/mysqld_exporter --config.my-cnf=/opt/mysqld_exporter/.my.cnf

### node-exporter
主要通过读取linux的/proc以及/sys目录下的虚拟系统文件获取操作系统运行状态信息。

### mysql exporter
通过读取数据库监控表获取mysql的性能数据

### kube-state-metrics
- 安装 https://github.com/kubernetes/kube-state-metrics/tree/master/examples/standard
基于client-go开发，轮询Kubernetes API，并将Kubernetes的结构化信息转换为metrics。

1. 监听 API Server 资源对象的 add、delete、update 事件，获取资源对象的状态指标。
1. kube-state-metric 利用 client-go 初始化所有已经存在的资源对象，确保没有任何遗漏
2. kube-state-metrics 当前不会输出 metadata 信息(如 help 和 description）
3. 缓存实现是基于 golang 的 map，解决并发读问题当期是用了一个简单的互斥锁，可以解决问题，后续会考虑golang 的 sync.Map 安全 map。
4. kube-state-metrics 通过比较 resource version 来保证 event 的顺序
5. kube-state-metrics 并不保证包含所有资源

4. 超过100节点的集群资源消耗 2MiB memory per node 0.001 cores per node

2. KubeHpaMaxedOut 
kube_hpa_status_current_replicas{job="kube-state-metrics"}
  == kube_hpa_spec_max_replicas{job="kube-state-metrics"}

#### 待探索
kube-state-metric 有一个很重要的使用场景，就是和 cAdvisor 指标组合，原始的 cAdvisor 中只有 Pod 信息，不知道属于哪个 Deployment 或者 sts，但是和 kube-state-metric 中的 kube_pod_info 做 join 查询之后就可以显示出来，kube-state-metric 的元数据指标，在扩展 cAdvisor 的 label 中起到了很多作用，prometheus-operator 的很多 record rule 就使用了 kube-state-metric 做组合查询。

kube-state-metric 中也可以展示 Pod 的 label 信息，可以在拿到 cAdvisor 数据后更方便地做 group by，如按照 Pod 的运行环境分类。但是 kube-state-metric 不暴露 Pod 的 annotation，原因是下面会提到的高基数问题，即 annotation 的内容太多，不适合作为指标暴露。

### cAdvisor
- https://zhuanlan.zhihu.com/p/96597715
- linux管理进程数据的地方在/proc，其中存放了每个进程的cpu、mem、net、io、cgroup等各种信息，所有的监控数据都基于/proc获取
#### 说明
1. 目前cAdvisor集成到了kubelet组件内，可以在kubernetes集群中每个启动了kubelet的节点使用cAdvisor提供的metrics接口获取该节点所有容器相关的性能指标数据。1.7.3版本以前，cadvisor的metrics数据集成在kubelet的metrics中，在1.7.3以后版本中cadvisor的metrics被从kubelet的metrics独立出来了，在prometheus采集的时候变成两个scrape的job。

2. kubelet中的cadvisor是没有对外开放4194端口,只能通过apiserver提供的api做代理获取监控指标.

3. 从apiserver访问cadvisor的地址：
cAdvisor的metrics地址: /api/v1/nodes/[节点名称]/proxy/metrics/cadvisor
kubelet的metrics地址：/api/v1/nodes/[节点名称]/proxy/metrics

4. 直接从各个node的kubelet访问cadvisor的地址：
cAdvisor的metrics地址: node_ip:10250/metrics/cadvisor
kubelet的metrics地址：node_ip:10250/metrics

#### metrics
1. cpu
- 每个pod一分钟内每秒钟cpu的使用情况
sum(rate(container_cpu_usage_seconds_total{image!=""}[1m])) by (pod_name, namespace)
- 每个pod一分钟内每秒钟cpu的使用率（使用的/limie的）
sum(rate(container_cpu_usage_seconds_total{image!=""}[1m])) by (pod_name, namespace) / (sum(container_spec_cpu_quota{image!=""}/100000) by (pod_name, namespace)) * 100

2. POD的文件系统使用量
sum(container_fs_usage_bytes{image!="",container!="POD",container!=""}) by(pod, namespace) / 1024 / 1024 / 1024

3. memory
container_memory_rss： RSS内存，即常驻内存集（Resident Set Size），是分配给进程使用实际物理内存，而不是磁盘上缓存的虚拟内存。RSS内存包括所有分配的栈内存和堆内存，以及加载到物理内存中的共享库占用的内存空间，但不包括进入交换分区的内存。


container_memory_max_usage_bytes(最大可用内存) >
container_memory_usage_bytes(已经申请的内存+工作集使用的内存) >
container_memory_working_set_bytes(工作集内存) >
container_memory_rss(常驻内存集)

- Pod 内存使用了多少M
sum(container_memory_rss{image!=""}) by(pod_name, namespace)/1024/1024
- Pod 内存使用率
sum(container_memory_rss{image!=""}) by(pod_name, namespace) / sum(container_spec_memory_limit_bytes{image!=""}) by(pod_name, namespace) * 100 != +inf

4. traefik
- 每个pod每分钟发送的流量
  sum(rate(container_network_transmit_bytes_total{name=~".+"}[1m])) by (name)
- 每个pod每分钟接收的流量
sum(rate(container_network_receive_bytes_total{name=~".+"}[1m])) by (name)

### blackbox-exporter
1. service
```
# service http_probe
#prometheus.io/app-info-*开头的注解的label将被替换，label名只保留*部分
prometheus.io/app-info-env: namespace
prometheus.io/app-info-name: appname
prometheus.io/scrape: 'true'   #以前的配置中需要，目前不需要
prometheus.io/http-probe: 'true'
prometheus.io/http-probe-port: '8080'
prometheus.io/http-probe-path: '/healthz'


#service tcp_probe
#prometheus.io/app-info-*开头的注解的label将被替换，label名只保留*部分
prometheus.io/app-info-env: namespace
prometheus.io/app-info-name: appname
prometheus.io/scrape: "true"  #以前的配置中需要，目前不需要
prometheus.io/tcp-probe: "true"
prometheus.io/tcp-probe-port: "80"
```
2. endpoint
```
# endpoints http_probe
#prometheus.io/app-info-*开头的注解的label将被替换，label名只保留*部分
prometheus.io/app-info-env: namespace
prometheus.io/app-info-name: appname
prometheus.io/scrape: 'true'  #以前的配置中需要，目前不需要
prometheus.io/pod-http-probe: 'true'
prometheus.io/pod-http-probe-port: '8080'
prometheus.io/pod-http-probe-path: '/healthz'



# endpoints tcp_probe
#prometheus.io/app-info-*开头的注解的label将被替换，label名只保留*部分
prometheus.io/app-info-env: namespace
prometheus.io/app-info-name: appname
prometheus.io/scrape: "true"   #以前的配置中需要，目前不需要
prometheus.io/pod-tcp-probe: "true"
prometheus.io/pod-tcp-probe-port: "80"

```
3. icmp
```
# endpoints icmp probe
prometheus.io/pod-icmp-probe: "true"

# service icmp probe
#嘻嘻，service不支持icmp ping

```


### 一 process-exporter
1. 下载地址
https://github.com/ncabatoff/process-exporter/releases/download/v0.5.0/process-exporter-0.5.0.linux-amd64.tar.gz

tar xzvf process-exporter-0.5.0.linux-amd64.tar.gz &&  mv process-exporter-0.5.0.linux-amd64 process-exporter

vim /lib/systemd/system/process_exporter.service
```conf
[Unit]
Description=Prometheus exporter for processors metrics, written in Go with pluggable metric collectors.
Documentation=https://github.com/ncabatoff/process-exporter
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/process-exporter
ExecStart=/root/process-exporter/process-exporter -config.path /root/process-exporter/index.yaml
Restart=always

[Install]
WantedBy=multi-user.target
```

vim index.yaml
```conf
process_names:
    - name: "{{.Matches}}"
      cmdline:
        - 'nc -l'
```
### 二 ceph 监控
1. 开启ceph-mgr的prometheus模块
ceph mgr module enable prometheus
ceph mgr module ls
2. 
ceph节点上的exporter功能会收集信息整理为prometheus格式
 

### minoi监控
metrics_path: /minio/prometheus/metrics
k8s: minio的serice通过注解将指标暴露给 prometheus
https://docs.min.io/docs/how-to-monitor-minio-using-prometheus.html