---
created_date: 2021-08-05
---

[TOC]

## 特性

### 事物隔离级别

- 参考 https://www.cnblogs.com/micro-chen/p/5629188.html

- 在MySQL中，实现了这四种隔离级别，分别有可能产生问题如下所示：
    1. Serializable (串行化)：可避免脏读、不可重复读、幻读的发生。
    2. Repeatable-read(可重复读)：可避免脏读、不可重复读。默认值。Mysql的Repeatable-read隔离级别也实现了避免幻读的发生。
    3. Read-committed (读已提交)：可避免脏读的发生。
    4. Readuncommitted (读未提交)：最低级别，任何情况都无法保证。

    - 脏读  A事物执行过程中，B读取了A事物未commit的修改，但是由于某些原因，发生RollBack了操作，则B事务所读取的数据就会是不正确的。
    - 不可重复读  B事务读取了两次数据，在这两次的读取过程中A事务修改了数据，B事务的这两次读取出来的数据不一样。
    - 幻读  B事务读取了两次数据，在这两次的读取过程中A事务添加了数据，B事务的这两次读取出来的集合不一样。

- 设置事物的隔离级别
    ```sql
    -- 类似于select操作时不添加锁
    SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SELECT * FROM TABLE_NAME ;
    SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    -- 设置事物的隔离级别
    SELECT @@global.tx_isolation; -- the global isolation level
    SELECT @@tx_isolation; -- current session isolation level
    set tx_isolation = 'read-uncommitted'; -- set current session isolation level
    ```

- 基于锁实现Repeatable-Read
    1. 多线程同时更新同一条记录，加X锁。所以并发场景下的 update 是串行执行的。
    2. 工业定义上的 select 一条记录，这个时候会在记录上加读共享锁(S锁)，并到事务结束，因为在这种情况下才能实现记录在事务时间跨度上的可重复读。在读的时候不允许其他事务修改这条记录。
    3. update 一条语句，这个时候会在记录上加行级排他锁(X锁)，并到事务结束，这中场景下，其他读事务会被阻塞。

- Mysql实现Repeatable-Read
    - MVVC (Multi-Version Concurrency Control) (注：与MVCC相对的，是基于锁的并发控制，Lock-Based Concurrency Control)是一种基于多版本的并发控制协议，只有在InnoDB引擎下存在。
    - MVCC只在 READ COMMITTED 和 REPEATABLE READ 两个隔离级别下工作
    1. 读不影响写：事务以排他锁的形式修改原始数据，读时不加锁，因为 MySQL 在事务隔离级别Read-committed 、Repeatable-Read下，InnoDB 存储引擎采用非锁定性一致读－－即读取不占用不等待表上的锁。即采用的是MVCC中一致性非锁定读模式。因读时不加锁，所以不会阻塞其他事物在相同记录上加 X锁来更改这行记录。
    2. 写不影响读：事务以排他锁的形式修改原始数据，当读取的行正在执行 delete 或者 update 操作，这时读取操作不会因此去等待行上锁的释放。相反地，InnoDB 存储引擎会去读取行的一个快照数据。

### 缓存QCache
- 参考  
    - https://blog.csdn.net/zdw19861127/article/details/84937562

- 机制： 缓存SELECT操作 或 预处理查询（5.1.17开始支持）的结果集和SQL语句

- 查看
    ```sql
    -- 查看是否开启了缓存
    show variables like '%query%';
    -- query_cache_type 和 query_cache_size -- 都不为0表示开启了查询缓存功能。
    -- query_cache_type  
        -- 1(ON)： 启用查询缓存，只要符合查询缓存的要求，客户端的查询语句和记录集合可以 缓存起来，共其他客户端使用；
        -- 2(DEMAND):  启用查询缓存，只要查询语句中添加了参数：sql_cache，且符合查询缓存的要求，客户端的查询语句和记录集，则可以缓存起来，共其他客户端使用；

    -- 查看缓存的具体状态
    show global status like 'QCache%';

    -- 查询缓存会生成碎片，通过下面命令来清理碎片
    flush query cache;
    reset query cache
    ```

