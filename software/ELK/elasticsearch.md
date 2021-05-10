## 概览
- 参考
    - https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html 官方文档
    - https://www.cnblogs.com/wyq178/p/11968529.html  ElasticSearch的API使用
    - https://www.cnblogs.com/kevingrace/p/10671063.html 常见错误

## 安装
- 参考
    - https://www.elastic.co/cn/downloads/past-releases#elasticsearch

1. 安装java1.8环境
2. wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.0-linux-x86_64.tar.gz
3. 配置文件
    - vi config/elasticsearch.yml
    ```conf
    cluster.initial_master_nodes: ["node-1"]  # 启动单节点集群，单节点必须配置
    network.host: 0.0.0.0 # 默认只有本机才能访问 
    cluster.max_shards_per_node: 3000 # 配置每个节点最大的分片数量，默认为1000
    ```
4. 启动 nohup ./bin/elasticsearch 2>&1 &
5. 访问 http://localhost:9200/

### 系统参数要求
1. ulimit
2. vm.max_map_count
```bash
# 永久设置
# echo 'vm.max_map_count=655360' >> /etc/sysctl.conf
# sysctl -p

# 临时设置
sysctl -w vm.max_map_count=655360
# 查看
sysctl -a|grep vm.max_map_count
```


## 机制
### 术语
1. Index 类似于数据库的概念。索引的名字只能是小写,不能是大写。
2. Type 是Index里分组的概念。 在7.4.2版本中已经去除了Index里type的概念。6.0的版本不允许一个Index下面有多个Type。
3. Mapping 类似于mysql中表结构, properties类似于mysql表中的字段概念。 es的mapping创建之后无法修改,如果需要修改则需要重新建立index,然后reindex迁移数据。
### Shard
- 分片
    1. 分片是 Elasticsearch 在集群中分发数据的关键.
    2. 分片是装载数据的容器。文档存储在分片中，然后分片分配到集群中的节点上。当集群扩容或缩小，Elasticsearch 将会自动在节点间迁移分片，以使集群保持平衡。
    3. 一个分片是一个最小级别“工作单元(worker unit)”，它只是保存了索引中所有数据的一部分。
    4. 分片类似于 MySql 的分库分表，只不过 Mysql 分库分表需要借助第三方组件而 ES 内部自身实现了此功能。
    5. 分片可以是主分片(primary shard)或者是副本分片(replica shard)。
    6. Version 7+ 默认创建1000个分片。
- 分片的配置
    - 参考 
        - https://www.elastic.co/cn/blog/how-many-shards-should-i-have-in-my-elasticsearch-cluster
    - 分片过小会导致段过小，进而致使开销增加。尽量将分片的平均大小控制在至少几 GB 到几十 GB 之间。对时序型数据用例而言，分片大小通常介于 20GB 至 40GB 之间。


### 索引与分片和副本
1. number_of_shards  
每个索引的主分片数，默认值是 5 。这个配置在索引创建后不能修改。

2. number_of_replicas  
每个主分片的副本数，默认值是 1 。对于活动的索引库，这个配置可以随时修改。

3. 设置
number_of_shards 和 number_of_replicas 都是index级别的设置。
如果打算每个新建的index都设置副本数为0，可以通过index template 来设置。
### ES写入数据时的步骤
1. 数据写入到buffer中。

2. 每隔一段时间 (可以在settings中通过refresh_interval手动设置值)刷新buffer，将数据组装并保存到index segment file(可以看作是一份File，只不过目前存储在内存中)

3. index segment file在被创建后，会被立刻读取并写入到OS Cache中(此时数据就可以对客户端提供搜索服务了)。

4. 默认每隔30分钟或translog过大时，ES会将当前内存中所有的index segment标记并形成一个commit point（类似git 的commit id），进行原子性的持久化操作，操作完毕后，删除本次已经已经了持久化的index segment，腾出内存空间。

## API

- 在HTTP的method中
1. PUT  代表具有幂等性操作(多次执行都能得到同样的结果)。
2. POST 是非幂等，在资源创建时候，执行多次会产生不同的结果。
3. 在ES中，PUT具有幂等性，使用PUT需要在当前操作索引下指定一个文档ID， 当文档ID不存在时，会进行创建一个文档，如果存在的话，则进行更新。

