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
## 运维基本操作 

1. 在sql语句最后面添加\G，可以格式化输出结果。

3. 中止应用线程
- 一般出现长时间的select可以考虑kill掉，但是update或者delete不建议kill
kill id

4. 查看索引
show indexes from表名;
show keys from表名;

5. 查看参数修改参数
show variables;
show variables like “参数名称“

set global variablesname=''（全局）
set variablesname=''（当前session）

6. 查看主从状态
show slave status\G;
- Slave_IO_Running和Slave_SQL_Runing两个参数YES，则表示复制关系正常。

7. 启停主从
stop slave;
start slave;

8. binlog日志
    - 记录用户对数据库操作的SQL语句（(除了数据查询语句）信息
    ```conf
    log-bin=mysql-bin
    binlog_format=mixed
    server-id   = 1
    expire_logs_days = 10
    ```
    - 查看数据库是否开启binlog日志
        show variables like '%log_bin%';
    - 清理binlog日志
        purge master logs to 'binlognumber';
    - 用mysql自身自带的工具，提取出binlog日志进行分析
        mysqlbinlog --base64-output=decode-rows -v --start-datetime="2020--07-24 09:00:00" --stop-datetime="2020--07-24 10:00:00" --database=数据库名 mysql-mysql-bin.000016
        - --base64-output=decode-rows 是在你的binglog格式为row时，进行解码
9. 登陆
    - mysql --login-path=backup
    - login-path是MySQL5.6开始支持的新特性。通过借助mysql_config_editor工具将登陆MySQL服务的认证信息加密保存在.mylogin.cnf文件（默认位于用户主目录） 。之后，MySQL客户端工具可通过读取该加密文件连接MySQL，避免重复输入登录信息，避免敏感信息暴露。

    - mysql -uXXX -pXXX -PXXX -hXXX -S XXX -D XXX
    - 参数
        -S是指定mysql.sock
        -D 指定要连接的数据库
        -e "" 指定要执行的sql语句

10. 查看 Mysql 连接数、状态、最大并发数
    - 连接数限制 
        show variables like '%connections%';
    - 历史上最大连接数 
        show global status like 'max_used_connections';
    - 重新设置 
        set global max_connections=1000 
    - 连接数
        show status like 'Threads%';
        参数说明：
        Threads_cached  34 ##mysql管理的线程池中还有多少可以被复用的资源
        Threads_connected 32 ##打开的连接数
        Threads_created 66 ##代表新创建的thread（根据官方文档，如果thread_created增大迅速，需要适当调高 thread_cache_size）。
        Threads_running 2 ##激活的连接数，这个数值一般远低于connected数值，准确的来说，Threads_running是代表当前并发数
        show variables like '%max_connections%'; ##查询数据库当前设置的最大连接数
     - 查看应用连接
        - 当前的连接信息都保存在这张表格里 information_schema.processlist
        show processlist;
        show full processlist;
        ```yaml
        id: 为连接的应用id号
        User: 为连接数据库的用户
        Host: 为连接数据的主机IP地址和端口
        db: 为连接访问的数据库
        Command: 为当前正在执行的SQL语句类型，分为Query，Update，Updating等
        Time: 为应用的Sleep时间
        State: 为当前连接的状态，共包括Copying to tmp table on disk，Flushing tables，Sending data等二十多种状态。
        Info: 为当前应用连接执行的SQL语句，如果语句过长，可能会显示不完整。
        ```
11. 执行sql文件
    mysql -uXXX -pXXX -PXXX -hXXX -S XXX -Dtest < /home/zj/create_table.sql

12. 数据库和表的大小
    - https://www.cnblogs.com/--smile/p/11451238.html
    - information_schema 数据库：存放了其他的数据库的信息
```sql
# 查询
select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data from TABLES;

# 查看所有数据库各容量大小
select
table_schema as '数据库',
sum(table_rows) as '记录数',
sum(truncate(data_length/1024/1024, 2)) as '数据容量(MB)',
sum(truncate(index_length/1024/1024, 2)) as '索引容量(MB)'
from information_schema.tables
group by table_schema
order by sum(data_length) desc, sum(index_length) desc;
```

13. 查询是否锁表
show OPEN TABLES where In_use > 0;

14. 
show table status; -- 显示当前使用或者指定的database中的每个表的信息。信息包括表类型和表的最新更新时间。

show warnings; -- 显示最后一个执行的语句所产生的错误、警告和通知。

15. 查看表格的详细信息 -- 显结构，字段类型，主键，是否为bai空等属性，但不显示外键。
select * from information_schema.columns where table_schema = '数据库名' and table_name = '表名' and COLUMN_NAME='列名'\G;

16. 设置密码规则复杂度为0  5.7
set global validate_password_policy=0;
set global validate_password_length=1;

### 慢日志
1. 临时配置
```bash
show variables like 'slow_query%';
show variables like 'long_query_time';

set global slow_query_log='ON'; 

set global slow_query_log_file='/tmp/garyslow.log'; #linux
set global slow_query_log_file='D:\\mysq\data\slow.log';   #windows

set global long_query_time=1; # 耗时多少秒为慢查询
``` 
2. 永久配置
```conf
[mysqld]
slow_query_log = ON
slow_query_log_file = /usr/local/mysql/data/slow.log # linux
long_query_time = 1
```
### MySQL缓存
- https://blog.csdn.net/zdw19861127/article/details/84937562

- 查询缓存的工作原理，基本上可以概括为： 缓存SELECT操作或预处理查询（注释：5.1.17开始支持）的结果集和SQL语句

-  查看是否开启了缓存：
    show variables like '%query%';
    query_cache_type和query_cache_size都不为0表示开启了查询缓存功能。
    1. query_cache_type
        1(ON)： 启用查询缓存，只要符合查询缓存的要求，客户端的查询语句和记录集斗可以 缓存起来，共其他客户端使用；
        2(DEMAND):  启用查询缓存，只要查询语句中添加了参数：sql_cache，且符合查询缓存的要求，客户端的查询语句和记录集，则可以缓存起来，共其他客户端使用；

- 查看缓存的具体状态
    show global status like 'QCache%';

- 查询缓存会生成碎片，通过下面命令来清理碎片
    flush query cache;
    清理内存中的碎片：
    reset query cache
    两个命令同时使用，彻底清理碎片。

### 备份&查询导出数据
https://www.cnblogs.com/zengkefu/p/5690092.html

1. 
mysqldump　--opt　-d　数据库名　-u　root　-p　>　xxx.sql　
-t  只导出数据

2. 导出查询到的数据
mysql --login-path=aa < sql脚本 > data.txt
导出为csv文件
sql语句 into outfile '/tmp/table.csv' fields terminated by ',' optionally enclosed by '"' lines terminated by '\r\n';

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