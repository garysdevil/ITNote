[TOC]

## 优化
- 参考文档
    - https://www.zabbix.com/documentation/3.4/manual/config/items/queue
    - https://blog.csdn.net/bbwangj/article/details/80981098
    - 未研究 https://www.cnblogs.com/luoahong/articles/7911543.html
    - 未研究 https://www.cnblogs.com/guarderming/p/10219897.html
    - 未研究 https://www.cnblogs.com/yaoyaojcy/p/8259827.html
  
1. queue: 表示item从数据库读取数据的耗时

2. queue延迟的原因
    - 子节点性能
    - 子节点与主节点之间的通行质量
    - 子节点与主节点之间的时间差
    - 数据库数据量过大
