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


### 
- 驱逐
  1. 硬驱逐
  2. 软驱逐

## K8S Controller


## K8S kubelet
- https://kubernetes.io/zh/docs/tasks/administer-cluster/reserve-compute-resources/
- https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/
- https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/
- https://www.alibabacloud.com/blog/kubernetes-eviction-policies-for-handling-low-ram-and-disk-space-situations---part-1_595202
- https://www.infoq.cn/article/rrsrvv093hh6f1ymkcez

- 节点可供Pod使用资源总量的计算公式
  - allocatable = NodeCapacity - [kube-reserved] - [system-reserved]
  - /sys/fs/cgroup/memory/kubepods/memory.limit_in_bytes = NodeCapacity - [kube-reserved] - [system-reserved]
  - kubectl top node  = 实际使用资源 / (NodeCapacity - [kube-reserved] - [system-reserved] - [eviction-threshold])
  1. Node Capacity：Node 的硬件资源总量；
  2. kube-reserved：为 k8s 系统进程预留的资源(包括 kubelet、container runtime 等，不包括以 pod 形式的资源)；
  3. system-reserved：为 linux 系统守护进程预留的资源；
  4. eviction-threshold：通--eviction-hard 参数为节点预留内存；
  5. allocatable：可供节点上 Pod 使用的容量，kube-scheduler 调度 Pod 时的参考此值。

- Kubelet Node Allocatable 的代码
主要在 pkg/kubelet/cm/node_container_manager.go

- 查看当前node的资源是否达到压力值
kubectl describe node ${nodename} | grep 'MemoryPressure\|DiskPressure\|PIDPressure'


- kubernetes 服务器版本必须至少是 1.17 版本，才能使用 kubelet 命令行选项 --reserved-cpus 设置 显式预留 CPU 列表。

- 示范
```conf
# 1. Kube预留值: 
--kube-reserved=[cpu=100m][,][memory=100Mi][,][ephemeral-storage=1Gi][,][pid=1000]
# 2. 系统预留值: 
--system-reserved=[cpu=100m][,][memory=100Mi][,][ephemeral-storage=1Gi][,][pid=1000]
# 3. 硬驱逐阈值 
--eviction-hard=[memory.available<500Mi] # 非优雅关闭 # 默认值 imagefs.available<15%,memory.available<100Mi,nodefs.available<10%,nodefs.inodesFree<5%
# 4. 软驱逐阈值 
--eviction-soft=[memory.available<1024Mi] # 优雅关闭
# 5. 软驱逐观察时间 
--eviction-soft-grace-period="" # 默认为90秒

# 驱逐时Pod的最大关闭时间
--eviction-max-pod-grace-period="0"
```
--eviction-hard，用来配置 kubelet 的 hard eviction 条件，只支持 memory 和 ephemeral-storage 两种不可压缩资源。当出现 MemoryPressure 时，Scheduler 不会调度新的 Best-Effort QoS Pods 到此节点。当出现 DiskPressure 时，Scheduler 不会调度任何新 Pods 到此节点。
如果资源小于(kube-reserved + system-reserved + eviction-threshold), kubelet 将会驱逐Pod


- 默认情况下，kubelet 没有做资源预留限制，这样节点上的所有资源都能被 Pod 使用。

### 配置
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
- 设置cgroup结构可参考官方建议。
```bash
# 所以需要手工创建相应cpuset子系统：
sudo mkdir -p /sys/fs/cgroup/cpuset/system.slice
sudo mkdir -p /sys/fs/cgroup/cpuset/system.slice/kubelet.service
```
kubelet --config /home/kubernetes/kubelet-config.yaml


```bash
a=`cat /sys/fs/cgroup/memory/kubepods/memory.limit_in_bytes`
b=`cat /sys/fs/cgroup/memory/kubepods/memory.usage_in_bytes`
c=$((a-b))
d=$((c/1024/1024))
echo $d
```