## 运维基本操作一
1. 设置临时变量
set @key="value";
select @num:=1; 
select @num:=字段名 from 表名;

2. 系统变量
SET @@GLOBAL.slave_parallel_workers = 0;
select @@GLOBAL.slave_parallel_workers;

3. 在sql语句最后面添加\G，可以格式化输出结果。

5. 查看索引
show indexes from 表名;
show keys from 表名;

6. 查看参数修改参数
show variables;
show variables like “参数名称“

set global variablesname=''（全局）
set variablesname=''（当前session）

8. 显示当前使用或者指定的database中的每个表的信息。信息包括表类型和表的最新更新时间。
show table status;

9. 显示最后一个执行的sql语句所产生的错误、警告和通知。
show warnings; 

10. 查看表格的详细信息 -- 显结构，字段类型，主键，是否为空等属性，但不显示外键。
select * from information_schema.columns where table_schema = '数据库名' and table_name = '表名' and COLUMN_NAME='列名'\G;

11. 设置密码规则复杂度为0  v5.7
set global validate_password_policy=0;
set global validate_password_length=1;

12. 创建数据库
create database ${datapath} charset 'utf8mb4';

## 运维基本操作二

### 登入&执行sql脚本
- 参考 https://www.cnblogs.com/zengkefu/p/5690092.html

```bash
# -S 是指定mysql.sock
# -D 指定要连接的数据库
# -e "" 指定要执行的sql语句

# 通过账户密码连接MySQL
mysql -u${user} -p${password} -P${PORT} -h${host} -S ${sockpath} -D${datapath}

key_name=kujiutest
# 通过读取加密文件连接MySQL
mysql --login-path=${key_name}
# login-path是MySQL5.6开始支持的新特性。通过借助mysql_config_editor工具将登陆MySQL服务的认证信息加密保存在 ~/.mylogin.cnf 文件。之后，MySQL客户端工具可通过读取该加密文件连接MySQL，避免重复输入登录信息，避免敏感信息暴露。
mysql_config_editor set --login-path=${key_name} --user=${user}  --host=${host} --port=${port} --password
# 查看配置login-path
mysql_config_editor print --login-path=${key_name}
mysql_config_editor print --all
# 删除配置login-path
mysql_config_editor reset # 删除所有的
mysql_config_editor remove --login-path=${key_name}

# 执行sql文件
mysql -u${user} -p${password} -P${PORT} -h${host} -S ${sockpath} -D${datapath} < sql.sql
```

### 导入导出数据
#### mysql
```sql
-- 1. 导出查询到的数据
mysql --login-path=${key_name} ${sql脚本路径} data.txt  
mysql --login-path={key_name} -e "${sql语句}" > data.txt

-- 2. 导出查询到的数据为csv文件
sql语句 into outfile '/tmp/table.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\r\n';
```
#### mysqldump
```bash
time mysqldump --skip-add-locks --single-transaction --default-character-set=utf8mb4 --set-gtid-purged=off  -h${host} -u${user} -p${pass}  ${database} ${table} > ${table}.sql

# -t 只导出数据 --no-create-info
# -d 不导出任何数据，只导出数据库表结构 --no-data
# -R 导出存储过程以及自定义函数 --routines
# -E 导出事件 --events
# --triggers  默认导出触发器 使用--skip-triggers屏蔽导出
# -n 不导出数据 --no-data

# --add-locks，这是导出时的默认值，意思是导出某张表时，会在该表上加个锁，导出完成后执行unlock，如果导出过程中表数据有变动（增删改），对应的sql就会被挂起，直到unlock之后才能继续执行，这样执行导出会更高效！但是，如果导出的表，数据量比较大，会导致导出表的时间比较长，而如果业务操作表又比较频繁的话，默认加锁的操作就造成大量业务sql堵塞，影响实际业务运行，不能因为要高效而抛弃了实际业务，这个时候就要用--skip-add-locks跳过加锁模块

# --single-transaction参数的作用，设置事务的隔离级别为可重复读，即REPEATABLE READ，这样能保证在一个事务中所有相同的查询读取到同样的数据，也就大概保证了在dump期间，如果其他innodb引擎的线程修改了表的数据并提交，对该dump线程的数据并无影响，在这期间不会锁表。

# --opt Same as --add-drop-table, --add-locks, --create-options,   --quick, --extended-insert, --lock-tables, --set-charset, and --disable-keys. Enabled by default, disable with  --skip-opt 

# --set-gtid-purged=on # 清掉bin-log和gtid信息，默认为on

# --column-statistics=0 # 最新的mysqldump版本需要这个参数才能进行导出操作
```

