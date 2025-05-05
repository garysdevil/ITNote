---
created_date: 2020-11-16
---

[TOC]

# CRD
https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/
CustomResourceDefinition(自定义资源)
1. 创建CRD
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  # 名称必须与下面的spec字段匹配，格式为: <plural>.<group>
  name: crontabs.stable.example.com
spec:
  # 用于REST API的组名称: /apis/<group>/<version>   # 资源对象的apiVersion需要使用到
  group: stable.example.com
  # 此CustomResourceDefinition支持的版本列表
  versions:
    - name: v1
      # 每个版本都可以通过服务标志启用/禁用。
      served: true
      # 必须将一个且只有一个版本标记为存储版本。
      storage: true
  # 指定crd资源作用范围在命名空间或集群Namespaced/Cluster
  scope: Namespaced
  names:
    # URL中使用的复数名称: /apis/<group>/<version>/<plural>
    plural: crontabs
    # 在CLI(shell界面输入的参数)上用作别名并用于显示的单数名称
    singular: crontab
    # kind字段使用驼峰命名规则  # 资源对象的Kind需要使用到
    kind: CronTab    
    # 短名称允许短字符串匹配CLI上的资源，意识就是能通过kubectl 在查看资源的时候使用该资源的简名称来获取。
    shortNames:
    - ct
```
2. 根据CRD对象资源创建出来的RESTful API，来创建testcrd类型资源对象
```yaml
apiVersion: "stable.example.com/v1"
kind: CronTab
metadata:
  name: my-new-cron-object
spec:
  cronSpec: "* * * * */5"
  image: my-awesome-cron-image
```

3. 为自定义资源添加验证
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
  version: v1
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
    shortNames:
    - ct
  validation:
   # openAPIV3Schema is the schema for validating custom objects.
    openAPIV3Schema:
      properties:
        spec:
          properties:
            cronSpec: # 设置为 必须是字符串，并且必须是正则表达式所描述的形式
              type: string
              pattern: '^(\d+|\*)(/\d+)?(\s+(\d+|\*)(/\d+)?){4}$'
            replicas: # 设置为 必须是整数，最小值必须为1，最大值必须为10
              type: integer
              minimum: 1
              maximum: 10
```

4. 为自定义资源添加额外的打印列
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
  version: v1
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
    shortNames:
    - ct
  additionalPrinterColumns:
  - name: Spec
    type: string
    description: The cron spec defining the interval a CronJob is run
    JSONPath: .spec.cronSpec
  - name: Replicas
    type: integer
    description: The number of jobs launched by the CronJob
    JSONPath: .spec.replicas
  - name: Age
      type: date
      JSONPath: .metadata.creationTimestamp
```

5. 为自定义的资源添加状态和伸缩配置
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
    shortNames:
    - ct
  # 自定义资源的子资源的描述
  subresources:
    # 启用状态子资源。
    status: {}
    # 启用scale子资源
    scale:
      specReplicasPath: .spec.replicas
      statusReplicasPath: .status.replicas
      labelSelectorPath: .status.labelSelector
```
扩充自定义资源对象副本数目
kubectl scale --replicas=5 crontabs/my-new-cron-object
测试失败 kubectl v1.15 https://github.com/openkruise/kruise/issues/278

6. categories字段指定自定义资源所属的组
```yaml
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: crontabs.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
  scope: Namespaced
  names:
    plural: crontabs
    singular: crontab
    kind: CronTab
    shortNames:
    - ct
    # categories字段指定自定义资源所属的组
    categories:
    - all
```
kubectl get all