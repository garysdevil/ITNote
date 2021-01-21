### prometheus配置
- https://prometheus.io/docs/prometheus/latest/configuration/configuration/
```yaml prometheus.yaml
global:
  scrape_interval:     15s # default = 1m. 抓取时间间隔
  evaluation_interval: 15s # default = 1m. 审查告警规则间隔 Prometheus uses rules to create new time series and to generate alerts.
  scrape_timeout: 10s # default = 10s

  external_labels: # # 当和其他外部系统交互时添加的标签，如远程存储、联邦集群时
    monitor: 'codelab-monitor'

rule_files:
  # - "first.rules"
  # - "second.rules"

# Alertmanager 相关配置
alerting:
  alert_relabel_configs: # 告警被发出去前进行标签更改
    [ - <relabel_config> ... ]
  alertmanagers:
  - static_configs:
    - targets:
      - ${IP}:9093

# 远程存储读写
remote_write:
  [ - <remote_write> ... ]
remote_read:
  [ - <remote_read> ... ]

# 配置exporter
scrape_configs:
  honor_labels: true # Default false. 设置当exporter标签和Prometheus server标签冲突时的解决办法。 If true: 保留exporter所设置的标签
  honor_timestamps: true # default = true  # 设置使用的是exporter的时间戳还是Prometheus server的时间戳。If true: 使用 exporter 的时间戳。
  scheme: http # default = http 配置抓取metric的协议
  - job_name: 'prometheus'   # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
    static_configs:
    - targets: ['localhost:9090'] # 默认采集路径是/metrics上开放的端口服务

    # 抓取数据之前进行标签替换，也就是说这些标签的值在scrape之前是已知的
    relabel_configs:
      # 生成新的标签名和标签的值
      - source_labels: [__address__] # 已存在的标签
        separator: '-' # default ; # 标签值之间的分隔符
        target_label: job # 生成新的标签名
        regex: l(.+) # default .*
        replacement: __${1}__${2}  # default $1 # 新的标签值
        
      # 替换标签的值
      - target_label: __address__ # 获取标签的值
        replacement: ${IP}:9090

      # 生成新的标签 -- Target实例的标签名称符合regex，则将捕获到的内容作为为新的标签名称，标签的的值作为新标签的值。
      - action: labelmap
        regex: j(.+)

      # 保留或者删除标签 -- labelkeep:保留标签名称符合regex的; labeldrop:相反。
      - regex: j(.+)
        action: labeldrop

      # 保留或者删除metric -- keep:标签的值符合regex 则保留这个metric; drop:相反。
      - source_labels:  ["__address__"]
        regex: ".*90.*"
        action: keep
      
      # 直接添加一个标签和标签值
      - mylable: myvalue # 
    
    # 抓取数据之后进行标签替换
    metric_relabel_configs:

  - job_name: 'federate'
    scrape_interval: 15s
    honor_labels: true
    metrics_path: '/federate'
    #url的参数，表示了需要拉取哪些job的数据
    params:
      'match[]':
        - '{job=~"kubernetes-.*"}'
        - '{job=~"prometheus-.*"}'
        - '{__name__=~"job:.*"}'
    static_configs:
      - targets:
        #添加对应的k8s内prometheus的地址
        - '${IP}:39090'
    #添加一个k8s_cluster的label，用于收集多个k8s集群时区分哪个集群的告警，不然可以不用
    relabel_configs:
    - source_labels: [__address__]
      regex: (.*)
      target_label: k8s_cluster
      replacement: $1
```
*.rules
```yaml
groups:
- name: new expression  # 构建一条表达式  
  rules:
  - record: job_service:rpc_durations_seconds_count:avg_rate5m
    expr: avg(rate(rpc_durations_seconds_count[5m])) by (job, service)

- name: alert rule # 构建一条告警规则
  rules:
  - alert: 实例存活告警
    expr: up == 0
    for: 10s
    labels:
      severity: high
    annotations:
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 10 seconds."
```

### Alertmanager配置
- https://prometheus.io/docs/alerting/configuration/
```yaml alertmanager.yaml
# vi alertmanager.yml
global:
  resolve_timeout: 5m # dedault 5m # 在此时间之后，如果未再次发生此分组的告警，则将其声明为已解决。
route:
  group_by: ['alertname','k8s_cluster','service'] # 通过标签配置分组，同一个分组告警合并为一条消息发送出去
  group_wait: 10s # default = 30s 指定同一组的告警信息等待多长时间后再发送
  group_interval: 60s # default = 5m 指定同一组的告警信息间隔多久发送
  repeat_interval: 24h # default = 4h 如果警报已经成功发送，间隔多长时间再重复发送
  receiver: 'web.hook' # 必须有一个默认的receiver。当告警子节点都不匹配时，选择此接收器
  continue: true # default = false。 设置告警匹配到子节点后是否继续往后面的子节点匹配。
  
  # 配置子节点
  routes:
  - match:
      severity: critical
    receiver: A-project
  - match_re:
      service: files
    receiver: B-project|C-project
  routes:
  - match:
      severity: critical
    receiver: D-project
    group_by: [product, environment] # 此分组规则替换节点的分组规则
receivers:
- name: 'web.hook'
  webhook_configs:
  # web hook 调用url地址，即通过这个webhook发送钉钉消息
  - url: 'http://localhost:8060/dingtalk/Prometheus-webhook-dingtalk里面自定义的配置/send'
    send_resolved: true #  default = true # 指定是否在告警消除时发送回执消息
  - name: mail-receiver # 邮件服务需要再global或者路由里定义SMTP配置
    email_configs:
      - to: <mail to address>
inhibit_rules:
  - source_match:
      alertname: NodeDown
    target_match:
      severity: critical
    equal: ['node'] # 标签名所对应的标签值相同则抑制
```