### 集群管理
```bash
IP=127.0.0.1
PORT=9200

# 查看集群状况
curl ${IP}:${PORT}/?pretty

# 查看集群健康状况
curl http://${IP}:${PORT}/_cat/health?v
curl http://${IP}:${PORT}/_cluster/health?pretty

# 查看节点健康状况
curl http://${IP}:${PORT}/_cat/nodes?v

# 查看集群分片状态
curl http://${IP}:${PORT}/_cat/shards/?pretty

# 查看 熔断器 内存数据
curl http://${IP}:${PORT}/_nodes/stats/breaker?pretty

# 临时改变集群分片的数量    
curl -XPUT -H "Content-Type: application/json" -d '{"transient":{"cluster":{"max_shards_per_node":10000}}}' "http://${IP}:${PORT}/_cluster/settings"

curl "http://${IP}:${PORT}/_nodes/{node}/hot_threads"

# 查看大索引
curl -s /dev/null -XGET http://127.0.0.1:9200/_cat/indices?v|grep gb
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

## 常见错误
1. message字段太大，超出了字符偏移量上限
    - 报错 
    ```log
    The length of [message] field of [pAuVMXYBWMKQqimE8lSp] doc of [filebeat-7.6.0-2020.12.05] index has exceeded [1000000] - maximum allowed to be analyzed for highlighting. This maximum can be set by changing the [index.highlight.max_analyzed_offset] index level setting. For large texts, indexing with offsets or term vectors is recommended!"
    type: "illegal_argument_exception

    ```
    - 在kibana的Dev Tool内修改
    ```
    PUT /索引名*/_settings
    {
        "index" : {
            "highlight.max_analyzed_offset" : 2000000
        }
    }
    ```
    - 通过elasticsearch的API进行修改
    ```bash
    curl -XPUT "127.0.0.1:9200/索引名*/_settings" -H 'Content-Type: application/json' -d '{
        "index" : {
            "highlight.max_analyzed_offset" : 2000000
        }
    }'
    ```
2. 分配给ES的堆内存不够用了
    - 报错
    ```log
    curl http://${IP}:${PORT}/_cat/shards/?pretty
    {
    "error" : {
        "root_cause" : [
        {
            "type" : "circuit_breaking_exception",
            "reason" : "[parent] Data too large, data for [<http_request>] would be [4080692272/3.8gb], which is larger than the limit of [4080218931/3.7gb], real usage: [4080692272/3.8gb], new bytes reserved: [0/0b], usages [request=0/0b, fielddata=0/0b, in_flight_requests=0/0b, accounting=82023656/78.2mb]",
            "bytes_wanted" : 4080692272,
            "bytes_limit" : 4080218931,
            "durability" : "PERMANENT"
        }
        ],
        "type" : "circuit_breaking_exception",
        "reason" : "[parent] Data too large, data for [<http_request>] would be [4080692272/3.8gb], which is larger than the limit of [4080218931/3.7gb], real usage: [4080692272/3.8gb], new bytes reserved: [0/0b], usages [request=0/0b, fielddata=0/0b, in_flight_requests=0/0b, accounting=82023656/78.2mb]",
        "bytes_wanted" : 4080692272,
        "bytes_limit" : 4080218931,
        "durability" : "PERMANENT"
    },
    "status" : 429
    }
    ```
    - 原因 jvm 堆内存不够加载当前查询到的数据 data too large, 请求被熔断，indices.breaker.request.limit 默认为 jvm heap 的 60%。
        - https://www.elastic.co/guide/en/elasticsearch/reference/7.6/circuit-breaker.html
    - 解决方案一 编辑 elasticsearch jvm.option配置，将-Xms和-Xmx 调大，初始值都是1G。修改配置后，重启ES。
    - 解决方案二 清空缓存(临时性解决)
    ```bash
    curl -XPOST -u admin:Admin@123 'http://${IP}:${PORT}/elasticsearch/_cache/clear?fielddata=true' 
    ```