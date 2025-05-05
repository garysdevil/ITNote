---
created_date: 2021-08-05
---

[TOC]

# Mysql总览

1. Mysql的层级架构
   - 连接层 数据库的连接，验证
   - SQL层 解析查询，优化查询，执行查询
   - 存储层 磁盘（InnoDB，MyISAM），内存memory，网络ndb

## 机制

### 主从复制

1. master将改变记录到二进制日志(binary log)。
2. slave开启一个 I/O 线程，连接master，进行binlog dump process，从master的二进制日志中读取事件，然后写入本地的中继日志(relay log)内。如果已经同步好master的binlog事件，它将会睡眠并等待master产生新的事件。
3. slave开启一个 SQL 线程，SQL线程从中继日志读取事件，并重放其中的事件而更新slave的数据，使其与master中的数据一致。假设该线程与I/O线程保持一致，中继日志通常会位于OS的缓存中，所以中继日志的开销很小。
