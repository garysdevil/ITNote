

## Redis
```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: redis
  labels:
    app: redis-single
spec:
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: redis-single
        tier: backend
    spec:
      containers:
        - image: redis
          name: redis
          ports:
            - containerPort: 6379
              name: redis
          volumeMounts:
            - name: redis
              mountPath: /data
      volumes:
        - name: redis
          persistentVolumeClaim:
            claimName: redis-single-pvc # pvc的名字
```
```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  labels:
    app: redis-single
spec:
  ports:
    - port: 6379
      targetPort: 6379
  selector:
    app: redis-single
    tier: backend
```

## Redis Cluster
### 部署redis
```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9121"
  name: redis-svc
  namespace: project-dev
  labels:
    app: redis
spec:
  ports:
  - name: redis-port
    port: 6379
  clusterIP: None
  selector:
    app: redis
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis
  namespace: project-dev
spec:
  selector:
    matchLabels:
      app: redis
  serviceName: "redis-svc"
  replicas: 6
  template:
    metadata:
      labels:
        app: redis
    spec:
      terminationGracePeriodSeconds: 20
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: app
                  operator: In
                  values:
                  - redis
              topologyKey: kubernetes.io/hostname
      tolerations:
      - key: "project"
        operator: "Equal"
        value: "project"
        effect: "NoSchedule"
      nodeSelector:
        project: "project"
      containers:
 #     - name: redis-exporter
 #       image: harbor.i.garys.top/middleware/redis_exporter:v6.0
 #       resources:
 #         requests:
 #           memory: 10Mi
 #           cpu: 20m
 #         limits:
 #           memory: 20Mi
 #           cpu: 50m
 #       ports:
 #       - containerPort: 9121
 #         name: exporter
 #       command:
 #       - "/app/redis_exporter"
 #       args:
 #       - "-redis.password"
 #       - "Redis@123456"
 #       livenessProbe:
 #         httpGet:
 #           path: "/metrics"
 #           port: 9121
 #         initialDelaySeconds: 10
 #         timeoutSeconds: 5
      - name: redis
        image: harbor.i.garys.top/middleware/redis:4.0.11
        command:
          - "redis-server"
        args:
          - "/etc/redis.conf"
          - "--protected-mode"
          - "no"
          - "--cluster-announce-ip"
          - "$(POD_IP)"
#        resources:
#          requests:
#            cpu: "1"
#            memory: "1G"
        env:
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        ports:
            - name: redis
              containerPort: 6379
              protocol: "TCP"
            - name: cluster
              containerPort: 16379
              protocol: "TCP"
        volumeMounts:
          - name: "redis-data"
            mountPath: "/data"
  volumeClaimTemplates:
  - metadata:
      name: redis-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "project-ceph-rbd"
      resources:
        requests:
          storage: 10Gi
```

### 构建redis集群
- 下载容器
kubectl run -it tool --image=docker.garys.top/zhouxian/tool:v1 /bin/bash
- 构建集群
cd /opt
./redis-trib.rb create  --replicas 1 ip1:port  ip2:port  ip3:port ip4:port ip5:port ip6:port 