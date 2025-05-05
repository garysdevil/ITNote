---
created_date: 2020-11-16
---

[TOC]

### 告警
1. 合格的告警通知
    1. 报警级别
    2. 简短的报警名称
    3. 简要说明
    4. 解决办法
    5. 一个链接，点击后进入指标的 Graph


#### dingding告警
- 模板
https://github.com/timonwong/prometheus-webhook-dingtalk/issues/17
https://golang.org/pkg/text/template/

- 模板语法 https://www.cnblogs.com/Pynix/p/4154630.html
```go 参考1
{{ define "__subject" }}[{{ if eq .Status "firing" }}告警:{{ .Alerts.Firing | len }}{{ else }}恢复{{ end }}]{{ end }}

{{ define "__text_alert_list" }}
{{ if eq .Status "firing" }}
{{ range .Alerts.Firing }}
{{ range .Annotations.SortedPairs }}> - {{ .Value | markdown | html }}
{{ end }}{{ end }}

{{ else if eq .Status "resolved" }}
{{ range .Alerts.Resolved }}
{{ range .Annotations.SortedPairs }}> - {{ .Value | markdown | html }}
{{ end }}{{ end }}
{{ end }}
{{ end }}

{{ define "__alertmanagerURL" }}{{ end }}
{{ define "ding.link.title" }}{{ template "__subject" . }}{{ end }}
{{ define "ding.link.content" }}#### [{{ if eq .Status "firing" }}告警:{{ .Alerts.Firing | len }}{{ else }}恢复{{ end }}]
{{ template "__text_alert_list" . }}
{{ end }}
```

```go 参考2
{{ define "__subject" }}【AlertManager】{{ end }}
{{ define "__text_list" }}{{ range . }}
{{ range .Labels.SortedPairs }}
{{ if eq .Name "cluster" }}> [集群]: {{ .Value | markdown | html }}{{ end }}
{{ if eq .Name "hostname" }}> [主机]: {{ .Value | markdown | html }}{{ end }}
{{ end }}
{{ range .Annotations.SortedPairs }}
{{ if eq .Name "description" }}> [描述]: {{ .Value | markdown | html }}{{ end }}
{{ end }}
[查看详情]({{ .GeneratorURL }})

{{ end }}{{ end }}

{{ define "ding.link.content" }}
{{ if gt (len .Alerts.Firing) 0 }}#### [{{ .Alerts.Firing | len }}]【Firing】
{{ template "__text_list" .Alerts.Firing }}{{ end }}
{{ if gt (len .Alerts.Resolved) 0 }}#### [{{ .Alerts.Resolved | len }}]【Resolved】
{{ template "__text_list" .Alerts.Resolved }}{{ end }}
{{ end }}
```


```go 我写的
{{ define "__text_alert_list" }}{{ range . }}
**Time:** {{ .StartsAt | date "2006.01.02 15:04:05" }}

**Labels**
{{ range .Labels.SortedPairs }}
{{ if eq .Name "kubernetes_namespace" }}> - kubernetes_namespace: {{ .Value | markdown | html }}{{ end }}
{{ if eq .Name "namespace" }}> - namespace: {{ .Value | markdown | html }}{{ end }}
{{ if eq .Name "service_name" }}> - service: {{ .Value | markdown | html }}{{ end }}
{{ if eq .Name "pod_name" }}> - pod: {{ .Value | markdown | html }}{{ end }}
{{ if eq .Name "severity" }}> - 告警等级: {{ .Value | markdown | html }}{{ end }}
{{ end }}
**Annotations**
{{ range .Annotations.SortedPairs }}> - {{ .Name }}: {{ .Value | markdown | html }}
{{ end }}

{{ end }}{{ end }}
```