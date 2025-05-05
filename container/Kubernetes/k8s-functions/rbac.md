---
created_date: 2020-11-16
---

[TOC]

### 概念
### 1 从role到deployment
1. 角色
Role
ClusterRole
2. 用户(Subject)
Service Account
User Account
Group
3. 绑定角色与用户
RoleBinding
ClusterRoleBinding
4. 使用Service Account创建Pod
    spec:
      serviceAccountName: prometheus
      serviceAccount: prometheus
### 2
1. resources:
  1. Pods
  2. ConfigMaps
  3. Deployments
  4. Nodes
  5. Secrets
  6. Namespaces
2. verbs:
  create
  get
  delete
  list
  update
  edit
  watch
  exec
3. apiGroup:  资源和 API Group 进行关联,比如Pods属于 Core API Group，而Deployements属于 apps API Group
  "" 
  apps
  autoscaling
  batch

### dashboard权限控制
- 控制用户只能查看某些命名空间内的资源
1. ServiceAccount
    - serviceaccout创建时Kubernetes会默认创建对应的secret
    kubectl create sa xieshigang
2. Role  
    - Role 是单个namespace范围的权限。
    - ClusterRole 是集群范围的授权
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: project-secure-reader
  namespace: project-secure
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - get
  - watch
  - list
- apiGroups:
  - '*'
  resources:
  - pods/exec
  verbs:
  - create
```
3. RoleBinding
    - RoleBinding可以将角色中定义的权限授予用户或用户组，适用于某个命名空间内授权
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: demo-reader-xieshigang
  namespace: project-secure
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: project-secure-reader
subjects:
- kind: ServiceAccount
  name: xieshigang
  namespace: default
```

4. 获取登陆dashboard的密钥
kubectl describe secret xieshigang-token-k22rn

