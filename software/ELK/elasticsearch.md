## 概览
- 参考
https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html 官方文档
https://www.cnblogs.com/wyq178/p/11968529.html  ElasticSearch的API使用

## 安装
- 参考
https://www.elastic.co/cn/downloads/past-releases#elasticsearch
0. 需要java1.8环境
1. wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.0-linux-x86_64.tar.gz

2. 配置文件
vi config/elasticsearch.yml
```conf
cluster.initial_master_nodes: ["node-1"]  # 启动单节点集群，单节点必须配置
network.host: 0.0.0.0 # 默认只有本机才能访问 
cluster.max_shards_per_node: 3000 # 配置每个节点最大的分片数量，默认为1000
```
3. 启动 nohup ./bin/elasticsearch 2>&1 &
4. 访问 http://localhost:9200/

### 系统参数要求
1. ulimit
2. sysctl -w vm.max_map_count=655360

## 机制
### 术语
1. Index 类似于数据库的概念。索引的名字只能是小写,不能是大写。
2. Type 是Index里分组的概念。 在7.4.2版本中已经去除了Index里type的概念。6.0的版本不允许一个Index下面有多个Type。
3. Mapping 类似于mysql中表结构, properties类似于mysql表中的字段概念。 es的mapping创建之后无法修改,如果需要修改则需要重新建立index,然后reindex迁移数据。
### Shard
1. 分片是 Elasticsearch 在集群中分发数据的关键.
2. 分片是装载数据的容器。文档存储在分片中，然后分片分配到集群中的节点上。当集群扩容或缩小，Elasticsearch 将会自动在节点间迁移分片，以使集群保持平衡。
3. 一个分片是一个最小级别“工作单元(worker unit)”，它只是保存了索引中所有数据的一部分。
4. 分片类似于 MySql 的分库分表，只不过 Mysql 分库分表需要借助第三方组件而 ES 内部自身实现了此功能。
5. 分片可以是主分片(primary shard)或者是复制分片(replica shard)。
6. Version 7+ 默认创建1000个分片。
### 索引与分片和副本
1. number_of_shards  
每个索引的主分片数，默认值是 5 。这个配置在索引创建后不能修改。

2. number_of_replicas  
每个主分片的副本数，默认值是 1 。对于活动的索引库，这个配置可以随时修改。

3. 设置
number_of_shards 和 number_of_replicas 都是index级别的设置。
如果打算每个新建的index都设置副本数为0，可以通过index template 来设置。
### 
1. 缓存机制:
将index-buffer中文档（document）解析完成的segment写到filesystem cache之中
从index-buffer中取数据到filesystem cache中的过程叫做refresh

## API

- 在HTTP的method中
1. PUT  代表具有幂等性操作(多次执行都能得到同样的结果)。
2. POST 是非幂等，在资源创建时候，执行多次会产生不同的结果。
3. 在ES中，PUT具有幂等性，使用PUT需要在当前操作索引下指定一个文档ID， 当文档ID不存在时，会进行创建一个文档，如果存在的话，则进行更新。

### 集群管理
```bash
# 查看集群状况
curl ${IP}:${PORT}/?pretty

# 节点健康状况
curl "http://${IP}:${PORT}/_cat/health?v"

# 临时改变集群分片的数量    
curl -XPUT -H "Content-Type: application/json" -d '{"transient":{"cluster":{"max_shards_per_node":10000}}}' "http://${IP}:${PORT}/_cluster/settings"

curl "http://${IP}:${PORT}/_nodes/{node}/hot_threads"

```
### 常规操作
```bash
# 查看当前节点的所有 Index
curl -X GET "http://${IP}:${PORT}/_cat/indices?v"

# 列出每个 Index 所包含的 Type
curl "${IP}:${PORT}/_mapping?pretty=true"

# 创建索引
curl -X PUT "${IP}:${PORT}/test1-index"

# 查看索引
curl "${IP}:${PORT}/test1-index?pretty=true"

# 删除索引
curl -X DELETE "${IP}:${PORT}/test1-index"

## 同时创建index和mapping
curl  -H "Content-Type: application/json"  -X PUT "http://${IP}:${PORT}/test1-index" -d'
{
    "mappings" : {
        "properties" : {
            "field1" : { "type" : "text" }
        }
    }
}'

## 自动创建索引,mapping和插入数据
curl  -H "Content-Type: application/json"  -X POST "http://${IP}:${PORT}/test2-index/_doc/" -d'
{
  "@timestamp": "2099-11-15T13:12:00",
  "message": "GET /search HTTP/1.1 200 1070000",
  "user": {
    "name": "kimchy1"
  }
}'


# 计算集群内document的数量
curl -XGET "http://${IP}:${PORT}/_count?pretty" 
# 计算集index下document的数量
curl -XGET "http://${IP}:${PORT}/${index}/_count?pretty" 

```

```bash
# 查看索引下的document
# /Index/Type/_search
# /Index/_search
curl "${IP}:${PORT}/test2-index/_search?pretty" -d'
{
    "size": 10,
    "query": {
        "match_all": {}
    }
}
'

curl "${IP}:${PORT}/test2-index/_search?pretty" -d'
{
    "size": 10,
    "query": {
        "match": {}
    }
}
'

# size 显示多少条数据
```
查询status字段为400到499的document数量
```json
{
    "size": 0,
    "query": {
        "bool": {
            "must": [
                {
                    "query_string": {
                        "query": "status: [400 TO 499] AND host:\"garys.top\"",
                        "fields": [],
                        "type": "best_fields",
                        "default_operator": "or",
                        "max_determinized_states": 10000,
                        "enable_position_increments": true,
                        "fuzziness": "AUTO",
                        "fuzzy_prefix_length": 0,
                        "fuzzy_max_expansions": 50,
                        "phrase_slop": 0,
                        "analyze_wildcard": true,
                        "escape": false,
                        "auto_generate_synonyms_phrase_query": true,
                        "fuzzy_transpositions": true,
                        "boost": 1
                    }
                },
                {
                    "range": {
                        "@timestamp": {
                            "from": "now-100m",
                            "to": "now",
                            "include_lower": true,
                            "include_upper": true,
                            "format": "epoch_millis",
                            "boost": 1
                        }
                    }
                }
            ],
            "adjust_pure_negative": true,
            "boost": 1
        }
    }
}
```