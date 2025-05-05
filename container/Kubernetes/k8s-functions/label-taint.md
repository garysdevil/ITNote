---
created_date: 2020-11-16
---

[TOC]

- 官网
 https://kubernetes.io/zh/docs/concepts/configuration/taint-and-toleration/
 https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/

### 标签 
1. nodeSelector
- 添加标签
kubectl label nodes ${ip} ${key}=${value}
- 删除node的标签
kubectl label nodes ${ip} ${key}- 
- 更新标签
kubectl label nodes ${ip} ${key}=${value} --overwrite

- 查看标签
kubectl get nodes --show-labels
2. 如果pod想要选择在含有这个标签的node节点上运行，则需要在此pod的yaml添加如下配置

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    env: test
spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    project: "project"
    kubernetes.io/hostname: ${IP}
```

```yaml deployment
      nodeSelector:
        project: "project"
```
3. nodeName
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: kube-01
```

### 污点
1. 污点
- effect策略：
  NoSchedule:K8Snode添加这个effecf类型污点，新的不能容忍的pod不能再调度过来，但是老的运行在node上不受影响
  NoExecute：K8Snode添加这个effecf类型污点，新的不能容忍的pod不能调度过来，老的pod也会被驱逐
  PreferNoSchedule：pod会尝试将pod分配到该节点
- 添加污点
kubectl taint nodes $ip $key=$value:$effect
- 删除污点
kubectl taint nodes $ip $key:$effect-
- 获取节点的污点信息
kubectl describe node ${ip} | grep Taints

2. 如果pod想要忽视node节点上的这个污点，则需要在此pod的yaml添加如下配置
```yaml
  tolerations:
  - key: "dam-taint" 
    operator: "Equal"
    value: "project"
    effect: "NoExecute"  #effect策略
    tolerationSeconds: 3600  #示如果这个 pod 正在运行，然后所在的节点被添加上一个taint，那么 pod 还将继续在节点上运行 3600 秒。只有effect: "NoExecute"才能设置，否则报错。
# operator为Equal时 表示 key=value:effect 和 node节点上的taint完全一样则可以容忍这个污点。 
# operator为Exists时 不能指定value的值否则会报错。如果key为空则这个 toleration 能容忍任意 taint；如果effect 为空，则 key 值与之相同的相匹配 taint 的 effect 可以是任意值。
```
3. 具体例子
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    project: project
    envoriment: dev
    app: mytest
  name: mytest
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mytest
  template:
    metadata:
      labels:
        app: mytest
    spec:
      containers:
      - image: busybox
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "while true;do sleep 30;done" ]
        imagePullPolicy: Always
        name: mytest
        ports:
        - containerPort: 8076
          name: http
          protocol: TCP
      restartPolicy: Always
      tolerations:
      - key: "dam-taint"
        operator: "Equal"
        value: "project"
        effect: "NoSchedule"
      nodeSelector:
        project: "project"
```