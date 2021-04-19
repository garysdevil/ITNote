
- 参考链接
https://www.runoob.com/redis/redis-tutorial.html 增删改查
https://www.cnblogs.com/gnuhpc/p/4609592.html 指令
https://www.cnblogs.com/yiwangzhibujian/p/7067575.html 配置
http://redisdoc.com/topic/cluster-tutorial.html 集群
https://zhuanlan.zhihu.com/p/111547061 架构
https://nullcc.github.io/2018/02/15/(%E8%AF%91)Redis%E5%93%8D%E5%BA%94%E5%BB%B6%E8%BF%9F%E9%97%AE%E9%A2%98%E6%8E%92%E6%9F%A5/  延迟

## 基础
1. 基于单机模式默认有16个库，集群没有数据库的概览。
### 数据类型
1. 字符串   
    1. SET keyname value
    2. get keyname
2. 哈希     
    1. HSET hkeyname key1 value1 key2 value2 ...
    2. 列出哈希表中所有的key和value     HGETALL hkeyname
3. 列表     
    1. LPUSH keyname value1 value2 ...
    2. 列出列表里的元素 LRANGE key  start end
4. 集合     
    1. SADD keyname value1  value2
    2. 查看集合里所有的元素 SMEMBERS key
    3. 查看这个元素是否在集合里 SISMEMBER key value1
5. 有序集合
    1. 增加操作
        ZADD keyname 1 value1
        ZADD keyname 2 value2
    2. 查看操作
        ZRANGE keyname start end

## 原理
### 单线程
1. Redis是单线程的。
2. Redis 单线程如何处理那么多的并发客户端连接?
    Redis的IO多路复用:redis利用epoll来实现IO多路复用，将连接信息和事件放到队列中，依次放到 文件事件分派器，事件分派器将事件分发给事件处理器。
### 持久化
1. 持久化机制
    1. aof（默认值）把写操作指令，持续的写到一个类似日志文件里。
    2. rdb fork一个进程，遍历hash table，利用copy on write，把整个db dump保存下来。save, shutdown, slave 命令会触发这个操作。
## 集群
- 参考
    - https://blog.csdn.net/qq_38937634/article/details/112172719
1. 集群可扩展性
    - 集群通过Sharding实现可扩展性，默认有 16384 个slot
    - 集群使用hash_slot来切分数据进slot里，slot = CRC16(key) % 16384
    - 通过指令计算一个key的slot值： CLUSTER KEYSLOT key  或者 通过 http://www.ip33.com/crc.html 参数模型选择CRC-16/XMODEM
    - 缺陷： 集群添加删除节点，需要重新分配数据进对应的slot里
2. 集群去中心化
    - 缺陷：不能把客户端发出的一条指令转发到不同的节点，然后再把结果合并返回给客户端
## 场景
1. 缓存穿透
    - 是指查询一个根本不存在的数据， 缓存层和存储层都不会命中， 通常出于容错的考虑， 如果从存储 层查不到数据则不写入缓存层。 
    缓存穿透将导致不存在的数据每次请求都要到存储层去查询， 失去了缓存保护后端存储的意义。
    - 解决措施:可以将空对象缓存起来或者设置一个特殊意义的字符串来标示此记录数据库中不存在，直接在缓存层返回.
2. 缓存雪崩
    - 如果在某个时间点，有大量缓存失效，那么下一个时间点就会有大量请求访问到数据库，这种情况下，数据库可能因为访问量多大导致“崩溃”

3. 缓存和数据一致性

## 监控
1. used_memory
Redis 内存分配器分配的内存总量（单位是字节），包括使用的虚拟内存（即 swap）
2. used_memory_rss
Redis 进程占据操作系统的内存（单位是字节），与 top 及 ps 命令看到的值是一致的。
除了内存分配器分配的内存之外，used_memory_rss 还包括进程运行本身需要的内存、内存碎片等，但是不包括虚拟内存。
3. maxmemory
最大内存限制，0表示无限制
## 运维操作
1. 连接redis 默认端口6379
redis-cli -h IP -p PORT -a PASS -c
参数 -c 表示进入集群模式
2. 密码验证
auth PASS
3. 统计未被销毁的key数量
dbsize

4. 选择数据库
select 1

5. 后台进程重写AOF(手动触发aof日志重写机制)
bgrewriteaof

bgsave 后台保存rdb快照

SAVE 保存rdb快照

LASTSAVE 上次保存时间

6. 清空一个实例下所有数据库的所有数据
FLUSHALL

7. 查看此实例的所有信息
info

8. 临时修改密码
config set requirepass 123456

9. 扫描占用内存大的键值
redis-cli -h ${IP} --bigkeys

### 慢日志

1. 动态配置慢日志
    - 设置保存慢日志的数量
    config set slowlog-max-len 10
    config get slowlog-max-len

    - 执行时间超过多少微秒的请求会被记录到慢日志（1秒等于1 000 000微秒)
    config set slowlog-log-slower-than 10000
    config get slowlog-log-slower-than 
2. 操作
    获取慢日志的数量 slowlog len
    获取所有的慢日志 slowlog get

