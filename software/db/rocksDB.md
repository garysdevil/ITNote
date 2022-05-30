## RockDB介绍

- 源码 https://github.com/facebook/rocksdb

- rust版本源码 https://github.com/rust-rocksdb/rust-rocksdb

- 起源 2012年4月，Facebook公司的Dhruba Borthakur在LevelDB上创建了RocksDB分支，目标是提高服务工作负载的性能，最大限度的发挥闪存和RAM的高度率读写性能。

- RocksDB 属于嵌入式数据库，没有网络交互接口，必须和服务部署在同一台服务器上。

- 设计思想： 数据冷热分离。
    1. 新写入的“热数据”会保存在内存中，如果过一段时间数据没有被更新，冷数据则会“下沉”到磁盘底层的“表层文件”，如果过一段时间数据继续没有被更新，冷数据继续“下沉”到更底层的文件中。
    2. 如果磁盘底层的冷数据被修改了，它又会再次进入内存，一段时间后又会被持久化刷回到磁盘文件的浅层，然后再慢慢往下移动到底层。

- RocksDB对比LevelDB
    - LevelDB只能支持单线程文件合并；RocksDB支持多线程文件合并，充分利用服务器多核。
    - LevelDB只有一个Memtable，诺Memtable满了还没有来得及Flush刀sst文件，则会引起系统停顿；DocksDB可以根据服务器内存情况开辟多个Immutable Memtable。
    - LevelDB每次只能获取一个KV；RocksDB支持批量获取。
    - LevelDB不支持备份和恢复；RocksDB支持增量备份、全量备份和恢复。