- 记录
    - 导出2g数据耗时
        ```log
        real	0m38.495s
        user	0m35.658s
        sys	    0m2.261s
        ```

### binlog
1. 查看内存状态的binlog配置
    ```sql
    -- 查看默认设置的binlog过期时间
    show variables like "%expire_logs%";
    -- 临时设置binlog保留时间
    set global expire_logs_days=15
    -- 查看数据库是否开启binlog日志
    show variables like '%log_bin%';
    -- 查看所有binlog文件
    show binary logs;
    -- 只查看第一个binlog文件的内容
    show binlog events; 
    -- show binlog events in 'mysql-bin.000003';

    -- 清理binlog日志
    purge master logs to 'binlognumber';
    ```

2. 用mysql自带的工具，提取出binlog日志进行分析
    ```bash
    host=127.0.0.1
    user=root
    start_datetime="2021-05-27 10:00:00" # 开始时间
    stop_datetime="2021-05-27 10:30:00" # 结束时间
    binlogfile="mysql-binlog.191250" # 从哪个binlog文件开始提取
    result_file=='mysql-binlog.txt' # 保存结果进文件

    mysqlbinlog --no-defaults --read-from-remote-server  --host=${host} --port=3306 --user ${user} --password  --base64-output=decode-rows -v --start-datetime="${start_datetime}" --stop_datetime="${stop_datetime}" --stop-never  --result-file=${result_file} ${binlogfile}
    
    # --database=数据库名  -d=数据库名
    # --base64-output=decode-rows  binglog格式为row时，进行解码
    # --skip-gtids=true
    ```

### 查看数据库和表的大小
```sql
-- 查看整个mysql的容量大小
select concat(round(sum((data_length+index_length)/1024/1024),2),'MB') as volume from information_schema.tables;
select concat(round(sum((data_length+index_length)/1024/1024/1024),2),'GB') as volume from information_schema.tables;

-- 查看一个数据的容量大小
set @table_schema="数据库名称";
select concat(round(sum((data_length+index_length)/1024/1024),2),'MB') as volume from information_schema.tables where table_schema=@table_schema;

-- 查看所有数据库各个容量大小
select
table_schema as 'table_schema',
sum(table_rows) as 'table_rows',
sum(truncate(data_length/1024/1024, 2)) as 'data volumes(MB)',
sum(truncate(index_length/1024/1024, 2)) as 'index volumes(MB)'
from information_schema.tables
group by table_schema
order by sum(data_length) desc, sum(index_length) desc;


-- 查看某个数据库各个表容量大小
set @@table_schema="数据库名称";
select 
table_name as 'table_name',
sum(table_rows) as 'table_rows',
sum(truncate(data_length/1024/1024, 2)) as 'data volumes(MB)',
sum(truncate(index_length/1024/1024, 2)) as 'index volumes(MB)'
from information_schema.tables where table_schema=@@table_schema
group by table_name
order by sum(data_length) desc, sum(index_length) desc;
```

### 配置慢日志
1. 临时配置
    ```sql
    show variables like 'slow_query%';
    show variables like 'long_query_time';

    set global slow_query_log='ON'; 

    set global slow_query_log_file='/tmp/garyslow.log'; -- linux
    set global slow_query_log_file='D:\\mysq\data\slow.log';  -- windows

    set global long_query_time=1; -- 设置耗时多少秒为慢查询
    ``` 