3. 结果显示
```conf
1) 1) (integer) 0 # 日志唯一标识符
   2) (integer) 1517305551 # 命令执行的UNIX时间戳
   3) (integer) 8248 # 命令执行的时间（微秒）
   4) 1) "keys" # 执行的命令及参数
      2) "*"

```
Redis Version >= 4.0
```conf
   5) "172.31.92.72:45220"  # 连接Redis的客户端IP:PORT
   6) ""  # 连接Redis的客户端名字
```
### 常规操作
1. 列出当前db有效的key 
    keys *

2. 查看key剩余的过期时间/秒
    TTL key名字

3. 查看数据库类型
    TYPE key名字
## 配置
### 参数
```conf
cluster-require-full-coverage
```
### 配置文件 
```conf
#后勤配置

daemonize yes  ##以守护进程方式运行

pidfile /opt/redis/redis-1/var/run/redis.pid  ##指定pid文件路径

maxclients 10000  ##同一时间最大客户端连接数

timeout 0 ##当客户端闲置多长时间后关闭连接，0表示关闭此功能

loglevel notice ##日志记录等级

logfile ""  ##日志文件路径



#网络配置

port 6379  ##监听端口

bind 172.16.65.167 ##绑定的主机地址

tcp-backlog 511 ##此参数确定TCP连接中已完成（三次握手）队列的长度 /proc/sys/net/core/somaxconn，高并发系统需要适当调大

tcp-keepalive 60 ##保持tcp连接时间，0表示关闭此功能



#集群配置

cluster-enabled yes  ##启用集群模式

cluster-config-file nodes-6379.conf  ##集群配置文件名

cluster-node-timeout 15000 ##集群节点不可用时间，超过时间认为节点下线

#数据库配置

databases 16  ##设置数据库的数量

dir /opt/redis/redis-1/data/  ##指定本地数据库存放目录

#RDB配置

dbfilename dump-6379.rdb  ##指定本地数据库名

save 900 1 ##指定多长时间内，有多少次更新，就将数据同步到数据文件<秒><次数>

save 300 10

save 60 10000

rdbcompression yes  ##存储本地数据库时是否压缩数据

rdbchecksum yes  ##保存数据时是否开启检查，性能消耗10%，但可以提高安全性

stop-writes-on-bgsave-error yes ##失败是否停止写入数据



#AOF配置

appendonly yes ##aof持久化策略，reids会在aof文件中添加每一个写操作，避免极端情况下导致数据丢失。

appendfilename "appendonly-6379.aof" ##指定更新日志文件名

appendfsync everysec ##执行fsync间隔,三种模式（no|always|everysec）

no-appendfsync-on-rewrite no#写AOF的时候放弃同步主进程变化，可能会丢日志

auto-aof-rewrite-percentage 100 ##aof文件扩大100%重写该日志

auto-aof-rewrite-min-size 64mb ##除了百分比，再加体积限制

aof-load-truncated yes  ##redis启动时加载被截断的aof文件

aof-rewrite-incremental-fsync yes ##当子进程重写aof文件时，每产生32M同步一次，有助于更快写入文件到硬盘避免延迟。

#maxmemory配置

Maxmemory <bytes>

Maxmemory-policy volatile-lru

Maxmemory-samples 3

lua-time-limit 5000 ##lua脚本最长执行时间，0或负数表示无限执行时间



#主从配置

#Slaveof ip 6379

masterauth "×××××" #密码

slave-serve-stale-data yes ##从连不上主时，yes正常响应客户端请求，但数据可能不完整，为NO时响应“SYNC with master in progress” info和slaveof命令除外。

#slave-read-only yes ##从服务器只读，集群情况下应该无法配置只读

repl-diskless-sync no  ##

repl-diskless-sync-delay 5

repl-disable-tcp-nodelay no  ##是否合并tcp包传送，no立马发送，yes合并tcp包节约带宽，从太多可以考虑yes

slave-priority 100 ##从服务器成为主的优先级，越小几率越大

#安全

requirepass "×××××" #密码

#慢查日志

slowlog-log-slower-than 10000 ##超过一秒的执行或写入记录到慢日志

slowlog-max-len 128 ##慢日志记录128个



notify-keyspace-events "" 

#高级配置

hash-max-ziplist-entries 512  ##REDIS_LIST的elem数小于配置值时以REDIS_ENCONDING_ZIPLIST类型存储，以节约内存，否则以dict存储

hash-max-ziplist-value 64  ##同上，元素的长度

list-max-ziplist-entries 512  ##REDIS_LIST的entry数小于配置值时以REDIS_ENCONDING_ZIPLIST类型存储，以节约内存，否则以REDIS_ENCODING_LINKEDLIST存储

list-max-ziplist-value 64  ##同上  元素的长度

set-max-intset-entries 512

zset-max-ziplist-entries 128

zset-max-ziplist-value 64

hll-sparse-max-bytes 3000 #配置超重对数基数，CPU比较强的情况下可以上万

activerehashing yes  ##重建hash表时是否尽快释放内存

client-output-buffer-limit normal 0 0 0 ##客户端输出缓存区大小

client-output-buffer-limit slave 256mb 64mb 60#应当调大

client-output-buffer-limit pubsub 32mb 8mb 60

hz 10 ##设置reids后台任务执行频率，如清除过期键任务等，建议10-100之间

#latency monitor

latency-monitor-threshold 0 ##用LATENCY打印redis实例跑命令时的耗时图标，监视频率，0为不监控


#systcl.conf

#vm.overcommit_memory=1
```