### 指令
https://kubernetes.io/zh/docs/reference/kubectl/cheatsheet/
1. 编辑
KUBE_EDITOR="nano" kubectl edit svc/docker-registry

2. 重启某个命名空间下的所有deployments
kubectl -n project-stg1 get deployments.apps | awk '{print $1}' | sed 1d | while read i;do kubectl -n project-stg1 rollout restart deployment $i;done

3. 开启dashboard
  https://github.com/kubernetes/dashboard
  kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'

3. kubectl get podes 
-o wide 
-n kube-system
-w 持续查看

4. 只创建pod 
kubectl run --generator=run-pod/v1 nginx-name --replicas=2 --image=nginx --port=80

5. 创建一个服务
kubectl expose deployment nginx --port=80 --type=NodePort --target-port=80 --name=nginx-service

6. 下载最新稳定版的kubectl 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

7. 更改默认命名空间
kubectl config set-context --current --namespace=default
验证
kubectl config view | grep namespace:

8. 查看所有的api资源
kubectl api-resources
  - 资源版本
  kubectl api-versions
  - 查看资源对象拥有的字段
   kubectl explain 资源名 --recursive
  - 位于名字空间中的资源
  kubectl api-resources --namespaced=true
  - 不在名字空间中的资源
  kubectl api-resources --namespaced=false

9. 查看所有Pod的状态
kubectl  get po |   awk '{count[$3]++;} END {for(i in count) {print i,"" count[i]}}' | grep -v 'STATUS'

10. node维护
cordon 命令将node1标记为不可调度，不影响任何已经在其上的Pod，但新的pod不能被调度过去。 node1状态变为SchedulingDisabled
drain 命令将运行在node1上运行的pod标记为evicted状态，随后pod平滑的转移其它节点上。
对node1进行一些节点维护的操作，如升级内核，升级Docker等；
uncordon 命令解锁node1，使其node1重新变得可调度；

11. 驱逐
每10秒驱逐一个pod
In most cases, the node controller limits the eviction rate to --node-eviction-rate (default 0.1) per second, meaning it won't evict pods from more than 1 node per 10 seconds.

11. node节点状态Ready不等于true时
If the Status of the Ready condition remains Unknown or False for longer than the pod-eviction-timeout (an argument passed to the kube-controller-manager), all the Pods on the node are scheduled for deletion by the node controller. The default eviction timeout duration is five minutes. 
True if the node is healthy and ready to accept pods, False if the node is not healthy and is not accepting pods, and Unknown if the node controller has not heard from the node in the last node-monitor-grace-period (default is 40 seconds)