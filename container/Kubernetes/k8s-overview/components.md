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
