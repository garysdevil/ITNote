##
参考
https://www.ruanyifeng.com/blog/2017/08/elasticsearch.html 旧版本
https://www.cnblogs.com/wyq178/p/11968529.html

IP=35.245.212.43
PORT=9200

在HTTP中，PUT语意是代表具有幂等性操作(多次执行都能得到同样的结果)
而且POST则是非幂等，在资源创建时候，执行多次会产生不同的结果
在ES中，使用PUT需要在当前操作索引下指定一个文档ID， 当文档ID不存在时，会进行创建一个文档，如果存在的话，则进行更新，所以在ES里，PUT是具有幂等性，多次执行都能得到同样的结果

1. Index 类似于数据库的概念。索引的名字只能是小写,不能是大写。
2. Index 里Type就是分组的概念。 在7.4.2版本中已经去除了Index里type的概念。
3. Mapping 类似于mysql中表结构, properties类似于mysql表中的字段概念。 es的mapping创建之后无法修改,如果需要修改则需要重新建立index,然后reindex迁移数据。


```bash
# 查看集群状况
curl ${IP}:${PORT}/?pretty

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

# 查看索引下的document
# /Index/Type/_search
# /Index/_search
curl "${IP}:${PORT}/test2-index/_search?pretty"


# 计算集群内document的数量
curl -XGET "http://${IP}:${PORT}/_count?pretty" 
# 计算集index下document的数量
curl -XGET "http://${IP}:${PORT}/${index}/_count?pretty" 


 





```