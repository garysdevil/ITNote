## Pod Priority Preemption
1. Kubernetes 1.8版本之前，当集群的可用资源不足时，在用户提交新的Pod创建请求后，该Pod会一直处于Pending状态，即使这个Pod是一个很重要的Pod，也只能被动等待其他Pod被删除并释放资源，才能有机会被调度成功。
2. Kubernetes 1.8版本引入了基于Pod优先级抢占（Pod Priority Preemption）的调度策略，此时Kubernetes会尝试释放目标节点上低优先级的Pod，以腾出资源安置高优先级的Pod，这种调度方式被称为“抢占式调度”。
3. 在Kubernetes 1.11版本中，该特性升级为Beta版本，默认开启。
4. 在Kubernetes 1.14版本中正式Release。

- 可以通过以下几个维度来定义Pod Priority Preemption：
    - Priority，优先级；
    - QoS，服务质量等级；
    - 系统定义的其他度量指标。

- 机制
当一个Node发生资源不足（under resource pressure）的情况时，该节点上的kubelet进程会执行驱逐动作，此时Kubelet会综合考虑Pod的优先级、资源申请量与实际使用量等信息来计算哪些Pod需要被驱逐；  
当同样优先级的Pod需要被驱逐时，实际使用的资源量超过申请量最大倍数的高耗能Pod会被首先驱逐。对于QoS等级为“Best Effort”的Pod来说，由于没有定义资源申请（CPU/Memory Request），所以它们实际使用的资源可能非常大。  


### yaml
1. 设置优先级类(PriorityClass不属于任何命名空间)
```yaml
apiVersion: scheduling.k8s.io/v1beta1
kind: PriorityClass
metadata:
  name: high-priority
value: 100000 # 数字越大，优先级越高，超过一亿的数字被系统保留，用于指派给系统组件。
globalDefault: false
description: "This priority class should be used for xyz service pods only"
```
  - globalDefault 
    1. 表示 PriorityClass 的值应该给那些没有设置 PriorityClassName 的 Pod 使用。
    2. 整个系统只能存在一个 globalDefault 设置为 true 的 PriorityClass。
    3. 如果没有任何 globalDefault 为 true 的 PriorityClass 存在，那么，那些没有设置 PriorityClassName 的 Pod 的优先级将为 0。
2. Pod使用优先级类
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
  priorityClassName: high-priority
```