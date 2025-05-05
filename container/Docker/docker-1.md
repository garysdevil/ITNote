---
created_date: 2020-12-04
---

[TOC]

# docker
- https://docs.docker.com
- https://www.infoq.cn/article/docker-kernel-knowledge-namespace-resource-isolation  namespace
- https://www.infoq.cn/article/docker-kernel-knowledge-cgroups-resource-isolation   cgroup

## 原理
### Docker底层使用的Linux技术
- https://www.jianshu.com/p/ab423c3db59d
1. 容器 = cgroup + namespace + rootfs + 容器引擎
2. 每个容器都是一个进程，这种进程拥有自己的特殊的子namespace、cgroup设置和rootfs挂载
  - cgroup： 资源控制  https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html?highlight=cgroups
  - namespace： 访问隔离
  - rootfs：文件系统隔离。镜像的本质就是一个rootfs文件
  - 容器引擎：生命周期控制

### 组件
1. docker：命令行管理工具

2. dockerd：Docker守护进程，负责与docker client交互；

3. containerd：负责镜像管理和容器管理的守护进程，containerd是一个标准的容器运行时，可以独立管理容器生命周期，也就是即使不运行dockerd，容器也能正常工作；

4. containerd-shim：是一个真实运行的容器的载体，每启动一个容器都会起一个新的shim的一个进程；

5. runC：一个命令行工具，根据OCI标准来创建和运行容器。

### docker run创建一个容器时的大致流程
1. docker工具向dockerd守护进程发送创建容器请求；

2. dockerd收到请求后再向containerd 请求创建一个容器；

3. containerd收到请求后并不会直接创建容器，而让containerd-shim 创建容器；

4. containerd-shim又调用runC创建容器（准备容器所需的namespace和cgroups就退出了），containerd-shim 就作为了该容器进程的父进程，负责收集容器状态并上报给containerd。