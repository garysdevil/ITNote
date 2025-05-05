---
created_date: 2020-11-16
---

[TOC]

## 配置

- 参考文档
- 配置
  https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/
  https://yunlzheng.gitbook.io/prometheus-book/parti-prometheus-ji-chu/alert/prometheus-alert-rule

1. 全局配置

```conf
rule_files:
  - <filepath_glob>  # 告警规则文件的位置
global:
  evaluation_interval: 1m # 默认情况下Prometheus会每分钟对这些告警规则进行计算，如果想定义自己的告警计算周期，则可以通过evaluation_interval来覆盖默认的计算周期
```

2. 示范

```yaml
groups:
- name: example1
  rules:
    - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      receiver: garys
      severity: scritical # 自定义标签，允许用户指定要附加到告警上的一组附加标签。
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }}" # 描述告警的概要信息
- name: example2
  rules:
  - alert: HighRequestLatency
    expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
    for: 10m # 10分钟以上，条件都满足expr，则出发告警
    labels:
      receiver: garys
      severity: info
    annotations:
      summary: High request latency
```

{{ $labels.job }} :获取实例中指定标签的值
{{ $value }} :获取当前PromQL表达式计算的样本值。

3. 告警值的存储
   同时对于已经pending或者firing的告警，Prometheus也会将它们存储到时间序列ALERTS{}中。
   样本值为1表示当前告警处于活动状态（pending或者firing），当告警从活动状态转换为非活动状态时，样本值则为0。

```查询
ALERTS{alertname="<alert name>", alertstate="pending|firing", <additional alert labels>}
```

## 告警等级

emergency
critical
warning

## blackbox_rules

```conf
groups:
- name: '探活失败'
  rules:
  - alert: '探活失败'
    expr: probe_success == 0
    labels:
      receiver: garys
      severity: average
    annotations:
      description: '探活类型{{$labels.job}}, {{$labels.kubernetes_namespace}}/{{$labels.service_name}} {{$labels.instance}}探活失败 '
- name: 'http探活耗时3分钟内平均时间超过2s'
  rules:
  - alert: 'http探活耗时3分钟内平均时间超过2s'
    expr: sum(avg_over_time(probe_http_duration_seconds[3m])) without (phase) > 2
    labels:
      receiver: garys
      severity: average
    annotations:
      description: '探活类型{{$labels.job}}, {{$labels.kubernetes_namespace}}/{{$labels.service_name}} {{$labels.instance}}探活失败 '

```

## kube-state-metrics

- 参考文档
  https://kubernetes.io/docs/concepts/architecture/nodes/
  https://github.com/kubernetes/kube-state-metrics/tree/v2.0.0-alpha.2/docs

```conf
groups:
- name: NodesStatusException
  rules:
  - alert: 'Node节点状态异常持续2分钟' # kubectl get node
    expr: kube_node_spec_unschedulable==1 or kube_node_status_condition{condition="Ready",status!="true"}==1
    for: 2m
    labels:
      receiver: garys # 发送媒介标志
    annotations:
      enviroment: "集群: {{$labels.cluster}}; 节点: {{$labels.node}};"
      reason: "异常原因: {{$labels.condition}}={{$labels.status}} and kube_node_spec_unschedulable={{$value}}"
- name: NodeResourcePresure
  rules:
  - alert: 'Node节点资源异常持续2分钟--可能触发驱逐Pod操作' # kubectl get node , 登录node核实资源缺失情况
    expr: kube_node_status_condition{condition=~"DiskPressure|MemoryPressure|PIDPressureNetworkUnavailable", status="true"}==1
    for: 2m
    labels:
      receiver: garys # 发送媒介标志
      severity: critical
    annotations:
      enviroment: "集群: {{$labels.cluster}}; 节点: {{$labels.node}};"
      reason: "异常原因: {{$labels.condition}}" # DiskPressure|MemoryPressure|PIDPressureNetworkUnavailable

- name: PodIsException
  rules:
  - alert: 'Pod异常--Evicted/NodeLost/UnexpectedAdmissionError' # 
    expr: kube_pod_status_reason==1
    labels:
      receiver: garys # 发送媒介标志
      severity: warning
    annotations:
      enviroment: "集群: {{$labels.cluster}}; Namespace: {{$labels.namespace}}"
      reason: "{{$labels.reason}}" # Evicted/NodeLost/UnexpectedAdmissionError
- name: PodRestartfrequently 
  rules:
  - alert: 'Pod 30分钟内重启次数大于等于2次' # 查看pod日志核实原因
    expr: changes(kube_pod_container_status_restarts_total[30m])>2
    labels:
      receiver: garys # 发送媒介标志
      severity: warning
    annotations:
      enviroment: "集群: {{$labels.cluster}}; Namespace: {{$labels.namespace}}; Pod: {{$labels.pod}}"


- name: PodStartFail # 研发关注，迭代失败会触发。
  rules:
  - alert: 'Pod启动失败'
    expr: kube_pod_status_phase{phase="Failed"}==1
    labels:
      receiver: garys
      severity: warning
    annotations:
      enviroment: "集群: {{$labels.cluster}}; Namespace: {{$labels.namespace}}"

- name: JobFail # Job失败 # 发现job失败是否需要去处理？如果不去处理就没必要添加告警。
  rules:
  - alert: 'Job运行失败'
    expr: kube_job_status_failed>1
    for: 5m
    labels:
      receiver: garys
      severity: warning
    annotations:
      enviroment: "集群: {{$labels.cluster}}; Namespace: {{$labels.namespace}}"


kube_pod_container_status_terminated_reason reason=<OOMKilled|Error|Completed|ContainerCannotRun|DeadlineExceeded|Evicted>
```
