---
created_date: 2020-11-16
---

[TOC]

## pv 和 pvc

1. 创建pv

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv003
  labels:
    app: vnc003
  namespace: vnc-space
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/home/pv"
```

2. 创建pvc
   使用静态pv

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc003
  labels:
    app: vnc003
  namespace: vnc-space
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
  selector:
    matchLabels:
      app: vnc003
```

使用动态pv

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc003
  labels:
    app: vnc003
  namespace: vnc-space
spec:
  storageClassName: StorageClassName # 使用动态存储
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
```

get pv --show-labels
get pvc --show-labels
3\. 创建pod使用pvc

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    role: web-frontend
  namespace: vnc-space
spec:
  containers:
  - name: web
    image: nginx
    ports:
      - name: web
        containerPort: 80
    volumeMounts:
        - name: pv001
          mountPath: "/usr/share/nginx/html"
  volumes:
  - name: pv001
    persistentVolumeClaim: ## <--这字段
      claimName: pvc003
```

## storageclass

#### 使用教程

- StorageClass：Kubernetes提供一种自动创建PV的机制，它的作用就是创建PV的模板。
- node节点上必须已经安装了ceph客户端。yum -y install ceph-common

1. 配置使用ceph存储池的密钥
   project-ceph-secret.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ceph-project-secret # 在StorageClass配置中需要使用到
  namespace: kube-system
type: "kubernetes.io/rbd"
data:
  key: QVFEaGhGTmVrQTE4S3hBQUhvNU5lcFJ0bm8yL0djaWd5b2JndkE9PQ==
```

2. 配置连接存储池
   ceph-rbd-sc.yaml

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
   name: project-ceph-rbd # 在pvc配置中需要使用到
provisioner: kubernetes.io/rbd #=存储池yaml里定义的PROVISIONER_NAME
parameters:
  monitors: ${IP1}:6789,${IP2}:6789,${IP3}:6789
  adminId: project
  adminSecretName: project-ceph-secret
  adminSecretNamespace: kube-system
  pool: project # default rbd
  userId: project
  userSecretName: project-ceph-secret
  userSecretNamespace: kube-system
```

3. 在StatefulSet的yaml中添加如下pvc配置

```yaml
volumeClaimTemplates:
- metadata:
    name: datadir
  spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "project-ceph-rbd"
      resources:
      requests:
          storage: 20Gi
```

5. 具体使用示范1，创建pvc，在pod的yaml中使用pvc

```yaml
### 创建pvc
apiVersion: "v1"
kind: "PersistentVolumeClaim"
metadata: 
  name: "pvc-project-test"
  namespace: "dam-project-qa"
  #annotations: 
  #  volume.beta.kubernetes.io/storage-class: "project-ceph-rbd"
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: "project-ceph-rbd"
  resources:
    requests:
      storage: "1Mi"
---
kind: Pod
apiVersion: v1
metadata:
  name: test-pod
  namespace: dam-project-qa
spec:
  containers:
  - name: test-pod
    image: busybox
    imagePullPolicy: IfNotPresent
    command:
    - "/bin/sh"
    args:
    - "-c"
    - "touch /mnt/SUCCESS && sleep 6000"
    volumeMounts:
    - name: testaa
      mountPath: "/mnt"
  restartPolicy: "Never"
  nodeSelector:
    DA: "project-node"
  volumes:
  - name: testaa # 只能是小写字母和数字
    persistentVolumeClaim:
      claimName: pvc-project-test
```

6. 具体使用示范2，在statefulset中使用volumeClaimTemplates

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: test-pod
  namespace: dam-project-qa
spec:
  replicas: 1
  serviceName: "test-app-srv"
  selector:
    matchLabels:
      app: test-app
  template:
    metadata:
      labels:
        app: test-app
    spec:
      containers:
      - name: test-pod
        image: busybox
        imagePullPolicy: IfNotPresent
        command:
        - "/bin/sh"
        args:
        - "-c"
        - "touch /mnt/SUCCESS && sleep 6000"
        volumeMounts:
        - name: testaa
          mountPath: "/mnt"
      restartPolicy: "Always"
      tolerations:
      - key: "dam-taint"
        operator: "Equal"
        value: "project"
        effect: "NoSchedule"
      nodeSelector:
        DA: "project-node"
  volumeClaimTemplates:
  - metadata:
      name: testaa
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "project-ceph-rbd"
      resources:
        requests:
          storage: 1Mi
```

#### 遇到的错误

1. node 节点必须有rbd命令（ceph客户端）
   yum -y install ceph-common

```log
Events:
  Type     Reason                  Age                 From                     Message
  ----     ------                  ----                ----                     -------
  Normal   Scheduled               18m                 default-scheduler        Successfully assigned dam-project-qa/test-pod to ${IP}
  Normal   SuccessfulAttachVolume  18m                 attachdetach-controller  AttachVolume.Attach succeeded for volume "pvc-3b915153-5792-11ea-a7f6-005056aa7207"
  Warning  FailedMount             49s (x16 over 17m)  kubelet, ${IP}    MountVolume.WaitForAttach failed for volume "pvc-3b915153-5792-11ea-a7f6-005056aa7207" : fail to check rbd image status with: (executable file not found in $PATH), rbd output: ()
  Warning  FailedMount             15s (x8 over 16m)   kubelet, ${IP}    Unable to mount volumes for pod "test-pod_dam-project-qa(3fff8481-5798-11ea-8fa4-005056aa0b04)": timeout expired waiting for volumes to attach or mount for pod "dam-project-qa"/"test-pod". list of unmounted volumes=[testaa]. list of unattached volumes=[testaa default-token-2724w]
```

2. 只有 StatefulSet 支持使用 volumeClaimTemplates

```log
error: error validating "test1.yaml": error validating data: ValidationError(StatefulSet.spec.template): unknown field "volumeClaimTemplates" in io.k8s.api.core.v1.PodTemplateSpec; if you choose to ignore these errors, turn validation off with --validate=false
```

3. StatefulSet 不支持 restartPolicy 策略为Never

```log
The StatefulSet "test-pod" is invalid: spec.template.spec.restartPolicy: Unsupported value: "Never": supported values: "Always"
```

## 持久化存储卷和声明的生命周期

https://blog.csdn.net/bbwangj/article/details/82355337

1. 在Kubernetes集群中

- PV 作为存储资源存在。
- PVC 是对PV资源的请求和使用，也是对 PV 存储资源的”提取证”。
- Pod 通过 PVC 来使用 PV。

2. PV 和 PVC 之间的交互过程有着自己的生命周期。

- 这个生命周期分为5个阶段：
  供应(Provisioning)：即PV的创建，可以直接创建PV（静态方式），也可以使用StorageClass动态创建
  绑定（Binding）：将PV分配给PVC
  使用（Using）：Pod通过PVC使用该Volume
  释放（Releasing）：Pod释放Volume并删除PVC
  回收（Reclaiming）：回收PV，可以保留PV以便下次使用，也可以直接从云存储中删除
- 根据上述的5个阶段，存储卷的存在下面的4种状态：
  Available：可用状态，处于此状态表明PV以及准备就绪了，可以被PVC使用了。
  Bound：绑定状态，表明PV已被分配给了PVC。
  Released：释放状态，表明PVC解绑PV，但还未执行回收策略。
  Failed：错误状态，表明PV发生错误。
