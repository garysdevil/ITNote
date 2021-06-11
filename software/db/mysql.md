# Mysql总览
1. 按功能分：
    - 连接层  数据库的连接，验证
    - SQL层	解析查询，优化查询，执行查询	
    - 存储层   磁盘（InnoDB，MyISAM），内存memory，网络ndb

2. sql语句分类如下
    1. DDL 数据定义语言，用来定义数据库对象：库、表、列
    代表性关键字：create alter drop
    2. DML 数据操作语言，用来定义数据库记录
    代表性关键字:insert delete update
    3. DCL 数据控制语言，用来定义访问权限和安全级别
    代表性关键字:grant deny revoke
    4. DQL 数据查询语言，用来查询记录数据
    代表性关键字:select

## 安装
### 安装mysql5.6
- https://blog.csdn.net/pengjunlee/article/details/81212250
rpm -qa|grep -i mariadb | xargs rpm -e --nodeps
curl -O http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum repolist all | grep mysql 
rpm -qa | grep mysql
yum install mysql-server


systemctl start mysql && systemctl status mysql

- 设置新密码
/usr/bin/mysqladmin -u root password 'new-password'

```conf /etc/my.cnf
# 跳过密码验证
[mysqld]
skip-grant-tables 
```

### 安装mysql5.7
```bash
wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
yum install -y mysql-community-server
```
```
非互联网状态下
安装MySql57
mysql-community-client-5.7.30-1.el7.x86_64
mysql-community-libs-compat-5.7.30-1.el7.x86_64
mysql57-community-release-el7-10.noarch
mysql-community-server-5.7.30-1.el7.x86_64
mysql-community-common-5.7.30-1.el7.x86_64
```

systemctl start mysqld.service
systemctl status mysqld.service
systemctl enable mysqld

```bash
# 获取MySQL临时用户名密码
grep 'temporary password' /var/log/mysqld.log
# 2020-10-30T16:33:29.896472Z 1 [Note] A temporary password is generated for root@localhost: 1Z>qq%pFim:!
```
### 彻底卸载mysql5.6
```bash
rpm -qa|grep mysql | xargs yum remove -y
rm -f /etc/my.cnf
whereis mysql | xargs rm -rf # 删除剩余的文件
rm -rf /var/lib/mysql # 如果这个目录如果不删除，再重新安装之后，密码还是之前的密码，不会重新初始化！
```


### 字符编码
1. 更改字符集编码
    vi /etc/my.cnf
    1. 在[mysqld]下添加：
    default-storage-engine=INNODB
    character-set-server=utf8
    collation-server=utf8_general_ci

    2. 在[mysql]下添加
    default-character-set=utf8

2. 查看字符集的配置
    - 查看Mysql的字符集
        - show variables like "%character%";
        - show variables like "%collation%";
    - 查看database字符集
        - show create database 数据库名;
    - 查看table的字符集
        - show create table 数据表名;
    - 查看字段编码
        - show full columns from 表名;

3. 更改已存在的表的字符集
alter 表名  convert to character set utf8mb4 collate utf8mb4_bin;
## SQL增删改查
### 简单SQL 
```sql
create database test;
use test;
-- create table
create table if not exists `user_tb` (`user_id` int unsigned auto_increment , `user_name` varchar(40) not null, primary key ( `user_id` )) engine=InnoDB default charset=utf8;
-- delete table
drop table tablename;

-- add data
insert into user_tb (user_name) values('gary');

-- delete data
delete from user_tb where id = 1;

--update data
update user_tb set user_name = 'adam' where user_name = 'gary';

-- select data
select user_id, user_name from user_tb limit 10;
select * from user_tb where user_name like  "%gary%" limit 1;

-- 排序
sql语句 order by 字段名 desc desc limit 5;
```
### 复杂SQL
### 事务
1. 全局开启事务模式
SET AUTOCOMMIT=0 禁止自动提交

2. 显式地开启一个事务
```sql
BEGIN -- 或 START TRANSACTION 显式地开启一个事务
-- 执行sql语句
SAVEPOINT identifier
-- 执行sql语句
ROLLBACK TO identifier 
COMMIT -- 或 ROLLBACK
```
### 存储过程

## 运维基本操作 
### information_schema数据库
- 保存了MySQL服务器所有数据库相关的信息。

### 基础
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
create database ${DATABASE} charset 'utf8mb4';

### 登入&执行sql&查询导出数据
- 参考  
https://www.cnblogs.com/zengkefu/p/5690092.html

1. 登入
    1. mysql --login-path=backup
        - login-path是MySQL5.6开始支持的新特性。通过借助mysql_config_editor工具将登陆MySQL服务的认证信息加密保存在.mylogin.cnf文件(默认位于用户主目录)。之后，MySQL客户端工具可通过读取该加密文件连接MySQL，避免重复输入登录信息，避免敏感信息暴露。

    2. mysql -u${USER} -p${PASSWORD} -P${PORT} -h${HOST} -S ${SOCKPATH} -D${DATABASE}
        - 参数
            -S 是指定mysql.sock
            -D 指定要连接的数据库
            -e "" 指定要执行的sql语句

