## 背景
1. scheduler工作机制，如果不发生驱逐或者手动干预，Pod的一生只会被调度一次。
2. descheduler项目 目前不支持根据node资源的真实使用情况进行二次调度。

## 需求
1. 让K8s周期性评估node资源真实情况，将Pod调度都资源最富余的node上。

## descheduler
- https://github.com/kubernetes-sigs/descheduler
### 机制
- 主要工作原理  
使用封装好的k8s客户端client-go与k8s集群进行通信，获取集群中node和pod的情况，然后读取规则，最终决定是否驱逐node上的pod（通过标记为evicted）进其它的node上。

### 策略
1. LowNodeUtilization： 根据node上所有Pod的request请求资源量/node资源总量 来评估。
```yaml
apiVersion: "descheduler/v1alpha1"
kind: "DeschedulerPolicy"
strategies:
  "LowNodeUtilization":
     enabled: true
     params:
       nodeResourceUtilizationThresholds:
         thresholds:
           "cpu" : 20 # Request小于20%则为underutilized
           "memory": 20 # Request小于20%则为underutilized
           "pods": 20 # Request小于20%则为underutilized
         targetThresholds:
           "cpu" : 50
           "memory": 50
           "pods": 50
```

## 解决方案

1. 基于descheduler项目，通过调用其它工具（例如Prometheus）来获取node资源的实际使用情况UsedResource，然后进行 UsedResource/node资源总量 来评估，是否需要将Pod调度到另一个节点上。

### 实施过程
- 功能
    1. 获取node节点的资源实际使用情况metrics 
    2. 获取Pod的资源使用情况metrics  
        - 如何获取Pod的资源使用情况metrics ？？？？
    3. 获取百分比，然后和配置进行对比，选出资源overActualUtilization的节点。
    4. 选出overActualUtilization节点上可以evict的pod
    5. 将pod调度到underActualUtilization的节点上。 
#### 具体细节
- 使用k8s库go-client和apiserver进行交互
    1. 节点的时时使用的内存和CPU
    curl 127.0.0.1:8001/apis/metrics.k8s.io/v1beta1/nodes/ip-172-31-46-147.ec2.internal
    2. 获取所有节点的内存和CPU
    curl 127.0.0.1:8001//api/v1/nodes
