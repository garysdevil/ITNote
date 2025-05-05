---
created_date: 2020-11-16
---

[TOC]

# kuernetes集群内部监控部署

## prometheus server部署

#### 执行yaml部署

```shell
创建monitoring的namesapce
# kubectl create namespace monitoring

直接部署prometheus server，nodeport暴露出来

修改configmap中prometheus.yml的配置文件中的某些配置，如其中etcd服务器的IP
# vi prometheus-server/kubernetes-yaml/monitoring-prometheus-config.yml
......
    - job_name: 'kubernetes-etcd'
      scheme: https
      tls_config:
        insecure_skip_verify: true
      static_configs:
      - targets:
        - '1.1.1.1:2379'
        - '1.1.1.2:2379'
        - '1.1.1.3:2379'

# kubectl apply -f prometheus-server/kubernetes-yaml/monitoring-prometheus-rbac.yml
# kubectl apply -f prometheus-server/kubernetes-yaml/monitoring-prometheus-config.yml
# kubectl apply -f prometheus-server/kubernetes-yaml/monitoring-prometheus-deployment.yml
```

#### helm chart部署

或者通过helm chart部署，chart目录为prometheus-server/helm-chart

需提前部署好helm,helm的安装请参考 [helm安装](https://github.com/easzlab/kubeasz/blob/master/docs/guide/helm.md)

部署升级可参考 [prometheus部署](https://github.com/easzlab/kubeasz/blob/master/docs/guide/prometheus.md)

```shell
修改values.yaml中的配置，如其中etcd服务器的地址
# vi prometheus-server/helm-chart/prometheus/values.yaml

部署prometheus
# helm install --tls --name monitor  -f prom-settings.yaml -f prom-alertsmanager.yaml -f prom-alertrules.yaml prometheus

修改chart后升级prometheus
# helm upgrade --tls  monitor  -f prom-settings.yaml -f prom-alertsmanager.yaml -f prom-alertrules.yaml prometheus

```

## prometheus标签规范

以前的标签都不规范，namespace在不同项目中的标签都不一致

- k8s外prometheus监控k8s内prometheus需打k8s_cluster标签，值是prometheus的__address__

- 对kubernetes自动发现的service,pod,endpoint监控打上namespace的标签，标签名为kubernetes_namespace

- 对kubernetes自动发现的service,pod,endpoint监控打上service的标签，标签名为service_name

- 对kubernetes自动发现的pod,endpoint监控打上pod的标签，标签名为pod_name


## node-exporter部署

node-exporter用于监控k8s节点的宿主机状态,prometheus server将会通过服务发现自动发现并采集node-exporter的数据

```shell
# kubectl apply -f exporters/node-exporter/kubernetes-yaml/node-exporter.yml
daemonset.extensions/node-exporter created
```

或者可通过helm chart部署prometheus会自动部署node-exporter

## blackbox-exporter部署

blackbox-exporter是用于探测service或ednpoints的http或tcp进行探活的exporter

service中需添加注解，需添加的注解请见[service-annotations.example](exporters/blackbox-exporter/kubernetes-yaml/service-annotations.example)


```shell
# kubectl apply -f exporters/blackbox-exporter/kubernetes-yaml/blackbox-configmap.yml 
.....

# kubectl apply -f exporters/blackbox-exporter/kubernetes-yaml/blackbox-exporter.yml 
deployment.extensions/prometheus-blackbox-exporter created
service/prometheus-blackbox-exporter created
```

## 如何采集pod提供的metrics？

需为pod或service添加注解,以node-exporter为例，需添加如下注解

### service中添加注解

prometheus.io/scrape，设置为true，说明需要采集metrics，必须设置

prometheus.io/app-metrics-path，metrics的uri，默认/metrics

prometheus.io/port,metric的port，默认9100

prometheus.io/schema,提供metrics的http服务的schema，默认http

### pod中添加注解

prometheus.io/scrape，设置为true，说明需要采集metrics，必须设置

prometheus.io/path，metrics的uri，默认/metrics

prometheus.io/port,metric的port，默认9100

```shell
# kubectl -n monitoring get pods node-exporter-bgtq9 -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    prometheus.io/path: "/metrics"
    prometheus.io/port: "9100"
    prometheus.io/scrape: "true"

```

# 独立部署prometheus

请参考 (部署文档)[prometheus-server/out-of-kubernetes/install.md]

# rules-告警规则

## k8s集群需部署以下rules

- [etcd](./examples/etcd/rules/etcd_rules.yml)
- [kubernetes](./examples/kubernetes/rules/host_rules.yml)
- [coredns](./examples/coredns/rules/coredns_rules.yml)
- [ceph rbd](./examples/ceph/rules/ceph_rules.yml)
- [PV容量](./examples/PV&PVC/rules/pvc_rules.yml)

## minio监控及告警

- [minio 监控](./examples/minio/README.md)
- [minio rules](./examples/minio/README.md)

## kafka的监控及告警

- [kafka_exporter 监控](./exporters/kafka-exporter/README.md)
- [kafka_exporter rules](./exporters/kafka-exporter/rules/kafka_rules.yml)
- [kafka_jmx_exporter 监控](./exporters/jmx_exporter/README.md)
- [kafka_jmx_exporter rules](./exporters/jmx_exporter/rules/kafka_jmx_rules.yml)
- [jmx_exporter java相关rules](./exporters/jmx_exporter/rules/java_jmx_rules.yml)

## redis监控及告警

- [redis 监控](./exporters/redis-exporter/README.md)
- [redis rules](./exporters/redis-exporter/rules/redis_rules.yml)

## zookeeper监控及告警

- [zookeeper 监控](./exporters/zookeeper_exporter/README.md)
- [zookeeper rules](./exporters/zookeeper_exporter/rules/zookeeper_rules.yml)

## blackbox-exporter rules - http,tcp,icmp探活的rules

- [http,tcp,icmp探活 rules](./exporters/blackbox-exporter/rules/blackbox_rules.yml)

## springboot集成了actuator的监控

- [actuator_rules](./examples/actuator/rules/actuator_rules.yml)

## mysql监控及告警

- [mysql_监控](./exporters/mysqld-exporter/README.md)


# 告警分级

对告警危害进行分级可以更规范化，更有效，更及时的处理告警，根据不同等级进行不同响应度的处理

我们使用severity的标签定义告警的级别，需为每个告警定义改标签，共分以下5个级别

- information ，告警仅为了提示或通知某些信息，不涉及性能及可用性
- warning , 对集群稳定或业务可用性影响较低的告警，如应用或组件的部分低危害的性能或容量告警
- average , 对非关键集群及应用稳定或业务访问性能造成影响的告警，如集群整体或宿主机负载过高，内存使用率过高,应用部分副本延迟较高
- high ，对关键集群及应用稳定或业务可用性造成较大影响的告警，如集群节点丢失，应用探活失败就，网络使用率高
- disaster ，对关键集群及应用或业务完全不可用的告警，如kafka集群完全不可用，关键应用无法访问

# 告警的静默

添加静默规则目前只能登陆alertmanager网页进行操作，点击`Silence``New Silence`按钮进行静默规则的编辑及添加

silence将通过label的匹配去匹配对应的告警，altermanager将不会发送这些被静默的告警消息




