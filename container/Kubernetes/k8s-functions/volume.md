---
created_date: 2020-11-16
---

[TOC]

## Volume
- 参考文档
https://kubernetes.io/docs/concepts/storage/volumes/
https://www.kubernetes.org.cn/4069.html

- volume 是kubernetes Pod中多个容器访问的共享目录。
- volume 被定义在pod上，被这个pod的多个容器挂载到相同或不同的路径下。
- Volume 的生命周期独立于容器。

### 常见的Volume类型
1. EmptyDir  
    把宿主机的空目录挂载进pod, 会在宿主机上创建数据卷目录并挂在到容器中。  
    Pod被删除后，数据也会丢失。  

2. HostPath
    把宿主机的真实存在的目录挂载进Pod。
    Pod被删除后，数据不会丢失。

3. Ceph
    - Ceph RBD：可读写的方式映射只能映射给一个用户使用，只读的方式可以同时映射给多个用户使用。
    - CephFS：可读写的方式能映射给多个用户使用。

4. NFS  
    NFS是Network File System的简写，即网络文件系统，NFS是FreeBSD支持的文件系统中的一种。
    NFS基于RPC(Remote Procedure Call)远程过程调用实现，其允许一个系统在网络上与它人共享目录和文件。
    通过使用NFS，用户和程序就可以像访问本地文件一样访问远端系统上的文件。
    NFS是一个非常稳定的，可移植的网络文件系统。具备可扩展和高性能等特性，达到了企业级应用质量标准。由于网络速度的增加和延迟的降低，NFS系统一直是通过网络提供文件系统服务的有竞争力的选择。
    ```yaml
        volumes:
            - name: volumes-name
            nfs:
                path: ${path}
                server: ${IP}
    ```
### 概念讲解
- PersistentVolumeClaim
    
    pod - pvc - pv 是用户对存储资源的请求
    pod - * - node
- subPath
    volumeMounts.subPath
    指定卷中的一个子目录，映射进容器内。