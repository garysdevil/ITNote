---
created_date: 2020-12-17
---

[TOC]

## Schedule
- 参考  
https://draveness.me/system-design-scheduler/  
- 调度器的设计最终都会归结到一个问题上 — 如何对资源高效的分配和调度以达到我们的目的，可能包括对资源的合理利用、最小化成本、快速匹配供给和需求。

## Controller
- 控制器最常见的定义：使得系统的当前状态达到所期望的状态的代码。

## K8S Schedule
- 参考
  - https://kubernetes.io/zh/docs/reference/scheduling/policies/

- 整个调度过程分两步：
    1. Predicates 过滤出可用的节点  Predicates Policies
    2. Priorities 通过打分机制选择出最适合的节点  Priorities Policies
### 调度阶段
1. QueueSort
2. PreFilter
3. PreFilter
4. PreScore
5. Score
6. Reserve
7. Permit
8. Permit
9. PostBind

#### 自定义调度器
- 使用自定义调度器
pod.Spec.schedulerName

#### scheduler扩展方案
- 参考 https://blog.csdn.net/i_want_to_be_a_god/article/details/106969992

- 目前Kubernetes支持四种方式实现客户自定义的调度算法(预选&优选)，如下：

1. default-scheduler recoding
直接在Kubernetes默认scheduler基础上进行添加，然后重新编译kube-scheduler

2. standalone: 
实现一个与kube-scheduler平行的custom scheduler，单独或者和默认kube-scheduler一起运行在集群中

3. scheduler extender: 
实现一个"scheduler extender"，kube-scheduler会调用它(http/https)作为默认调度算法(预选&优选&bind)的补充

4. scheduler framework: 
实现scheduler framework plugins，重新编译kube-scheduler，类似于第一种方案，但是更加标准化，插件化

#### 驱逐
1. 硬驱逐
2. 软驱逐

- MemoryPressure
禁止BestEffort类型的Pod调度到节点上

- DiskPressure
禁止新的Pod调度到节点上
## K8S Controller

## K8S Kubelet
- 参考
    - https://kubernetes.io/zh/docs/tasks/administer-cluster/reserve-compute-resources/
    - https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/
    - https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/
    - https://kubernetes.io/docs/concepts/architecture/nodes/
    - https://www.alibabacloud.com/blog/kubernetes-eviction-policies-for-handling-low-ram-and-disk-space-situations---part-1_595202
    - https://www.infoq.cn/article/rrsrvv093hh6f1ymkcez
    - https://eksctl.io/usage/customizing-the-kubelet/

-  术语
    - allocatable = NodeCapacity - [kube-reserved] - [system-reserved] - [eviction-threshold] 
    - /sys/fs/cgroup/memory/kubepods/memory.limit_in_bytes = NodeCapacity - [kube-reserved] - [system-reserved] - [eviction-threshold] 
    - kubectl top node  = 实际使用资源 / (NodeCapacity - [kube-reserved] - [system-reserved] - [eviction-threshold]) 经验证EKS的计算方式不计入eviction-threshold，GKE的计入
    1. Node Capacity：Node 的硬件资源总量；
    2. kube-reserved：为 k8s 系统进程预留的资源(包括 kubelet、container runtime 等，不包括以 pod 形式的资源)；
    3. system-reserved：为 linux 系统守护进程预留的资源；
    4. eviction-threshold：通--eviction-hard 参数指定为节点预留的资源，当实际资源量达不到预留资源量时将触发驱逐Pod的操作；
    5. allocatable：可供节点上 Pod 使用的资源，kube-scheduler 调度 Pod 时的参考此值。

