---
created_date: 2020-11-16
---

[TOC]

- 需要安装的组件
    1. Prometheus server 
    2. PushGateway
    3. Alertmanager
    4. Prometheus-webhook-dingtalk
- 全是基于go语言编写完成的组件，下载解压缩tar包即可启动使用
## 安装
### 一 Prometheus Server
1. 下载安装
    https://github.com/prometheus/prometheus/releases/download/v2.14.0/prometheus-2.14.0.linux-amd64.tar.gz 老版本
    https://github.com/prometheus/prometheus/releases/download/v2.17.2/prometheus-2.17.2.linux-amd64.tar.gz 新版本

2. 启动
    ./prometheus --config.file=./prometheus.yml --web.enable-lifecycle --web.external-url=http://0.0.0.0:9090
    --web.enable-lifecycle 开启配置文件热加载，默认是关闭的
    --config.file=./prometheus.yml 指定配置文件
    --storage.tsdb.path 指定时序数据库的存储路径
    --web.external-url 指定暴露的IP端口号
​    --storage.tsdb.retention.time 指定存储天数（默认15天）
    --web.enable-admin-api 开启对TSDB执行删除操作的权限
    --rules.alert.resend-delay=300s 指定告警重复发送的时间
3. web端
http://localhost:9090/

### 二 PushGateway
- 自定义脚本采集到的数据推送到PushGateway，Prometheus服务端再去拉取PushGateway上的数据。
1. 下载安装
 https://github.com/prometheus/pushgateway/releases/download/v1.0.1/pushgateway-1.0.1.linux-amd64.tar.gz
 https://github.com/prometheus/pushgateway/releases/download/v1.2.0/pushgateway-1.2.0.linux-amd64.tar.gz

2. 启动
nohup ./pushgateway --web.external-url="http://0.0.0.0:9091" --web.enable-lifecycle 2>&1 &
--web.enable-lifecycle
--persistence.file 开启本地持久化
--persistence.interval=5m  表示开启本地持久化后数据保留时间
--web.external-url="http://0.0.0.0:9091"
--web.listen-address=":9091"
3. web端
http://localhost:9091/

### 三 Alertmanager
1. 下载安装alertmanager
    https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz
    
2. 启动
    ./alertmanager --config.file="alertmanager.yml" --web.external-url=http://0.0.0.0:9093

3. web端
http://localhost:9093

### 四 Prometheus-webhook-dingtalk
1. 下载安装prometheus-webhook-dingtalk
https://github.com/timonwong/prometheus-webhook-dingtalk/releases/download/v1.4.0/prometheus-webhook-dingtalk-1.4.0.linux-amd64.tar.gz

2. 启动 prometheus-webhook-dingtalk
${webhook} 为自定义的名称
./prometheus-webhook-dingtalk --web.enable-ui --web.enable-lifecycle --config.file=config.yml
或
./prometheus-webhook-dingtalk --ding.profile=${webhook}=钉钉机器人地址 --template.file=/opt/prometheus-webhook-dingtalk/default.tmpl
- 参数讲解
--web.enable-lifecycle 
--web.enable-ui 启动web界面 /ui
--ding.profile=${webhook}=钉钉机器人地址
--template.file 指定模板
--config.file="config.yml" 指定配置文件

3. 测试prometheus-webhook-dingtalk是否生效
curl http://localhost:8060/dingtalk/${webhook}/send -H 'Content-Type: application/json' -d '{"msgtype": "text","text": {"content": "测试钉钉机器人连通性"}}'

4. web端
需要在启动参数里指定开启web端
127.0.0.1:8060/ui

### 五 服务化所有组件
1. prometheus
```conf
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure
ExecStart=/opt/prometheus/prometheus --web.enable-lifecycle --config.file=/opt/prometheus/prometheus.yml --storage.tsdb.path=/opt/prometheus/data --web.external-url=http://0.0.0.0:9090
ExecReload=/usr/bin/curl -XPOST http://127.0.0.1:9090/-/reload

[Install]
WantedBy=multi-user.target
```
2. alertmanager
```conf
[Unit]
Description=Alertmanager
After=network-online.target

[Service]
User=root
Restart=Always
ExecStart=/opt/alertmanager/alertmanager --config.file=/opt/alertmanager/alertmanager.yml --web.external-url=http://0.0.0.0:9093

[Install]
WantedBy=multi-user.target
```
3. prometheus-webhook-dingtalk
- 服务化失败
```conf
[Unit]
Description=prometheus-webhook-dingtalk
After=network-online.target

[Service]
User=root
# Restart=on-failure
ExecStart=/opt/prometheus-webhook-dingtalk/prometheus-webhook-dingtalk --web.enable-ui --web.enable-lifecycle --config.file=/opt/prometheus-webhook-dingtalk/config.yml

[Install]
WantedBy=multi-user.target
```

4. pushgateway
```conf
[Unit]
Description=Pushgateway
After=network-online.target

[Service]
User=root
Restart=on-failure
ExecStart=/opt/pushgateway/pushgateway --web.external-url=http://0.0.0.0:9091 --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
```
## 在k8s里部署Prometheus
1. 部署 
monitoring-prometheus-rbac.yml
monitoring-prometheus-config.yml
monitoring-prometheus-deployment.yml

2. 自动发现权限问题
k8s 官方文档 http://docs.kubernetes.org.cn/148.html
解决 https://stackoverflow.com/questions/53908848/kubernetes-pods-nodes-is-forbidden
Service account是为了方便Pod里面的进程调用Kubernetes API或其他外部服务而设计的。
kubectl create serviceaccount admin -n monitoring
kubectl describe sa admin -n monitoring
kubectl get secrets -n monitoring

kubectl get secrets default-token-5shrd  -n monitoring -o jsonpath={.data.token} |base64 -d
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=minitoring:default

## 运维须知
### 一 各个组件的默认端口以及web界面
1. Prometheus Server 默认监听端口 9090
- /
2. Alertmanager默认监听9093端口，集群监听端口9094
- /
3. PushGateway默认监听端口 9091
- /
4. prometheus-webhook-dingtalk  默认监听端口 8060
- web界面默认是关闭状态  /ui