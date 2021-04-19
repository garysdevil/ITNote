### 健康检查Prob探针
- 两种类型：livenessProbe , readinessProbe
- 三种检查方式： httpGet ， exec ， tcpSocket

- liveness主要用来确定何时重启容器
- readiness主要来确定容器是否已经就绪
    initialDelaySeconds：容器启动后第一次执行探测是需要等待多少秒。
    periodSeconds：执行探测的频率。默认是10秒，最小1秒。
    timeoutSeconds：探测超时时间。默认1秒，最小1秒。
    successThreshold：探测失败后，最少连续探测成功多少次才被认定为成功。默认是1。对于liveness必须是1。最小值是1。
    failureThreshold：探测成功后，最少连续探测失败多少次才被认定为失败。默认是3。最小值是1。

1. http探针
```yaml
      containers:
      .....
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          failureThreshold: 11
          successThreshold: 1
          timeoutSeconds: 10
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
            scheme: HTTP
          initialDelaySeconds: 120
          periodSeconds: 10
          failureThreshold: 6
          successThreshold: 1
          timeoutSeconds: 10
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: goproxy
  labels:
    app: goproxy
spec:
  containers:
  - name: goproxy
    image: k8s.gcr.io/goproxy:0.1
    ports:
    - containerPort: 8080
    readinessProbe:
      tcpSocket:
        port: 8080
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      tcpSocket:
        port: 8080
      initialDelaySeconds: 15
      periodSeconds: 20
```