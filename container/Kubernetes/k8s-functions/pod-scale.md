## scale HPA
- 文档参考
  - https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
  - https://idig8.com/2019/08/21/zoujink8skubernetes1-15-1depod-zidongkuosuorong23/


- 版本说明
  1. 从 Kubernetes 1.8 开始，资源使用指标（如容器 CPU 和内存使用率）通过 Metrics API 在 Kubernetes 中获取, metrics-server(收集及统计资源的利用率) 替代了heapster
  2. Heapster：仅支持CPU使用率
  3. autoscaling/v1 支持基于CPU指标的缩放
  4. autoscaling/v2beta2 引入了基于内存和自定义指标的缩放 
  5. k8s 1.6版本之后才有 autoscaling/v2beta2

### 手动
1. 手动扩容
kubectl scale --replicas=5 deployment nginx-deploy
kubectl scale --replicas=1 deployment garysweb -n project-stg1

### 自动
0. 机制
Pod 水平自动扩缩器的实现是一个控制回路，由控制器管理器的 --horizontal-pod-autoscaler-sync-period 参数指定周期（默认值为 15 秒）

1. 通过命令行
kubectl autoscale deployment foo --min=2 --max=10

3. 基于k8s 1.5版本
```yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: project-auto-hahsmeaccount
  namespace: project-perform
spec:
  scaleTargetRef:   # 指定要伸缩的目标资源
    apiVersion: apps/v1
    kind: Deployment
    name: garysaccount
  minReplicas: 2
  maxReplicas: 3
  metrics:
  #- type: Resource
  #  resource:
  #    name: cpu
  #    targetAverageValue: 2Gi
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 80
```

## scale VPA
Vertical Pod AutoScaling