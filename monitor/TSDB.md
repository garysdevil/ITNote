# TSDB
1. 时序数据库
1999/07/16 RRDTool First release
2009/12/30 Graphite 0.9.5
2011/12/23 OpenTSDB 1.0.0
2013/05/24 KairosDB 1.0.0-beta
2013/10/24 InfluxDB 0.0.1
2014/08/25 Heroic 0.3.0
2017/03/27 TimescaleDB 0.0.1-beta
m3db

2. 关系型数据 和 时序数据库 的查询语句对比
https://songjiayang.gitbooks.io/prometheus/content/promql/sql.html

3. 关系型数据库的海量查询
https://www.cnblogs.com/Leo_wl/p/9645416.html

4. 远端存储
https://prometheus.io/docs/prometheus/latest/storage/
- https://yunlzheng.gitbook.io/prometheus-book/part-ii-prometheus-jin-jie/readmd/prometheus-remote-storage

## InfluxDB
- https://portal.influxdata.com/downloads/ 官网
- https://www.cnblogs.com/takemybreathaway/articles/10774787.html

### 概览
1. 语法：2.0版本的语法使用的是JavaScript，1.x使用的是sql。

2. influxdb提供了prometheus的对接端口有3个：
/api/v1/prom/read
/api/v1/prom/write
/api/v1/prom/metrics

3. 术语 
database    数据库
measurement 数据库中的表
points  表里面的一行数据
Point由时间戳（time）、数据（field）、标签（tags）组成


### v1版本
#### 部署
1. 默认的数据存储位置为/root/.influxdb/

2. 通过配置文件更改存储位置
    ./influxd --config ./influxdb.conf

3. 默认端口
    8083: Web admin管理服务的端口, http://localhost:8083
    8086: HTTP API的端口
    8088: 集群端口(配置在全局的bind-address，默认是开启的)

### v2版本
#### 部署
1.  默认的数据存储位置为：~/.influxdbv2，自定义存储位置则在启动参数中指定 bolt 和 engine 的存储路径
    ./influxd  --bolt-path ./influxdbv2/influxd.bolt --engine-path ./influxdbv2/engine/

2. 默认端口 9999

#### 操作语法
- 基本上和sql一样

1. 数据保存策略
    show retention policies on 数据库名;

2. 插入操作
    insert measurement,tag1=value,tag2=value key=数值
    例如
    use test1
    insert ztest,tag1=a,tag2=b count=1
    curl -i -XPOST 'http://127.0.0.1:8086/write?db=test1' --data-binary 'ztest,tag1=a,tag2=b count=2'