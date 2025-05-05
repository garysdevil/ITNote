---
created_date: 2020-12-23
---

[TOC]

## 运行时调度策略

nodeAffinity（节点亲和性）
podAffinity（Pod亲和性）
podAntiAffinity（Pod反亲和性）

### nodeAffinity

1. 强制性
   - 节点亲和性配置 requiredDuringSchedulingIgnoredDuringExecution，disktype=ssd
   - pod 只会被调度到具有 disktype=ssd 标签的节点上
2. 非强制性
   - 节点亲和性配置 preferredDuringSchedulingIgnoredDuringExecution，disktype=ssd
   - 意味着 pod 将首选具有 disktype=ssd 标签的节点。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd            
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
```
