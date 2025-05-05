---
created_date: 2020-11-16
---

[TOC]

# Helm v1.2

- 构成
  Helm Chart Repository
  Helm Client
  Helm Server(Tiller)
  Kubernete API Server

# Helm v1.3

- https://github.com/helm/helm

- 定义： Kubernetes 的包管理器
  管理k8s应用的yaml资源文件
  管理k8s应用的yaml资源文件间的依赖关系

## 构成

Helm Chart Repository
Helm Client
Kubernete API Server

## 使用

0. 下载
   https://github.com/helm/helm/releases

## 指令

#### 远程Chart仓库相关命令

1. 添加一个远程仓库
   helm repo add ${REPO_NAME} ${REPO_URL}
   例：helm repo add iad https://chartrepo.i.garys.top
2. 列出当前已有的远程仓库
   helm repo list
3. 刷新远程仓库中的Chart
   helm repo update
4. 移除远程仓库
   helm repo remove iad
5. 搜索远程仓库中的Chart
   helm search repo ${REPO_NAME}
   例：helm search repo iad
6. 根据关键字搜索远程仓库中的Chart
   helm search repo ${REPO_NAME}/${KEYWORD}
   例：helm search repo iad/rhine2

#### 查看Chart信息相关命令（通常在部署Chart前时使用）

1. 查看Chart的Chart.yaml文件信息
   helm show chart ${REPO_NAME}/${CHART_NAME}
   例：helm show chart iad/rhine2asset
2. 查看Chart有哪些变量可以被配置
   helm show values ${REPO}/${CHART}
   例：helm show values iad/rhine2asset
3. 查看Chart的README文件
   helm show readme ${REPO}/${CHART}
   例：helm show readme iad/rhine2asset

#### 部署Chart相关命令

1. 部署一个应用，使用默认参数值
   helm install -n ${RELEASE_NAME} ${CHART_NAME}
2. 部署一个应用，使用自定义参数值，并添加描述
   helm install -n ${RELEASE_NAME} ${CHART_NAME} --set key=val --description “str”
3. 原子部署一个应用，在指定的时间内未成功部署则自动回滚
   helm install -n ${RELEASE_NAME} ${CHART_NAME} --set key=val --atomic --wait --timout 10s --description “str”
4. 升级一个应用，除了新设置的参数值外，其余参数值复用上一个Release的，若在指定时间内未成功升级，则自动回滚
   helm upgrade -n ${NAMESPACE} ${RELEASE_NAME} ${CHART_NAME} --set key=val --reuse-values --atomic --wait --timout 10s --description “str”
5. 回滚Release至指定版本
   helm rollback -n ${NAMESPACE} ${RELEASE_NAME} ${REVISION_NUM}
6. 卸载Release
   helm uninstall -n ${NAMESPACE} ${RELEASE_NAME}

--dry-run 只渲染不部署
--debug

#### 查看Release信息相关命令（通常在部署Chart后运行时使用）

1. 查看Release启动时，被设置的参数值
   helm get values -n ${NAMESPACE} ${RELEASE_NAME}
   例：helm get values –n rhine2-helm rhine2
2. 查看Release所有参数值
   helm get values -n ${NAMESPACE} ${RELEASE_NAME} --all
   例：helm get values –n rhine2-helm rhine2 --all