- 驱逐  
官方说实际使用资源大于allocatable则触发驱逐
```bash
# 查看节点的allocatable资源、实际使用资源
# 当left<0时发生驱逐
allocatable=`cat /sys/fs/cgroup/memory/kubepods/memory.limit_in_bytes`
used=`cat /sys/fs/cgroup/memory/kubepods/memory.usage_in_bytes`

left=$((allocatable-used))

left=$((left/1024/1024))M
allocatable=$((allocatable/1024/1024))M
used=$((used/1024/1024))M

echo "allocatable=$allocatable"
echo "used=$used"
echo "left=$left"

# used/allocatable # 理论上kubectl top node等于used/allocatable，但往往都大于used/allocatable
```

- Kubelet Node Allocatable 的代码  
主要在 pkg/kubelet/cm/node_container_manager.go

- 查看当前node的资源是否达到压力值  
kubectl describe node ${nodename} | grep 'MemoryPressure\|DiskPressure\|PIDPressure'

- kubernetes 服务器版本必须至少是 1.17 版本，才能使用 kubelet 命令行选项 --reserved-cpus 设置 显式预留 CPU 列表。  

- 默认情况下，kubelet 没有做资源预留限制，这样节点上的所有资源都能被 Pod 使用。

### 配置讲解
1. 参数
```conf
# 1. Kube预留值: 
--kube-reserved=[cpu=100m][,][memory=100Mi][,][ephemeral-storage=1Gi][,][pid=1000]
# 2. 系统预留值: 
--system-reserved=[cpu=100m][,][memory=100Mi][,][ephemeral-storage=1Gi][,][pid=1000]
# 3. 硬驱逐阈值 
--eviction-hard=[memory.available<500Mi] # 非优雅关闭 # 默认值 memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<15%
# 4. 软驱逐阈值 
--eviction-soft=[memory.available<1024Mi] # 优雅关闭
# 5. 软驱逐观察时间 
--eviction-soft-grace-period="" # 默认为90秒

# 驱逐时Pod的最大关闭时间
--eviction-max-pod-grace-period="0"
# 评估是否达到驱除阈值的频率
--housekeeping-interval="10s" #默认为10秒
```

### GKE
```bash
/home/kubernetes/bin/kubelet --config /home/kubernetes/kubelet-config.yaml ...
```
cat /home/kubernetes/kubelet-config.yaml
```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: /etc/srv/kubernetes/pki/ca-certificates.crt
authorization:
  mode: Webhook
cgroupRoot: /
clusterDNS:
- 10.68.0.10
clusterDomain: cluster.local
enableDebuggingHandlers: true
evictionHard:
  memory.available: 100Mi
  nodefs.available: 10%
  nodefs.inodesFree: 5%
  pid.available: 10%
featureGates:
  DynamicKubeletConfig: false
  RotateKubeletServerCertificate: true
  TaintBasedEvictions: false
kind: KubeletConfiguration
kubeReserved:
  cpu: 1060m
  ephemeral-storage: 41Gi
  memory: 512Mi
readOnlyPort: 10255
serverTLSBootstrap: true
staticPodPath: /etc/kubernetes/manifests
```
### EKS
cat /etc/eksctl/kubelet.yaml
### 其它
1. 配置
```
修改/etc/sysconfig/kubelet
```conf
# 在kubelet的启动参数中添加：
KUBELET_EXTRA_ARGS="
--enforce-node-allocatable=pods,kube-reserved,system-reserved \
--cgroup-driver=cgroupfs \
--kube-reserved=cpu=1,memory=1Gi,ephemeral-storage=10Gi \
--kube-reserved-cgroup=/system.slice/kubelet.service \
--system-reserved cpu=1,memory=2Gi,ephemeral-storage=10Gi \
--system-reserved-cgroup=/system.slice \
--eviction-hard=memory.available<2Gi"

```
2. 设置cgroup结构可参考官方建议。
```bash
# 所以需要手工创建相应cpuset子系统：
sudo mkdir -p /sys/fs/cgroup/cpuset/system.slice
sudo mkdir -p /sys/fs/cgroup/cpuset/system.slice/kubelet.service
```