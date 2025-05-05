---
created_date: 2021-03-26
---

[TOC]

- 创建的任何资源名字往往都是不可再次修改的

## 术语

Google Cloud Platfomr（GCP）
Google Kubernetes Engine (GKE) https://cloud.google.com/kubernetes-engine/docs
Google Compute Engine (GCE) https://cloud.google.com/compute
网络端点组 network endpoint group (NEG) https://cloud.google.com/load-balancing/docs/negs
外部负载均衡 External HTTP(S) Load Balancing https://cloud.google.com/load-balancing/docs/https
Cloud CDN https://cloud.google.com/cdn/docs/caching?\_ga=2.196277356.-1333077488.1603936828

## gcloud CLI

- 参考文档
  https://cloud.google.com/sdk/gcloud?hl=zh-cn
- 需要安装Google Cloud SDK，然后才能使用gcloud CLI

### 通过gcloud创建 转发规则

1. 至多配置 100 条专用转发规则 来指向每个网络的目标实例

```bash
# 获取预留的 IP 地址
gcloud compute addresses list 
# 指定实例，创建目标实例。当指定的实例不存在于这个zone内时，并不会有错误提示。
gcloud compute target-instances create kujiu-target-instance2 --instance kujiu-test2 --zone us-east4-c 
gcloud compute target-instances list
gcloud compute target-instances delete kujiu-target-instance2  --zone us-east4-c
# --zone 指定空间

# 指定目标实例，交互式选择区域，创建转发规则对象，生成临时外部地址，也可以指定静态外部地址
gcloud compute forwarding-rules create kujiu-test-rule3 --ip-protocol TCP --ports 80 --target-instance kujiu-target-instance2  --target-instance-zone us-east4-c --region us-east4
# --region 指定地区
# --target-instance-zone 指定目标实例所在的空间

# 获取转发规则分配的IP地址
gcloud compute forwarding-rules list 


# --quiet = -q 删除时静默
```

## 网络服务：CDN 和 LB 和 后端服务

1. CDN 和 LB 是一对一关系的。
2. LB 将流量分发到 后端服务 或者 后端存储分区上
   1. 负载平衡器的后端服务
      - 实例组 - （类似于k8s的Deployment，用于管理多个实例）
      - 网络端点组
        1. 地区级网络端点组（GCE和GKE后端）
        2. 互联网网络端点组（自定义来源）！！
        3. 无服务网络端点组（App Engine、Cloud RUN、Cloud Functions）
   2. 负载平衡器的后端存储分区
      - Cloud Storage

- Computer Engine：网络端点组 network endpoint group (NEG)
  1. 互联网端点组（地区级） -- 只能连接GoogleCloud内部的服务
  2. 互联网端点组（互联网级）-- 可以连接互联网上的服务 ！！

### CDN 缓存策略

- https://cloud.google.com/cdn/docs/caching?\_ga=2.196277356.-1333077488.1603936828

1. CACHE_ALL_STATIC，存静态内容。
2. USE_ORIGIN_HEADERS，使用基于 Cache-Control 标头的源站设置。源站必须设置标头才会缓存。如果想绝不缓存，最好再在nginx下进行如下配置。

```conf
http {
    add_header Cache-Control 'no-store';
}
```

3. FORCE_CACHE_ALL，强制缓存所有内容。缓存由源站传送的所有内容，忽略任何“private”、“no-store”或“no-cache”指令。

- 已经被缓存的键依然可能被旧的规则影响，解决措施为清空所有的CDN缓存键。

- 缓存键配置：不能通过配置缓存键元素来决定是否缓存相关内容，只能通过其来决定是否使用CDN里的缓存内容。

- CDN缓存成功的标志, 查看Response, Age返回头将会随时间而增长

  ```conf
  Age: 10
  ```

- 答复

  1. 是否可以绝不缓存？ 可以。 CDN设置为 USE_ORIGIN_HEADERS 缓存策略，添加 负载均衡器的返回标头 Cache-Control no-store。
  2. header /cookie是否可以传到后端去？ 可以。
  3. URL参数是否可以作为缓存键？ 可以, 通过设置CDN的缓存键。
