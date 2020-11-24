## 概览
- 文档
https://www.elastic.co/guide/cn/kibana/current/index.html 官网中文文档-用户手册
https://www.elastic.co/cn/webinars/getting-started-kibana?baymax=default&elektra=docs&storm=top-video 官网学习视频

## 安装
- 参考
https://www.elastic.co/cn/downloads/past-releases
需要和elasticsearch版本对应
1. wget https://artifacts.elastic.co/downloads/kibana/kibana-7.9.3-linux-x86_64.tar.gz
2. nohup ./bin/kibana > kibana.log 2>&1 &
3. 默认端口 5601
### 配置
```conf
server.host: "0.0.0.0" # 默认为localhost
elasticsearch.hosts: ["http://localhost:9200"] # 默认为localhost
```