2. 永久配置
    ```sql
    [mysqld]
    slow_query_log = ON
    slow_query_log_file = /usr/local/mysql/data/slow.log
    long_query_time = 1
    log_output = 'FILE,TABLE' -- 日志存储方式 默认值是’FILE’，雀圣写入 host_name-slow.log 文件中。log_output='TABLE’表示将日志存入数据库 mysql.slow_log 表中。
    -- log_queries_not_using_indexes -- 未使用索引的查询也被记录到慢查询日志中（可选项）
    ```



### 用户权限操作
1. 查看用户权限
    ```sql
    show grants for username@'%';
    show grants for username@'localhost';
    ```
2. 查看当前用户
    ```sql
    select user();
    ```
3. 查看所有的用户
    ```sql
    SELECT HOST,USER FROM mysql.user;
    SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;
    ```
4. 增加管理员并且拥有授权权限
```sql
    grant all privileges on *.*  to 'dbusername'@'%' identified by 'password'  with grant option;
    flush privileges;
```

5. 增加应用用户
    ```sql
    grant select,insert,update,delete on `dbname`.* to 'dbusername'@'%' identified by 'password';
    -- 或某个数据库所有权
    grant all privileges on dbuser.* to 'dbusername'@'%' identified by 'password';
    flush privileges;
    ```

6. 撤销权限
    ```sql
    revoke all privileges on *.*  from 'dbusername'@'%';
    revoke update, delete ON *.*  from 'dbusername'@'%';

    REVOKE all privileges, GRANT OPTION FROM 'dbusername'@'%';
    ```

7. 改用户密码
    ```sql
    set password for root@localhost = password('123');

    -- 另一种方式 mysql5.7
    update user set authentication_string = password('newpass') where user = 'root';
    flush privileges;
    ```
8. 删除用户及权限
    ```sql
    delete from mysql.user where User='dbusername' and Host='localhost';
    flush privileges; -- 刷新权限

    drop user dbusername@'%'; -- 删除账户及权限
    ```

9. 赋予super权限
    ```sql
    select user,Super_priv from mysql.user;
    update mysql.user set Super_priv='Y' where user='gary';
    update mysql.user set Super_priv='N' where user='gary';
    flush privileges;
    ```

10. 权限与用户
```sql
-- 创建用户
create user username@localhost identified by 'password';
insert into mysql.user(Host,User,Password) values("localhost","test",password("1234"));
create user username@localhost identified by 'password' password expire;

-- 授予用户的权限：全局层级权限、数据库层级权限、表层级别权限、列层级别权限、子程序层级权限。
-- 全局层级权限:这些权限存储在mysql.user表中。
GRANT ALL ON *.*; -- 授予全局权限。
REVOKE ALL ON *.*; -- 撤销全局权限。
-- 数据库层级权限:这些权限存储在mysql.db和mysql.host表中。
GRANT ALL ON db_name.*; -- 授予数据库权限。
REVOKE ALL ON db_name.*; -- 撤销数据库权限。
-- 表层级别权限:这些权限存储在mysql.tables_priv表中。
GRANT ALL ON db_name.tbl_name; 授予表权限
REVOKE ALL ON db_name.tbl_name; 撤销表权限。
-- 列层级别权限:这些权限存储在mysql.columns_priv表中。当使用REVOKE时，您必须指定与被授权列相同的列
-- 子程序层级权限(存储过程):存储在mysql.procs_priv表

flush privileges;
```

## DBA
- DBA日常工作 -- 排查性能问题

- 工具
pt-query-digest 工具是包含在Percona toolkit里的. 相关安装方式可以参考 https://www.percona.com/doc/percona-toolkit/LATEST/installation.html

- 显示内部信息
    ```sql
    show engine innodb status
    ```

### 连接数、状态、最大并发数
1. 查看连接数限制 
    show variables like '%connections%';
2. 查看历史上最大连接数 
    show global status like 'max_used_connections';
3. 设置最大连接数 
    set global max_connections=1000 
4. 查看连接数信息
    show status like 'Threads%';
    - 输出说明：
    1. Threads_cached  34 # mysql管理的线程池中还有多少可以被复用的资源
    2. Threads_connected 32 # 打开的连接数
    3. Threads_created 66 # 代表新创建的thread（根据官方文档，如果thread_created增大迅速，需要适当调高 thread_cache_size）。
    4. Threads_running 2 # 激活的连接数，这个数值一般远低于connected数值，准确的来说，Threads_running是代表当前并发数

