---
created_date: 2020-12-23
---

[TOC]

## static pod

https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/

- static pod

1. 是由kubelet直接管理的，k8s api server并不会感知到static pod的存在，也不会和任何一个replication controller关联上，完全是由kubelet进程来监管，并在它崩溃的时候负责重启。
2. Kubelet会通过api server为每一个static pod创建一个对应的mirror pod
3. 有static pod和mirror pod的映射关系，kubelet在运行时就可以通过UID或者Fullname索引到任意pod，以及获取全部在本节点上运行的pod。
