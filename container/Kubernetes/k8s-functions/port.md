---
created_date: 2020-11-16
---

[TOC]

1. service
    - port  集群内部访问service的入口
    - nodePort 映射至主机的端口，集群外部访问service的入口
    - targetPort  pod上的入口，targetPort 要等于container上服务的端口，targetPort端口号默认会继承port端口号，port 和 nodePort 的数据都会流入到targetPort上

    - 从port和nodePort上到来的数据最终经过kube-proxy流入到后端pod的targetPort上进入容器。

2. 
```yaml
apiVersion: v1
kind: Service
metadata:
  name: garyswebcms-svc
  namespace: project-qa
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    # nodePort: 28006
  selector:
    app: garyswebcms
  type: ClusterIP
  # type: NodePort

```