5.  information_schema.processlist
    1. 当前的连接信息都保存在这张表格里 information_schema.processlist, 字段说明如下
    ```yaml
    id: 为连接的应用id号
    user: 为连接数据库的用户
    host: 为连接数据的主机IP地址和端口
    db: 为连接访问的数据库
    command: 为当前正在执行的SQL语句类型，分为Query，Update，Updating等
    time: 为应用的Sleep时间
    state: 为当前连接的状态，共包括Copying to tmp table on disk，Flushing tables，Sending data等二十多种状态。
    info: 为当前应用连接执行的SQL语句，如果语句过长，可能会显示不完整。
    ```
    2. 查看应用的连接
    ```sql
    show processlist;
    show full processlist;
    -- 查看非睡眠状态的连接
    select ID,USER,HOST,DB,COMMAND,TIME,STATE from information_schema.processlist where Command != 'Sleep' order by Time desc;
    select ID,USER,HOST,DB,COMMAND,TIME,STATE,INFO from information_schema.processlist where Command != 'Sleep'and INFO != "NULL" order by Time desc;
    -- 通过事务ID查看线程
    SELECT * from information_schema.processlist WHERE id = 738178711/G
    ```
    3. 查看当前连接中连接时间最长的的连接
    ```sql
    select host,user,time,state,info from information_schema.processlist order by time desc limit 10;
    ```
6. 中止应用线程
    - 一般出现长时间的select可以考虑kill掉，但是update或者delete不建议kill
    - kill ${id}
    
### Mysql自带的数据库
- information_schema 数据库 
    - 保存了该MySQL服务器上所有的数据库及表信息，表字段类型，访问权限等

    - innodb_trx表 保存当前运行的所有事务
    - innodb_locks表 保存当前出现的锁
    - innodb_lock_waits表 保存锁等待的对应关系

- performance_schema 数据库

- sys 数据库

- mysql 数据库

### 当问题已发生
- 问题已经发生则查询这两种表
    - information_schema.PROCESSLIST
    - sys.innodb_lock_waits\

- 排查
```sql
-- 参考 https://aws.amazon.com/cn/premiumsupport/knowledge-center/blocked-mysql-query/
-- 参考 https://www.cnblogs.com/luyucheng/p/6297752.html

show processlist;

-- 查看表活跃情况
show OPEN TABLES where In_use > 0;
-- In_use  表示有多少线程正在使用某张表

-- 查看未提交的事务。
-- 如果数据库存在锁，则在trx_query列中有值的即为锁住表的sql语句 或者 trx_state字段值不是“running”
select trx_query,trx_state from information_schema.innodb_trx where trx_state != "RUNNING";
select trx_state, trx_started, trx_mysql_thread_id, trx_query from information_schema.innodb_trx\G
-- select * from information_schema.innodb_trx\G 

-- 查看当前锁定的事务
select * from information_schema.innodb_locks limit 10;

-- 查看当前等锁的事务
select * from sys.innodb_lock_waits limit 10\G
select * from sys.innodb_lock_waits order by wait_age_secs desc limit 10\G

-- 查看当前用户连接数
select USER , count(*) as num from information_schema.processlist group by USER order by num desc limit 10;

-- 查看当前连接中各个IP的连接数
select substring_index(host,':',1) as ip, count(*) as num from information_schema.processlist group by ip order by num desc limit 10;
```

- 排查高CPU的SQL
```bash
# 参考 https://www.percona.com/blog/2020/04/23/a-simple-approach-to-troubleshooting-high-cpu-in-mysql/

# 寻找cpu使用率最大的mysql线程及对应的sql语句及优化
pidstat -t -p ${mysqld_pid} 1 # 获取cpu使用率最大的mysql线程 TID ，1表示每1秒刷新一次
top -H -p ${mysqld_pid} # 查看mysql线程的资源使用情况

# 查询线程对应的sql
select * from performance_schema.threads where THREAD_OS_ID = ${TID} \G

# 查找可以优化的地方
explain ${sql}
```

