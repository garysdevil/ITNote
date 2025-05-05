---
created_date: 2020-11-16
---

[TOC]

## configmap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: start-cm
  namespace: default
data:
  nacos_addr: xxx.com:8848
```

## service

### ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: module-name-svc
  namespace: default
  # annotations:
  #   prometheus.io/http-probe: 'true'
  #   prometheus.io/http-probe-port: '8080'
  #   prometheus.io/http-probe-path: '/actuator/health'
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
    # nodePort: 30062 # 默认范围30000-32767
  selector:
    app: module-name
  type: ClusterIP
  # type: NodePort 

```

### service aws LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  name: module-name-elb
  annotations:
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "120"
    #  service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0 # aws内部才能访问
    #  service.beta.kubernetes.io/aws-load-balancer-extra-security-groups: security-group-ID # 安全组
    #  service.beta.kubernetes.io/aws-load-balancer-ssl-cert:  arn:aws:acm:eu-central-1:some-account-id:certificate/some-cert-id # 配置ssl证书
    #  service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https-port"

spec:
  ports:
    - name: http-port
      port: 80
      targetPort: http-port
    # - name: https-port
    #   port: 443
    #   targetPort: http-port

  selector:
    app: module-name
  type: LoadBalancer
#  # 指定只有特定的IP可以访问
#  loadBalancerSourceRanges: 
#     - X.X.X.X/32
```

### service google LoadBalancer

```yaml
kind: Service
apiVersion: v1
metadata:
  namespace: starssea
  name: module-name-elb
  # annotations:
  #   cloud.google.com/load-balancer-type: "Internal" # 定义集群内部才能访问
spec:
 selector:
   name: dawn-prod
 ports:
   - name: http-port
     port: 8080
     targetPort: htpp-port
 type: LoadBalancer
```

## deployment

1. standad

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    project: project-name
    envoriment: test
    app: module-name
  name: module-name
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: module-name
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: module-name
    spec:
    #   tolerations:
    #   - key: "key-name"
    #     operator: "Equal"
    #     value: "value-name"
    #     # effect: "NoSchedule"
    #   nodeSelector:
    #     key-name: "value-name"
      # initContainers:
      # - name: init
      #   image: busybox
      #   command: [ "/bin/bash", "-c", "--" ]
      #   args: [ "echo 'doing init'" ]
      containers:
      - image: repo-name/module-name:tag-name
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "touch tmp1.tmp" ]
        lifecycle:
          postStart:
            exec:
              command: ["/bin/bash", "-c","--", "touch tmp2.tmp"]
        # envFrom:
        # - configMapRef:
        #     name: start-cm
        # - secretRef:
        #     name: secret  
        imagePullPolicy: Always
        name: module-name
        # resources:
        #   requests:
        #     cpu: 1
        #     memory: 3Gi
        #   limits:
        #     cpu: 2
        #     memory: 6Gi
        ports:
        - containerPort: 8080
          name: http
          protocol: TCP
        # readinessProbe:
        #   httpGet:
        #     path: /actuator/health
        #     port: 8080
        #     scheme: HTTP
        #   initialDelaySeconds: 10
        #   periodSeconds: 10
        #   failureThreshold: 11
        #   successThreshold: 1
        #   timeoutSeconds: 10
        # livenessProbe:
        #   httpGet:
        #     path: /actuator/health
        #     port: 8080
        #     scheme: HTTP
        #   initialDelaySeconds: 120
        #   periodSeconds: 10
        #   failureThreshold: 6
        #   successThreshold: 1
        #   timeoutSeconds: 10
      # nodeName: node01
      dnsPolicy: ClusterFirst
      restartPolicy: Always
```

## busybox

1.

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: test-busybox-pod
spec:
  containers:
  - name: test-pod
    image: busybox
    imagePullPolicy: IfNotPresent
    tty: true
    stdin: true
    # command:
    # - "/bin/sh"
    # args:
    # - "-c"
    # - "sleep 6000"
  restartPolicy: "Never" # Always
  # nodeSelector:
  #   kubernetes.io/hostname: 10.200.79.70
```

2.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    project: project-name
    envoriment: test
    app: busybox-deploy
  name: busybox-deploy
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: busybox-deploy
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: busybox-deploy
    spec:
      containers:
      - image: busybox
        command:
        - "/bin/sh -c sleep 6000"
        lifecycle:
          preStop:
            exec:
              command:
              - "/bin/sh"
              - "-c"
              - "sleep 600s"
        imagePullPolicy: Always
        name: busybox-deploy
      restartPolicy: Always               
```

## cornjob

```yaml
piVersion: batch/v1beta1
kind: CronJob
metadata:
  name: cronjob-name
  # namespace: kube-system
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: "Forbid" # Allow/Forbid/Replace
  jobTemplate:
    spec:
      template:
        metadata:
          name: cronjob-name
        spec:
          containers:
          - name: cronjob-name
            image: busybox
            command:
              - "pwd"
          restartPolicy: "Never"
```

## job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: job-name
  # namespace: kube-system
spec:
  parallelism: 1 # 指定job需要成功运行Pods的次数。默认值: 1
  completions: 1 # 指定job在任一时刻应该并发运行Pods的数量。默认值: 1
  # activeDeadlineSeconds: # 指定job可运行的时间期限，超过时间还未结束，系统将会尝试进行终止。
  backoffLimit: 6 # 指定job失败后进行重试的次数。默认是6次，每次失败后重试会有延迟时间，该时间是指数级增长，最长时间是6min。
  template:
    metadata:
      name: job-name
    spec:
      # priorityClassName: system-cluster-critical
      containers:
        - name: job-name
          image: busybox
          command:
            - "pwd"
          resources:
            requests:
              cpu: "500m"
              memory: "256Mi"
      restartPolicy: "Never"
```

## strss

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    project: project-name
    envoriment: test
    app: module-name
  name: module-name
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: module-name
  template:
    metadata:
      labels:
        app: module-name
    spec:
      containers:
      - image: polinux/stress
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "stress --cpu 1 --io 1 --vm 1 --vm-bytes 128M --vm-hang 6000 --timeout 1h --verbose" ]
        lifecycle:
          postStart:
            exec:
              command: ["/bin/bash", "-c","--", "touch tmp2.tmp"] 
        imagePullPolicy: Always
        name: module-name
      # nodeName: node01
      dnsPolicy: ClusterFirst
      restartPolicy: Always
```
