https://kubernetes.io/docs/concepts/policy/limit-range/
https://kubernetes.io/zh/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/

### 概览

1. 服务质量等级
- QoS Class（Quality of service class）
- kubernetes 通过requests 和limits 来判断服务质量等级，以维护服务器的安全性。
  1. Guaranteed:优先级最高。pod中每个容器同时定义了cpu和memory的request和limit，并且两者的request=limit；
  2. Burstable:优先级中等。pod中至少有一个容器定义了cpu或memory的request属性，且二者不一定要相等；
  3. BestEffort:优先级最低。pod中没有任何一个容器定义了request或limit属性；
  
2. 
requests.cpu被转成docker的--cpu-shares参数，与cgroup cpu.shares功能相同
requests.memory没有对应的docker参数，作为k8s调度依据

limits.cpu会被转换成docker的–cpu-quota参数。与cgroup cpu.cfs_quota_us功能相同
limits.memory会被转换成docker的–memory参数。用来限制容器使用的最大内存

### 设置limit和request
- CPU的默认单位多少核cpu 
  100m = 0.1CPU
- 内存的默认单位是Ki
  可用用的单位 E, P, T, G, M, K, Ei, Pi, Ti, Gi, Mi, Ki

1. 设置整个命名空间里容器cpu和memory的requests和limits默认值
```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: limit-mem-cpu-per-container
spec:
  limits:
  - max: # Pod中容器可以设置的最大限制
      cpu: "1"
      memory: "1Gi"
    min: # Pod中容器可以设置的最小请求
      cpu: "100m"
      memory: "99Mi"
    default: # 容器中容器的默认限制
      cpu: "700m"
      memory: "900Mi"
    defaultRequest: # Pod中容器的默认请求
      cpu: "110m"
      memory: "111Mi"
    type: Container
```

2. 单独限制container的cpu和memory
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox-01
    image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo hello ; sleep 60;done"]
    resources:
      limits:
        memory: "200Mi"
        cpu: "500m"
    resources:
      requests:
        memory: "100Mi"
        cpu: "100m"
```

3. 容器声明了内存限制，而没有声明内存请求；内存请求被设置为它的内存限制相同的值。

4. 容器声明了内存请求，但没有内存限制；则使用命名空间的默认内存限制。