### 优化、预防问题发生
- 通过下面的表进行优化
    - sys.statements_with_full_table_scans
    - sys.schema_unused_indexes
    - performance_schema.table_io_waits_summary_by_index_usage
    - performance_schema.table_io_waits_summary_by_table
    - performance_schema.table_lock_waits_summary_by_table

- 优化
```sql
-- 查看锁表情况
show status like 'Table%';

-- 通过检查InnoDB_row_lock状态变量来分析系统上的行锁的争夺情况
show status like 'InnoDB_row_lock%';
-- InnoDB_row_lock_current_waits：当前正在等待锁定的数量；
-- InnoDB_row_lock_time：从系统启动到现在锁定总时间长度；
-- InnoDB_row_lock_time_avg：每次等待所花平均时间；
-- InnoDB_row_lock_time_max：从系统启动到现在等待最常的一次所花的时间；
-- InnoDB_row_lock_waits：系统启动后到现在总共等待的次数；
```

- 如果查询时使用的字符集 和 表的字符集 不一致则会导致索引失效

- 死锁日志
```sql
show variables like "%innodb_print_all_deadlocks%";
-- 开启死锁日志，死锁日志被存放进error_log配置的文件里面
set global innodb_print_all_deadlocks=1

-- 参数
-- innodb_deadlock_detect 死锁检测 mysql 5.7.15，default on
-- innodb_lock_wait_timeout 锁等待超时，自动回滚事务， default 50s
```


### 统计数据
```sql
show global status like 'uptime'; -- 开机时间

-- 统计qps
show  global  status like 'Question%'; --总共的
-- QPS = Questions / uptime

show global status like 'Com_commit'; --只统计显式提交的事务
show global status like 'Handler_commit'; --显示所有内部的事务
show global status like 'Handler_rollback';
-- TPS = Handler_commit-Handler_rollback / seconds 

-- InnoDB Buffer命中率 
-- InnoDB Buffer缓存的是整张表中的数据
show status like 'innodb_buffer_pool_read%'; 
-- innodb_buffer_pool_reads 表示read请求的次数
-- innodb_buffer_pool_read_requests 表示从物理磁盘中读取数据的请求次数
-- innodb_buffer_read_hits = (1 - innodb_buffer_pool_reads / innodb_buffer_pool_read_requests) * 100% 


-- Query Cache命中率 
-- Qcacche缓存的是SQL语句及对应的结果集
show status like 'Qcache%'; 
-- Query_cache_hits = (Qcahce_hits / (Qcache_hits + Qcache_inserts )) * 100%; 
```

## 问题

### 磁盘压力过大导致主从同步延迟

- slow slave status \G
    ```log
    Slave_SQL_Running_State: System lock
    ```

- innodb_flush_log_at_trx_commit和sync_binlog 两个参数是控制MySQL 磁盘写入策略以及数据安全性的关键参数
- sync_binlog
    - sync_binlog参数控制数据库的binlog刷到磁盘上去。
    - select @@sync_binlog;
    1. 默认，sync_binlog=0，表示MySQL不控制binlog的刷新，由文件系统自己控制它的缓存的刷新。这时候的性能是最好的，但是风险也是最大的。因为一旦系统Crash，在binlog_cache中的所有binlog信息都会被丢失。
    2. sync_binlog=1，事务提交后，将二进制文件写入磁盘并立即执行刷新操作，相当于是同步写入磁盘，不经过操作系统的缓存。
    3. sync_binlog=N，每写N次操作系统缓冲就执行一次刷新操作。 （将这个参数设为1以上的数值会提高数据库的性能，但同时会伴随数据丢失的风险）

