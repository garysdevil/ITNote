---
created_date: 2022-05-31
---

[TOC]

## RockDB介绍

- 源码

  - C++ https://github.com/facebook/rocksdb
  - Rust https://github.com/rust-rocksdb/rust-rocksdb

- 起源

  - 2012年4月。
  - Facebook公司的Dhruba Borthakur在LevelDB上创建了RocksDB分支。
  - 目标是提高服务工作负载的性能，最大限度的发挥闪存和RAM的高度率读写性能。
  - 向后兼容的levelDB API。

- RocksDB 属于嵌入式数据库，没有网络交互接口，必须和服务部署在同一台服务器上。

- 设计思想： 数据冷热分离。

  1. 新写入的“热数据”会保存在内存中，如果过一段时间数据没有被更新，冷数据则会“下沉”到磁盘底层的“表层文件”，如果过一段时间数据继续没有被更新，冷数据继续“下沉”到更底层的文件中。
  2. 如果磁盘底层的冷数据被修改了，它又会再次进入内存，一段时间后又会被持久化刷回到磁盘文件的浅层，然后再慢慢往下移动到底层。

- RocksDB对比LevelDB

  1. 增加了column family，这样有利于多个不相关的数据集存储在同一个db中，因为不同column family的数据是存储在不同的sst和memtable中，所以一定程度上起到了隔离的作用。
  2. LevelDB只能支持单线程文件合并；RocksDB支持多线程文件合并，充分利用服务器多核。
  3. LevelDB只有一个Memtable，诺Memtable满了还没有来得及Flush刀sst文件，则会引起系统停顿；DocksDB可以根据服务器内存情况开辟多个Immutable Memtable。
  4. LevelDB每次只能获取一个KV；RocksDB支持批量获取。
  5. LevelDB不支持备份和恢复；RocksDB支持增量备份、全量备份和恢复。

- 目录介绍

  1. \*.log: 事务日志用于保存数据操作日志，可用于数据恢复。
  2. \*.sst: 数据持久化文件。（如果没有生成sst文件可能是因为第一次写数据，数据量小没触发flush操作，数据都在内存的 MemoryTable 中）
  3. MANIFEST：数据库中的 MANIFEST 文件记录数据库状态。Compaction过程会添加新文件并从数据库中删除旧文件，并通过将它们记录在 MANIFEST 文件中使这些操作持久化。
  4. CURRENT：记录当前正在使用的MANIFEST文件。
  5. LOCK：无内容，open时创建，表示一个db在一个进程中只能被open一次，多线程共用此实例。
  6. IDENTITY：id。
  7. LOG：统计日志。
  8. OPTIONS：配置信息。

- 工作流程

## 机制

- 并发
  - 一次只能由一个进程打开数据库。rocksdb实现从操作系统获取锁以防止误用。
  - 在单个进程中，同一 rocksdb::DB 实例可以由多个并发线程安全地共享。也就是说，不同的线程可以在没有任何外部同步的情况下写入或获取迭代器，或者在同一个数据库上调用Get（rocksdb实现将自动执行所需的同步）。
  - 在单个进程中，Iterator 、 WriteBatch 等实例可能需要外部进行同步。

## 指令操作

```bash
git clone https://github.com/facebook/rocksdb

# 下载依赖，跟进后面的链接 https://github.com/facebook/rocksdb/blob/main/INSTALL.md

make ldb

./ldb -h

db_path=~/.aleo/storage/ledger-3/

./ldb --db=${db_path} --create_if_missing put gary_key gary_value

./ldb --db=${db_path} get gary_key

./ldb --db=${db_path} scan

./ldb --db=${db_path} list_live_files_metadata
```
