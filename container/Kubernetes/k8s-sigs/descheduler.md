## 背景
1. scheduler工作机制，如果不发生驱逐或者手动干预，Pod的一生只会被调度一次。
2. descheduler项目 目前不支持根据node资源的真实使用情况进行二次调度。

## 需求
1. 让K8s周期性评估node资源真实情况，将Pod调度都资源最富余的node上。

## descheduler
- https://github.com/kubernetes-sigs/descheduler
### 策略
LowNodeUtilization： 根据node上所有Pod的request请求资源量/node资源总量 来评估。

## 解决方案

1. 基于descheduler项目，通过调用其它工具（例如Prometheus）来获取node资源的实际使用情况UsedResource，然后进行 UsedResource/node资源总量 来评估，是否需要将Pod调度到另一个节点上。

### 实施过程
1. 功能：可以获取node节点的资源使用情况metrics。 
2. 功能：可以获取Pod的资源使用情况metrics。 

3. 如何获取Pod的资源使用情况metrics ？？？？

3. 功能：根据metrics评估将pod调度到资源最富余的节点上。 
