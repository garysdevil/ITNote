---
created_date: 2024-12-30
---

[TOC]

## 容器的主要功能

1. 应用隔离 - 通过命名空间和控制组实现进程、网络、文件系统等资源的隔离,使应用运行在独立环境中。
2. 轻量级虚拟化 - 相比传统虚拟机,容器共享主机操作系统内核,启动更快、资源占用更少。
3. 可移植性 - 将应用及其依赖打包,确保在不同环境中都能稳定运行。
4. 版本控制 - 支持镜像的分层存储和版本管理,方便回滚和升级。

## 容器编排的主要功能

1. 容器调度：

   1. 自动将容器分配到适当的主机上运行，基于可用的资源（CPU、内存等）进行最优部署。

2. 自动扩容与缩容：

   1. 根据应用负载的变化，动态增加或减少容器数量以满足需求，优化资源利用。

3. 容错与自愈：

   1. 当容器出现故障时，自动检测并重启失败的容器。
   2. 如果某个节点故障，容器编排工具会将其工作负载重新分配到其他健康的节点。

4. 服务发现与负载均衡：

   1. 自动管理容器间的通信，通过服务发现机制找到对应的服务。
   2. 实现流量的负载均衡，提高服务的可用性。

5. 版本管理与回滚：

   1. 支持蓝绿部署或滚动升级，可以无缝更新服务到新版本。
   2. 如果出现问题，可以快速回滚到先前的稳定版本。

6. 资源监控和日志管理：

   1. 提供对容器资源使用的实时监控（如 CPU、内存使用）和性能指标的收集，帮助管理员优化集群性能。

## 思考

1. 当前状况： 业务程序运行在容器内，这些容器由容器编排系统管理。
2. 问题： 如果容器或容器编排系统出现故障，业务程序会崩溃。
3. 需求： 我希望有一种工具，暂且称之为“程序治理系统”，具有以下功能：
   1. 实现类似于容器编排系统（如Kubernetes）对容器编排的主要功能，“程序治理系统”实现了对业务程序的直接编排。
   2. “程序治理系统”自身出现问题时不影响业务程序的正常运行。
4. 实现“程序治理系统”的思路或要求：
   1. 独立架构：业务程序和“程序治理系统”独立运行，互不影响。因此，“程序治理系统”出现故障时，业务系统依然可以正常运作。
   2. 主动监测：“程序治理系统”主动监控业务程序，获取相关指标，并执行相应的编排任务。
