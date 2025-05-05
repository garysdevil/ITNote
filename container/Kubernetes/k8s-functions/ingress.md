---
created_date: 2021-03-12
---

[TOC]

1. ingress

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: 名字
  namespace: default
  # annotations:
  #   networking.gke.io/managed-certificates: 谷歌证书名称 # 谷歌gke的service，配置https只能通过ingress暴露出去 # aws可以直接在service里配置
  #   kubernetes.io/ingress.global-static-ip-name: 谷歌静态IP名称 # 谷歌云服务里配置的静态IP的名称 # 不使用这行注解则分配为动态IP
spec:
  rules:
  - host: 域名
    http:
      paths:
      - path: /*
        backend:
          serviceName: service的名字
          servicePort: 80

```

2. 谷歌云服务配置证书

```yaml
apiVersion: networking.gke.io/v1beta1
kind: ManagedCertificate
metadata:
  name: 谷歌证书名称
  namespace: default
spec:
  domains:
    - 域名
```
