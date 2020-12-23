## Schedule
- 参考  
https://draveness.me/system-design-scheduler/  
- 调度器的设计最终都会归结到一个问题上 — 如何对资源高效的分配和调度以达到我们的目的，可能包括对资源的合理利用、最小化成本、快速匹配供给和需求。

### k8s Schedule
- 整个调度过程分两步：
    1. Predicates 过滤出可用的节点  Predicates Policies
    2. Priorities 通过打分机制选择出最适合的节点  Priorities Policies
- 驱逐
  1. 硬驱逐
  2. 软驱逐


## controller
- 控制器最常见的定义：使得系统的当前状态达到所期望的状态的代码。