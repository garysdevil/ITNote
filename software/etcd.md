---
created_date: 2020-11-16
---

[TOC]

# etcd

- 参考文档
  https://alexstocks.github.io/html/etcd.html

- 提供一致性服务的分布式系统
  1\. kv键值存储

- etcd 底层的 boltdb 采用 B+ 树形式存储 kv 的 MVCC 数据，每次修改的数据只存储增量版本，所以创建snapshot 的成本挺高的。
  kv 中的 key 是一个三元组 (major, sub, type)，Major 存储了 key 的 revision，Sub 则存储了同样 revision 下的差异，type 则是一个后缀，用于指明一些特殊value 的类型，如果当前 value 中有 tombstone 则 type 为 t。

## API

1. 查看版本
   curl http://127.0.0.1:2379/version

2. 查看监控数据metrics

## 指令

### 访问结构

```bash
IP=127.0.0.1
ETCDCTL_API=3 //opt/kube/bin/etcdctl \
      --endpoints=https://${IP}:2379  \
      --cacert=/etc/kubernetes/ssl/ca.pem \
      --cert=/etc/etcd/ssl/etcd.pem \
      --key=/etc/etcd/ssl/etcd-key.pem \
      具体指令
# 例如查看etcd节点健康状状态
ETCDCTL_API=3 //opt/kube/bin/etcdctl \
      --endpoints=https://${IP}:2379  \
      --cacert=/etc/kubernetes/ssl/ca.pem \
      --cert=/etc/etcd/ssl/etcd.pem \
      --key=/etc/etcd/ssl/etcd-key.pem \
      endpoint health
```

2. 查看所有key
   etcdctl --endpoints="https://${IP}:2379" --prefix --keys-only=true get /
   关键参数
   --keys-only=true 仅仅查看key
   --prefix 查看拥有某个前缀的key

3. 监听key
   etcdctl watch /test/ok

4. 设置键值

etcdctl --endpoints="https://${IP}:2379" set /test1/test2 "Hello world"
