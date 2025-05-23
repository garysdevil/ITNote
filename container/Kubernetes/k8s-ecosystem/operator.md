---
created_date: 2020-11-16
---

[TOC]

# 

- 参考文档\
  https://blog.51cto.com/xjsunjie/2422877?source=dra

- Operator 基于 CRD，并通过控制器来保证应用处于预期状态。

1.

operator跟docker是相似的，而其主要的交付对象从单个的应用实例，扩展到了多实例、分布式的系统上。以往部署一个分布式系统需要启动多个容器，然后进行复杂的配置，而现在只要创建一个CRD。operator将自动进行分布式系统中需要的各个资源的创建和部署。从这个角度上来说，operator的目标是实现分布式系统的标准化交付。

2.

如果说docker是奠定的单实例的标准化交付，那么Helm则是集群化多实例、多资源的标准化交付。

3. 编排角度
   Helm跟operator有非常多的共性，很难对两者的作用进行区分。Helm也可以完成分布式系统的部署。那么operator跟Helm又有什么样的区别呢？Helm的侧重点在于多种多个的资源管理，而对生命周期的管理主要包括创建更新和删除。Helm通过命令驱动整个的生命周期。
   而operator对于资源的管理则不仅是创建和交付。由于其可以通过watch的方式获取相关资源的变化事件，因此可以实现高可用、可扩展、故障恢复等运维操作。因此operator对于生命周期的管理不仅包括创建，故障恢复，高可用，升级，扩容缩容，异常处理，以及最终的清理等等。
