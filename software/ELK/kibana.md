## 概览
- 文档
    - https://www.elastic.co/guide/cn/kibana/current/index.html 官网中文文档-用户手册
    - https://www.elastic.co/cn/webinars/getting-started-kibana?baymax=default&elektra=docs&storm=top-video 官网学习视频

## 安装
- 参考
    - https://www.elastic.co/cn/downloads/past-releases

- 需要和elasticsearch版本对应

### 裸安装
- 安装
```bash
# 1. 
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.9.3-linux-x86_64.tar.gz
# 2. 
nohup ./bin/kibana > kibana.log 2>&1 &
# 3. 默认端口 5601
```

- 健康状态查看
```bash
curl 127.0.0.1:5601/api/status
# 127.0.0.1:5601/status
```
### 配置
```conf
server.host: "0.0.0.0" # 默认为localhost
elasticsearch.hosts: ["http://localhost:9200"] # 默认为localhost
```
## 告警插件
- 参考
    - https://github.com/opendistro-for-elasticsearch/alerting
    - https://opendistro.github.io/for-elasticsearch-docs/docs/alerting/

- Alerting
    - 一款开源的kibana告警插件
    - 官方的kibana告警插件是收费的

```Dockerfile
FROM docker.elastic.co/kibana/kibana:7.6.1

RUN /opt/kibana/bin/kibana-plugin install https://github.com/opendistro-for-elasticsearch/alerting-kibana-plugin/releases/download/v1.12.0.2/opendistro_alerting_kibana.zip
```

## 使用
### 查询语法
- 可以实现三种搜索
    1. DSL 搜索
    2. KQL 搜索
    3. Lucene 搜索
    - 在这三种搜索方法中，DSL 以及 Lucene 搜索可以支持模糊查询 （fuzziness) 以及 通配符查询 （Regex)。KQL 是 Search Bar 的默认搜索方式，但是它不支持模糊查询。

#### KQL
1. 按字段搜索
    -  字段: 值 AND 字段: 值
    - source: \/data\/logs\/project-a\/*  AND message: user.login.ERROR

2. 字段本身是否存在
    - 返回结果中需要有http字段
        - _exists_:http 
    - 不能含有http字段
        - _missing_:http

3. 分组查询
    - (message: user.login.ERROR OR apache) AND source: \/data\/logs\/project-a\/* 

4. 按数值搜索
    - nginx.access.request_time:>3