2. 线上导出数据
```bash
time mysqldump --skip-add-locks --single-transaction --default-character-set=utf8mb4 --set-gtid-purged=off  -h${host} -u${user} -p${pass}  ${database} ${table} > ${table}.sql

# -t  只导出数据

# -d 只导出表结构

# --add-locks，这是导出时的默认值，意思是导出某张表时，会在该表上加个锁，导出完成后执行unlock，如果导出过程中表数据有变动（增删改），对应的sql就会被挂起，直到unlock之后才能继续执行，这样执行导出会更高效！但是，如果导出的表，数据量比较大，会导致导出表的时间比较长，而如果业务操作表又比较频繁的话，默认加锁的操作就造成大量业务sql堵塞，影响实际业务运行，不能因为要高效而抛弃了实际业务，这个时候就要用--skip-add-locks跳过加锁模块

# --single-transaction参数的作用，设置事务的隔离级别为可重复读，即REPEATABLE READ，这样能保证在一个事务中所有相同的查询读取到同样的数据，也就大概保证了在dump期间，如果其他innodb引擎的线程修改了表的数据并提交，对该dump线程的数据并无影响，在这期间不会锁表。

# --opt Same as --add-drop-table, --add-locks, --create-options,   --quick, --extended-insert, --lock-tables, --set-charset, and --disable-keys. Enabled by default, disable with  --skip-opt 
```

```log
// 2g数据耗时
real	0m38.495s
user	0m35.658s
sys	    0m2.261s
```
4. 执行sql文件
mysql -u${USER} -p${PASSWORD} -P${PORT} -h${HOST} -S ${SOCKPATH} -D${DATABASE} < sql.sql

5. 导出查询到的数据
mysql --login-path=aa ${sql脚本} data.txt  
mysql --login-path=aa -e "${sql语句}" > data.txt

6. 导出为csv文件
sql语句 into outfile '/tmp/table.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\r\n';


