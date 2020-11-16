## update
- 滚动升级，
1. update：改变镜像tag：
  kubectl set image deployment/名字 容器名字=镜像 --record
  kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --record
  
2. update：通过edit配置文件改变镜像tag：
  kubectl edit deployment/pod 名字

3. 查看升级状态
kubectl rollout status deployment.v1.apps/名字

3. 查看特定版本的详细信息：
  kubectl rollout history deployment
  kubectl rollout history deployment 名字 --revision=版本

4. 回滚到上一个版本：
  kubectl rollout undo deployment 名字
  回滚到特定的版本 --to-revision=版本号

5. 回滚到指定版本
kubectl rollout undo deployment 名字 --to-revision=1

## scale
- 文档参考
https://kubernetes.io/zh/docs/tasks/run-application/horizontal-pod-autoscale/
https://idig8.com/2019/08/21/zoujink8skubernetes1-15-1depod-zidongkuosuorong23/

-   版本说明
    1. 从 Kubernetes 1.8 开始，资源使用指标（如容器 CPU 和内存使用率）通过 Metrics API 在 Kubernetes 中获取, metrics-server 替代了heapster
    2.  Heapster：仅支持CPU使用率
    3. autoscaling/v1 支持基于CPU指标的缩放
    4. autoscaling/v2beta2 引入了基于内存和自定义指标的缩放 
    5. k8s 1.6版本之后才有 autoscaling/v2beta2

### 手动
1. 手动扩容
kubectl scale --replicas=5 deployment nginx-deploy
kubectl scale --replicas=1 deployment garysweb -n project-stg1
kubectl scale --replicas=1 deployment garyswebcms -n project-stg1
2. 手动升级
kubectl set image deployment nginx-deploy nginx-deploy=nginx:1.15-alpine --record

### 自动
1. 若要实现自动扩缩容的功能，则需要部署heapster服务，用来收集及统计资源的利用率
2. 通过命令行
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