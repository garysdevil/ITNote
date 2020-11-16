1. 通过开源项目部署prometheus
https://github.com/prometheus-operator/prometheus-operator


- promethus-operator可以通过serviceMonitor 自动识别带有某些 label 的service ，并从这些service 获取数据。
- serviceMonitor 也是由promethus-operator 自动发现的。