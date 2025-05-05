---
created_date: 2020-11-16
---

[TOC]

### ConfigMap

- 基于v1.18版本
- 参考文档
  https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/

#### 概览

1. 应用打包为容器镜像后，可以通过环境变量或者外挂文件的方式在创建容器时进行配置注入。在大规模容器集群的环境中，对多个容器进行不同的配置将变得非常复杂。因此从Kubernetes v1.2开始提供了一种统一的应用配置管理方案 ConfigMap。

2. ConfigMap功能：允许配置文件与镜像文件分离，以使容器化的应用程序具有可移植性。

#### 创建 ConfigMap

- 创建ConfigMap的方式有4种：kubectl create configmap ConfigMap_Name Data_Source

  1. 方式一 通过直接在命令行中指定configmap参数创建 --from-literal
  2. 方式二 通过指定文件创建，即将一个配置文件创建为一个ConfigMap，--from-file=文件路径 --from-file=文件路径
  3. 方式三 通过一个文件内多个键值对创建，--from-env-file=文件路径
  4. 方式四 事先写好标准的configmap的yaml文件，然后kubectl create -f yaml文件路径。

- 定义一个键值对文件
  vim configmap/test-cm.properties

```properties
key1=value1
key2=value2
```

1. 方式一

```bash
kubectl create configmap test-cm-4 --from-literal=key1=value1 --from-literal=key2=value2
```

2. 方式二

```bash
# key默认为文件名，value为文件的内容。
kubectl create configmap test-cm-1 --from-file=configmap/test.properties
# 或者
kubectl create configmap test-cm-1 --from-file=自定义key的名称=configmap/test.properties
```

3. 方式三

```
kubectl create configmap test-cm-3 --from-env-file=configmap/test.properties
```

4. 方式四

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-cm
  namespace: default
data:
  # example of a simple property defined using --from-literal
  example.property.1: hello
  example.property.2: world
  # example of a complex property defined using --from-file
  example.property.file: |-
    property.1=value-1
    property.2=value-2
    property.3=value-3
```

5. 通过生成器方式创建 - 不知道 实践失败

- 从1.14 开始，k8s 开始支持使用yaml创建ConfigMap。

```bash
cat <<EOF >./kustomization.yaml
configMapGenerator:
- name: test-cm-5
  files:
  - configmap/test.properties
EOF
```

#### 在Pod中使用ConfigMap

- 主要有3种使用方式
  1. 将 ConfigMap 的数据定义为容器的环境变量 方式一 方式二
  2. 直接在Pod的yaml中使用ConfigMap的数据 方式三
  3. 将 ConfigMap 的数据挂载进数据卷中 方式四 方式五
- 当ConfigMap被更新时
  - 将 ConfigMap 的数据定义为容器环境变量，环境变量不会同步更新。
  - 将 ConfigMap 挂载进 Volume 中的数据需要一段时间（实测大概10秒）才能同步更新。热加载。

1. 使用 ConfigMap 数据定义容器环境变量

- 关键字 env valueFrom

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test-container
    image: busybox
    command: ["/bin/sh", "-c", "env | grep 环境变量的名字"]
    env:
    - name: 环境变量的名字
      valueFrom:
        configMapKeyRef:
          name: ConfigMap的名字
          key: garys.github
  restartPolicy: Never
```

2. 将 ConfigMap 中的所有键值对配置为容器环境变量

- 关键字 envFrom

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
    - name: test-container
      image: busybox
      command: [ "/bin/sh", "-c", "env" ]
      envFrom:
      - configMapRef:
          name: ConfigMap的名字
  restartPolicy: Never
```

3. 在 Pod 命令中直接使用 ConfigMap 定义的环境变量

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: busybox
      command: [ "/bin/sh", "-c", "echo $(KEY_1) $(KEY_2)" ]
      env:
        - name: KEY_1
          valueFrom:
            configMapKeyRef:
              name: ConfigMap的名字
              key: ConfigMap里的键
        - name: KEY_2
          valueFrom:
            configMapKeyRef:
              name: ConfigMap的名字
              key: ConfigMap里的键
  restartPolicy: Never

```

4. 将 ConfigMap 数据写入卷中

- 所有数据键值对 添加到容器中的特定路径下
- 最外层的键将被定义为文件的名字

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "ls /etc/config/" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: ConfigMap的名字
  restartPolicy: Never
```

5. 将 ConfigMap 的某个文件 数据写入卷中

- 数据键值对 添加到容器中的特定路径下

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh","-c","cat /etc/config/自定义文件名A" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: ConfigMap的名字
        items:
        - key: ConfigMap的key
          path: 自定义文件名A
  restartPolicy: Never
```
