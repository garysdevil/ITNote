---
created_date: 2020-12-23
---

[TOC]

## update

- 滚动升级，

1. update：改变镜像tag：
   kubectl set image deployment/名字 容器名字=镜像 --record
   kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --record

2. update：通过edit配置文件改变镜像tag：
   kubectl edit deployment/pod 名字

3. 查看pod迭代状况
   kubectl rollout status deployment deployment名字
   --watch=false 非持续查看

4. 查看特定版本的详细信息：
   kubectl rollout history deployment
   kubectl rollout history deployment 名字 --revision=版本

5. 回滚到上一个版本：
   kubectl rollout undo deployment 名字
   回滚到特定的版本 --to-revision=版本号

6. 回滚到指定版本
   kubectl rollout undo deployment 名字 --to-revision=1

## yaml参数

- maxSurge：指定升级期间存在的总Pod对象数量最多可超出期望值的个数，其值可以是0或正整数，也可以是一个期望值的百分比；如，如果期望值为3，当前的属性值为1，则表示Pod对象的总数不能超过4个。

- maxUnavailable：升级期间不可用的Pod副本数（包括新旧版本）最多不能低于期望数值的个数，其值可以是0或正整数，也可以是一个期望值的百分比；默认值为1，该值意味着如果期望值是3，则升级期间至少要有两个Pod对象处于正常提供服务的状态。

- maxSurge 和 maxUnavailable 属性的值不可同时为 0 ，否 则 Pod 对象的副本数量在符合用户期望的数量后无法做出合理变动以进 行滚动更新操作。

- 金丝雀发布

```bash
deployment=busybox-deploy-kujiu

# 
kubectl patch deployments ${deployment} -p '{"spec":{"minReadySeconds":5}}' # 默认值为0
kubectl patch deployments ${deployment} -p '{"spec":{"maxReadySeconds":3600}}'

# 升级
kubectl set image deployments ${deployment} busybox-deploy=busybox:1.32-musl
# 暂停升级
kubectl rollout pause deployments ${deployment}
# 查看pod迭代状况
kubectl rollout status deployment  ${deployment}
# 继续升级
kubectl rollout resume deployments ${deployment}

# 历史升级记录查看
kubectl rollout history deployments ${deployment}
# 回滚
kubectl rollout undo deployments ${deployment}


```
