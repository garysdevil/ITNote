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

设置免密
/usr/bin/mysqladmin -u root password 'new-password'
```conf /etc/my.cnf
# 跳过密码验证
--skip-grant-tables 
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
show variables like "%character%";
show variables like "%collation%";

## SQL增删改查

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

4. 中止应用线程
- 一般出现长时间的select可以考虑kill掉，但是update或者delete不建议kill
kill id

5. 查看索引
show indexes from 表名;
show keys from 表名;

6. 查看参数修改参数
show variables;
show variables like “参数名称“

set global variablesname=''（全局）
set variablesname=''（当前session）

7. 查询是否锁表
show OPEN TABLES where In_use > 0;

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

### 登入&查询导出数据
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

2. 导出表结构和数据
mysqldump　--opt　-d　数据库名　-u　root　-p　>　xxx.sql　
-t  只导出数据

3. 执行sql文件
mysql -u${USER} -p${PASSWORD} -P${PORT} -h${HOST} -S ${SOCKPATH} -D${DATABASE} < sql.sql

4. 导出查询到的数据
mysql --login-path=aa ${sql脚本} data.txt  
mysql --login-path=aa -e "${sql语句}" > data.txt

5. 导出为csv文件
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
expire_logs_days = 10
```
2. 查看数据库是否开启binlog日志
    show variables like '%log_bin%';
3. 清理binlog日志
    purge master logs to 'binlognumber';
4. 用mysql自身自带的工具，提取出binlog日志进行分析
mysqlbinlog --base64-output=decode-rows -v --start-datetime="2020--07-24 09:00:00" --stop-datetime="2020--07-24 10:00:00" --database=数据库名 mysql-mysql-bin.000016
--base64-output=decode-rows  binglog格式为row时，进行解码


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

4. 启停主从
stop slave;
start slave;

5. 查看主从状态
show slave status\G;
- Slave_IO_Running和Slave_SQL_Runing两个参数YES，则表示主从复制关系正常。


### 查看 Mysql 连接数、状态、最大并发数
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

5.  查看应用连接
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
    ```


### 数据库和表的大小
- 参考  
https://www.cnblogs.com/--smile/p/11451238.html  

```sql
-- 查看整个mysql的数据容量大小
select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data from information_schema.tables;
SELECT sum(DATA_LENGTH+INDEX_LENGTH) FROM information_schema.tables WHERE TABLE_SCHEMA="数据库名";

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
set @schema_name="数据库名称";
select
table_name as 'table_name',
sum(table_rows) as 'table_rows',
sum(truncate(data_length/1024/1024, 2)) as 'data volumes(MB)',
sum(truncate(index_length/1024/1024, 2)) as 'index volumes(MB)'
from information_schema.tables where TABLE_SCHEMA=@schema_name
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
show grants for username@'%';
show grants for username@'localhost';
2. 查看当前用户
select user();

3. 查看所有的用户
SELECT HOST,USER FROM mysql.user;
SELECT DISTINCT CONCAT('User: ''',user,'''@''',host,''';') AS query FROM mysql.user;

4. 增加管理员并且拥有授权权限
grant all privileges on *.*  to dbuser@'%' identified by 'password'  with grant option;
flush privileges;

5. 增加应用用户
grant select,insert,update,delete on dbname.* to dbuser@'%' identified by 'password';
或某个数据库所有权 grant all on *.* to dbuser@'%' indentified by 'password';
flush privileges;

6. 撤销权限
grant all privileges on *.*  from dbuser@'%'

7. 改用户密码
set password for root@localhost = password('123');

10. 权限与用户
```bash
#创建用户
create user username@localhost identified by 'password';
insert into mysql.user(Host,User,Password) values("localhost","test",password("1234"));
create user username@localhost identified by 'password' password expire;

# 授予用户的权限：全局层级权限、数据库层级权限、表层级别权限、列层级别权限、子程序层级权限。
全局层级权限:这些权限存储在mysql.user表中。GRANT ALL ON *.*和REVOKE ALL ON *.*只授予和撤销全局权限。
数据库层级权限:这些权限存储在mysql.db和mysql.host表中。GRANT ALL ON db_name.*和REVOKE ALL ON db_name.*只授予和撤销数据库权限。
表层级别权限:这些权限存储在mysql.tables_priv表中。GRANT ALL ON db_name.tbl_name和REVOKE ALL ON db_name.tbl_name只授予和撤销表权限。
列层级别权限:这些权限存储在mysql.columns_priv表中。当使用REVOKE时，您必须指定与被授权列相同的列
子程序层级权限(存储过程):存储在mysql.procs_priv表

flush privileges;
```