### binlog日志
- 参考  
https://www.jianshu.com/p/b0cf461451fb  
- 功能：记录用户对数据库操作的SQL语句（(除了数据查询语句）信息。
1. 配置启动binlog日志
```conf
log-bin=mysql-bin
binlog_format=mixed
server-id   = 1
expire_logs_days = 10  # 0 表示永不过期
```

2. 
```sql
-- 查看默认设置的binlog过期时间
show variables like "%expire_logs%";

-- 临时设置binlog保留时间
set global expire_logs_days=15

-- 查看数据库是否开启binlog日志
show variables like '%log_bin%';

-- 查看binlog文件
show binary logs;

-- 清理binlog日志
purge master logs to 'binlognumber';
```

4. 用mysql自身自带的工具，提取出binlog日志进行分析
    ```bash
    host=127.0.0.1
    user=root
    start_datetime="2021-05-27 10:00:00" # 开始时间
    stop-datetime="2021-05-27 10:30:00" # 结束时间
    binlogfile="mysql-binlog.191250" # 从哪个binlog文件开始提取
    result_file=='mysql-binlog' # 保存结果进文件

    mysqlbinlog --read-from-remote-server  --host=${host} --port=3306 --user ${user} --password  --base64-output=decode-rows -v --start-datetime=${start_datetime} --stop-datetime=${stop-datetime} --stop-never  --result-file=${result_file} ${binlogfile}
    
    # --database=数据库名  指定数据库名
    # --base64-output=decode-rows  binglog格式为row时，进行解码
    ```

### 开启主从同步
- 参考  
https://www.jianshu.com/p/b0cf461451fb  
https://dev.mysql.com/doc/refman/5.7/en/start-slave.html

1. MySQL主从同步的作用：
    1. 可以作为备份机制，相当于热备份
    2. 可以用来做读写分离，均衡数据库负载

2. 在主服务器上配置主从
```conf
#主数据库端ID号
server_id = 1           
#开启二进制日志                  
log-bin = mysql-bin    
#需要复制的数据库名，如果复制多个数据库，重复设置这个选项即可                  
binlog-do-db = db  
#需要忽略的数据库
binlog-ignore-db = db      
#设置将从服务器从主服务器收到的更新记入到从服务器自己的二进制日志文件中                 
log-slave-updates                        
#控制binlog的写入频率。每执行多少次事务写入一次(这个参数性能消耗很大，但可减小MySQL崩溃造成的损失) 
sync_binlog = 1     
#二进制日志自动删除的天数，默认值为0,表示“没有自动删除”，启动时和二进制日志循环时可能删除  
expire_logs_days = 7                    
#将函数复制到slave  
log_bin_trust_function_creators = 1     

#这个参数一般用在主主同步中，用来错开自增值, 防止键值冲突
# auto_increment_offset = 1           
#这个参数一般用在主主同步中，用来错开自增值, 防止键值冲突
# auto_increment_increment = 1     
```

3. 在从服务器上配置
```conf
server_id = 2
log-bin = mysql-bin
log-slave-updates
sync_binlog = 0
#log buffer将每秒一次地写入log file中，并且log file的flush(刷到磁盘)操作同时进行。该模式下在事务提交的时候，不会主动触发写入磁盘的操作
innodb_flush_log_at_trx_commit = 0        
#指定slave要复制哪个库
replicate-do-db = db         
#MySQL主从复制的时候，当Master和Slave之间的网络中断，但是Master和Slave无法察觉的情况下（比如防火墙或者路由问题）。Slave会等待slave_net_timeout设置的秒数后，才能认为网络出现故障，然后才会重连并且追赶这段时间主库的数据
slave-net-timeout = 60                    
log_bin_trust_function_creators = 1
```

3. 创建允许从服务器同步数据的账户
```sql
grant replication slave on *.* to 'USER'@'IP' identified by 'PASSWORD';
flush privileges;
```
4. 设置连接到master主服务器 
```sql
-- 主 上进行操作，获取master_log_file 和 master_log_pos
show master status;
-- 从 上进行操作
change master to master_host='IP', master_user='slave', master_password='slave',master_log_file='mysql-bin.000001', master_log_pos=590;

```

4. 启停主从
stop slave;
start slave;

5. 查看主从状态
show slave status\G;
- Slave_IO_Running和Slave_SQL_Runing两个参数YES，则表示主从复制关系正常。

6. 主从中断
```sql
-- InnoDB事务在放弃前等待行锁的时间（秒）。innodb_lock_wait_timeout默认值为50秒。当有试图访问被另一行锁定的行的事务InnoDB事务在发出以下错误：
-- ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction
show variables like '%innodb_lock_wait_timeout%';
-- 参数slave_transaction_retries 设置的为10次，如果事务重试次数超过10次，复制中断。
show variables like '%slave_transaction_retries%';
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

### 数据库和表的大小

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

### 慢日志
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

### MySQL缓存
- 参考  
https://blog.csdn.net/zdw19861127/article/details/84937562

- 机制： 缓存SELECT操作 或 预处理查询（5.1.17开始支持）的结果集和SQL语句

1.  查看是否开启了缓存
    ```sql
    show variables like '%query%';
    ```
    1. query_cache_type 和 query_cache_size -- 都不为0表示开启了查询缓存功能。
    2. query_cache_type  
        1(ON)： 启用查询缓存，只要符合查询缓存的要求，客户端的查询语句和记录集斗可以 缓存起来，共其他客户端使用；
        2(DEMAND):  启用查询缓存，只要查询语句中添加了参数：sql_cache，且符合查询缓存的要求，客户端的查询语句和记录集，则可以缓存起来，共其他客户端使用；

2. 查看缓存的具体状态
    show global status like 'QCache%';

3. 查询缓存会生成碎片，通过下面命令来清理碎片
    flush query cache;
    清理内存中的碎片：
    reset query cache
    两个命令同时使用，彻底清理碎片。


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
    ```
8. 删除用户及权限
    ```sql
    delete from mysql.user where User='dbusername' and Host='localhost';
    flush privileges; -- 刷新权限

    drop user dbusername@'%'; -- 删除账户及权限
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

### 高cpu的sql
```bash
top -H -p <mysqld进程id>
```

## DBA
- DBA日常工作 -- 排查性能问题

- 工具
pt-query-digest 工具是包含在Percona toolkit里的. 相关安装方式可以参考 https://www.percona.com/doc/percona-toolkit/LATEST/installation.html

- 显示内部信息
show engine innodb status

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

-  

- 排查
```sql
-- 参考 https://aws.amazon.com/cn/premiumsupport/knowledge-center/blocked-mysql-query/
-- 参考 https://www.cnblogs.com/luyucheng/p/6297752.html

-- 查看表活跃情况
show OPEN TABLES where In_use > 0;
-- In_use  表示有多少线程正在使用某张表

-- 查看未提交的事务。
-- 如果数据库存在锁，则在trx_query列中有值的即为锁住表的sql语句 或者 trx_state字段值不是“running”
select trx_query,trx_state from information_schema.innodb_trx where trx_state != "RUNNING";
select trx_state, trx_started, trx_mysql_thread_id, trx_query from information_schema.innodb_trx\G
-- select * from information_schema.innodb_trx\G 

-- 查看当前锁定的事务
select * from information_schema.innodb_locks;

-- 查看当前等锁的事务
select * from sys.innodb_lock_waits limit 10\G
select * from sys.innodb_lock_waits order by wait_age_secs desc limit 10\G

-- 查看当前用户连接数
select USER , count(*) as num from information_schema.processlist group by USER order by num desc limit 10;

-- 查看当前连接中各个IP的连接数
select substring_index(host,':',1) as ip, count(*) as num from information_schema.processlist group by ip order by num desc limit 10;
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

## 问题
1. slow slave status \G
Slave_SQL_Running_State: System lock


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