- innodb_flush_log_at_trx_commit
    - innodb_flush_log_at_trx_commit参数设置 Log Buffer 里的数据写入磁盘。
    - select @@innodb_flush_log_at_trx_commit;
    - mysql写文件有2块缓存。一块是自己定义在内存的Log Buffer, 另一个是磁盘映射到内存的OS Buffer.  
    - 写入 ---> Log Buffer --flush-> OS Buffer --fsync-> 磁盘

    - mysql可以 调用 flush 主动将Log Buffer 刷新到磁盘内存映射，也可以调用 fsync 强制操作系同步磁盘映射文件到磁盘。还可以同时调用 flush + fsync, 将缓存直接落盘。
    1. =0 Log Buffer将每秒写入OS Buffer中一次，并且OS Buffer的flush(刷到磁盘)操作同时进行。该模式下在事务提交的时候，不会主动触发写入磁盘的操作。
    2. =1（默认值） 每次事务提交时MySQL都会把Log Buffer的数据写入log file，并且flush(刷到磁盘)中去。
    3. =2 每次事务提交时MySQL都会把Log Buffer的数据写入OS Buffer，但是flush(刷到磁盘)操作并不会同时进行。该模式下，MySQL会每秒执行一次 flush(刷到磁盘)操作。

innodb_io_capacity = 3000                        ( 默认为 200, 配置成常用的IOPS使用量 ，可增加写入效能 ) [2]
innodb_io_capacity_max = 6000               ( 默认为 2000, 配置成RDS常用使用量的2倍，可增加写入效能 ）

### zabbix远程执行mysql指令失败
    - Remote Commands执行 mysql -V，touch /tmp/test 都成功了
    - su - zabbix 后执行 key_name='gary' && /usr/bin/mysql --login-path=${key_name} -e "stop slave; start slave;"; 也成功了
    ```bash
    key_name='gary'
    /usr/bin/mysql --login-path=${key_name} -e "stop slave; start slave;";
    echo '--------'
    mysql_config_editor print --all
    ```
    ```log
    ERROR 1045 (28000): Access denied for user 'zabbix'@'localhost' (using password: NO)
    --------
    failed to set login file name
    operation failed.
    ```
    - 最后的解决措施
        - visudo 添加配置 zabbix  ALL=(ALL)       NOPASSWD: ALL
        - Remote Commads 配置 sudo /usr/bin/mysql --login-path=${key_name} -e "stop slave; start slave;";

### 死锁导致主从同步异常 -- 不理解/从库只读，为什么会产生死锁
- 错误日志 
    ```log
    show slave status\G
    ...
    Last_SQL_Errno: 1205
    Last_Error: Slave SQL thread retried transaction 20 time(s) in vain, giving up. Consider raising the value of the slave_transaction_retries variable.
    ...

    /var/log/mysqld.log
    ...
    2021-08-05T07:48:36.255411Z 27177963 [Warning] Slave SQL for channel '': Could not execute Write_rows event on table 被同步的数据库名.表名; Lock wait timeout exceeded; try restarting transaction, Error_code: 1205; handler error HA_ERR_LOCK_WAIT_TIMEOUT; the event's master log m    ysql-bin-changelog.150903, end_log_pos 2250513, Error_code: 1205
    2021-08-05T07:48:36.256217Z 27177963 [ERROR] Slave SQL for channel '': Slave SQL thread retried transaction 20 time(s) in vain, giving up. Consider raising the value of the slave_transaction_retries variable. Error_code: 1205
    2021-08-05T07:48:36.256228Z 27177963 [Warning] Slave: Lock wait timeout exceeded; try restarting transaction Error_code: 1205
    2021-08-05T07:48:36.256866Z 27177963 [ERROR] Error running query, slave SQL thread aborted. Fix the problem, and restart the slave SQL thread with "SLAVE START". We stopped at log 'mysql-bin-changelog.150903' position 2248860.
    2021-08-05T07:54:37.147338Z 27162992 [Note] Aborted connection 27162992 to db: 'mysql' user: '用户名' host: 'IP地址' (Got an error reading communication packets)
    ```

- slave因为锁导致主从中断
```sql
-- InnoDB事务在放弃前等待行锁的时间（秒）。innodb_lock_wait_timeout默认值为50秒。当有试图访问被另一行锁定的行的事务InnoDB事务在发出以下错误：
-- ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
show variables like '%innodb_lock_wait_timeout%';

-- 参数 slave_transaction_retries 设置的为10次，如果事务重试次数超过10次，复制中断。
show variables like '%slave_transaction_retries%';
```