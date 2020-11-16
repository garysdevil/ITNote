- https://kubernetes.io/docs/home/
- https://www.cnblogs.com/itzgr/p/12509968.html
- https://www.kubernetes.org.cn/3031.html
# kubernetes
- 一个开源的容器编排引擎
- 期望状态管理器，先在Kubernetes中指定应用程序期望状态（实例数，磁盘空间，镜像等），然后它会尝试把应用维持在这种状态。

## CNI、CRI、CSI
- CNI、CRI和CSI都是K8S的开放接口
CRI（Container Runtime Interface）：容器运行时接口，提供计算资源
CNI（Container Network Interface）：容器网络接口，提供网络资源
CSI（Container Storage Interface）：容器存储接口，提供存储资源
### CNI
作为容器平台的网络标准化组件，为容器提供跨网段的通信支持，是kubernetes集群overlay网络的实现关键。
```bash
# 参考文档
https://blog.csdn.net/qq_21816375/article/details/80402055
https://www.kubernetes.org.cn/6908.html
https://blog.csdn.net/u013694670/article/details/104123366
calicoctl get ippool -oyaml
```
### CSI
1. apiserver将资源编码为ProtoBuf格式进行存储。


## Kubernetes API Server
1. 默认端口
    - https API: https://IP:6443
    - http API: http://127.0.0.1:8080
3. 访问示范
curl localhost:8080/api/v1
curl -k --cert /opt/k8s/work/admin.pem --key /opt/k8s/work/admin-key.pem https://IP:6443/

4. 接口
    1. 资源对象的增、删、改、查接口。
    2. Kubernetes Proxy API接口。
        - 代理REST请求，即APIServer把收到的REST请求转发到某个Node上的kubelet守护进程的REST端口，由该kubelet进程负责响应。
            /api/v1/proxy/nodes/{name}/pods/		# 列出指定节点内所有Pod的信息
            /api/v1/proxy/nodes/{name}/stats/		# 列出指定节点内物理资源的统计信息
            /api/v1/proxy/nodes/{name}/spec/		# 列出指定节点的概要信息

5. APIServer和其它组件的交互
    1. kubelet 每隔一个时间周期，就会调用一次APIServer的REST接口报告自身状态，APIServer在接收到这些信息后，会将节点状态信息更新到etcd中。
    2. kubelet通过APIServer的Watch接口监听Pod信息，如果监听到新的Pod副本被调度绑定到本节点，则执行Pod对应的容器创建和启动逻辑；如果监听到Pod对象被删除，则删除本节点上相应的Pod容器；如果监听到修改Pod的信息，kubelet就会相应地修改本节点的Pod容器。
    3. kube-controller-manager 中的Node Controller模块通过APIServer提供的Watch接口实时监控Node的信息，并做相应处理。
    4. Scheduler 通过APIServer的Watch接口监听到新建Pod副本的信息后，会检索所有符合该Pod要求的Node列表，开始执行Pod调度逻辑，在调度成功后将Pod绑定到目标节点上。

    5. 为减少Apiserver的压力，各组件都采用缓存来缓存数据。功能模块在某些情况下不直接访问Apiserver，而是通过访问缓存来间接访问Apiserver。

kubernetes没有像其他分布式系统中额外引入MQ，是因为其设计理念采用了level trigger而非edge trigger。其仅仅通过http+protobuffer的方式，实现list-watcher机制来解决各组件间的消息通知。因此，在了解各组件通信前，必须先了解list-watch机制在kubernetes的应用。
    edge trigger边缘触发 是指每当状态变化时发生一个io事件；
    level trigger条件触发 是只要满足条件就发生一个io事件；
## master
1. Etcd：保存了整个集群的状态；

2. Apiserver：提供kubernetes所有资源增删改查的唯一入口，也是集群控制的入口，提供http Rest接口，完成集群管理，资源配额，访问控制，认证授权，以及对etcd的操作。

3. Controller manager：是集群内所有资源对象的自动化控制中心，负责pod和node的管理，节点控制器，服务控制器，副本控制器，服务账户和令牌控制器等。维护集群的状态，比如故障检测、自动扩展、滚动更新等；

4. Scheduler：负责资源的调度，按照预定的调度策略将Pod调度到相应的机器上；

## node
1. kubelet：处理Master下发到本节点的任务，管理pod及pod的容器，每个kubelet在Apiserver上注册自身信息，定期向Master汇报节点的资源使用情况，并通过cAdvisor监控容器和节点信息。

2. Container runtime：负责镜像管理以及Pod和容器的真正运行（CRI）；

3. kube-proxy：负责为Service提供cluster内部的服务发现和负载均衡。将到service的访问转发到后端的多个pod实例上，维护路由信息，对于每一个TCP类型的k8s service，kube-proxy会在本地建立一个sockerserver来负责均衡算法，使用rr负载均衡算法。   

## 部署k8s集群
1. 通过github上开源项目kubeasz以ansible方式进行部署


## 术语
1. Pod是一个逻辑概念，是Kubernetes资源调度的单元，是一组紧密关联的容器集合，是Kubernetes调度的基本单位。
Pod内的容器间共享PID、IPC、Network和UTS namespace。
Pod的设计理念是支持多个容器在一个Pod中共享网络和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务。
缺点: 不支持高并发, 高可用, 当Pod当机后无法自动恢复。

2. ReplicationController（内置pod模块）
用于解决pod的扩容缩容问题。
缺点: 无法修改template模板, 也就无法发布新的镜像版本。

3. ReplicaSet是ReplicationController的代替物，因此用法基本相同，唯一的区别在于ReplicaSet支持集合式的selector。

4. Service是pod的路由代理抽象，用于解决pod之间的服务发现问题，即上下游pod之间使用的问题。
    - 类型 ： ClusterIP, NodePort, LoadBalance
    - NodePort限制范围为30000-32767

5. Endpoint是可被访问的服务端点，即一个状态为running的pod，它是service访问的落点，只有service关联的pod才可能成为endpoint。
Endpoint=Pod的IP + 容器的端口

6. Deployment在继承Pod和Replicaset的所有特性的同时, 它可以实现对template模板进行实时滚动更新并具备我们线上的Application life circle的特性。
    每个deployment会包含一个或者多个replicaset
    每个replicaset会可以包含零个或者多个pod
    每个replicaset对应deployment的一个revision
    每次更新时，pod总是在一个replicaset中创建，然后在现有的replicaset中销毁

7. Kubernetes默认对外的NodePort限制范围为30000-32767

8. Pod配置管理：ConfigMap资源对象

9. DeaonSet

10. Job

11. cronjoob

## 资源状态
- 参考 
https://zhuanlan.zhihu.com/p/34332367
1. Pod状态
    1. Error Pod 说明启动过程中发生了错误
    2. CrashLoopBackOff 说明容器曾经启动了，但又异常退出了
2. Pod重启策略restartPolicy
    1. Always：默认取值，不管是成功退出还是失败退出，都尝试重启该容器，Pod的阶段会保持为Running
    2. OnFailure：失败的时候重启，Pod的阶段保持为Running，成功的时候不重启，Pod的阶段转为Succeeded
    3. Never：不管失败还是成功都不重启，Pod的阶段转为Failed或者Succeeded
3. 对于已完成的Pod（包括Failed和Succeeded的Pod），它们的API对象会保留在系统中。当系统中创建的Pod数量超出了指定阈值（kube-controller-manager中的terminated-pod-gc-threshold）时，控制面板会清理这些已完成的Pod(包括Failed和Succeeded的Pod)。