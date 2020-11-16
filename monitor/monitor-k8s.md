1. K8s仪表盘：插件工具，展示每个K8s集群上的资源利用情况，也是实现资源和环境管理与交互的主要工具。
2. 容器探针：容器健康状态诊断工具。 -- blackbox
3. Kubelet：每个Node上都运行着Kubelet，监控容器的运行情况。Kubelet也是Master与各个Node通信的渠道。Kubelet能够直接暴露cAdvisor中与容器使用相关的个性化指标数据。
4. cAdvisor：开源的单节点agent，负责监控容器资源使用情况与性能，采集机器上所有容器的内存、网络使用情况、文件系统和CPU等数据。
    cAdvisor简单易用，但也存在不足：一是仅能监控基础资源利用情况，无法分析应用的实际性能；二是不具备长期存储和趋势分析能力。
5. Kube-state-metrics：轮询Kubernetes API，并将Kubernetes的结构化信息转换为metrics。
6. Metrics server：Metrics server定时从Kubelet的Summary API采集指标数据，并以metric-api的形式暴露出去。



https://blog.csdn.net/u013256816/article/details/107724335

cAdvisor：集成在 Kubelet 中。

kubelet：10255 为非认证端口，10250 为认证端口。

apiserver：6443 端口，关心请求数、延迟等。

scheduler：10251 端口。

controller-manager：10252 端口。

etcd：如 etcd 写入读取延迟、存储容量等。

Docker：需要开启 experimental 实验特性，配置 metrics-addr，如容器创建耗时等指标。

kube-proxy：默认 127 暴露，10249 端口。外部采集时可以修改为 0.0.0.0 监听，会暴露：写入 iptables 规则的耗时等指标。

kube-state-metrics：Kubernetes 官方项目，采集 Pod、Deployment 等资源的元信息。

node-exporter：Prometheus 官方项目，采集机器指标如 CPU、内存、磁盘。

blackbox_exporter：Prometheus 官方项目，网络探测，DNS、ping、http 监控。

process-exporter：采集进程指标。

NVIDIA Exporter：我们有 GPU 任务，需要 GPU 数据监控。

node-problem-detector：即 NPD，准确的说不是 Exporter，但也会监测机器状态，上报节点异常打 taint。

应用层 Exporter：MySQL、Nginx、MQ 等，看业务需求。