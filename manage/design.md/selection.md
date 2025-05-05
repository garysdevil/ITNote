---
created_date: 2021-07-12
---

[TOC]

# 选型

## 监控

### zabbix

1. 配置与规模
   - 8c 32G
   - 150台服务器，每台服务器平均100个监控，每个监控项平均1分钟收集数频率

#### 提高性能

1. 数据库读写分离
   - 通过mysql-proxy（lua实现的脚本）
     - mysql-proxy是mysql官方提供的mysql中间件服务
     - https://downloads.mysql.com/archives/proxy/
   - 更改源代码
2. 添加 zabbix-proxy

### prometheus

## 日志收集

### ES & Kibana

1. 35G每日

   - 两个节点的集群
   - 8c 16G ES
   - 8c 32G ES & Kibana
   - index设置为一个分片一个副本
   - 每天数据收集量为15G ～ 35G

2. 1200G每日

   - 20个节点的集群

   - 5c 8G ES client node ；memory 日常消耗7G ； cpu 日常消耗200m到500m

   - 14c 24G ES data node ；memory 日常消耗16G ； cpu 日常消耗200m到2000m，有时会突增到7C。

   -

   - index设置为一个分片一个副本

   - 每天数据收集量为1200G左右 ；200G左右
