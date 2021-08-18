## 安装
### 安装mysql5.6
- 参考 https://blog.csdn.net/pengjunlee/article/details/81212250

```bash
rpm -qa|grep -i mariadb | xargs rpm -e --nodeps
curl -O http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum repolist all | grep mysql 
rpm -qa | grep mysql
yum install mysql-server
# 启动
systemctl start mysql && systemctl status mysql
# 设置新密码
/usr/bin/mysqladmin -u root password 'new-password'
```

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
# 启动
systemctl start mysqld.service
systemctl status mysqld.service
systemctl enable mysqld
```

```txt
非互联网状态下
安装MySql57
mysql-community-client-5.7.30-1.el7.x86_64
mysql-community-libs-compat-5.7.30-1.el7.x86_64
mysql57-community-release-el7-10.noarch
mysql-community-server-5.7.30-1.el7.x86_64
mysql-community-common-5.7.30-1.el7.x86_64
```

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

### 配置
- Mysql配置从上到下优先级降低
    - /etc/my.cnf
    - /etc/mysql/my.cnf
    - /usr/local/etc/my.cnf
    - ~/.my.cnf

#### 字符集编码配置
1. 更改字符集编码
- vi /etc/my.cnf
```conf
# 在[mysqld]下添加：
default-storage-engine=INNODB
character-set-server=utf8
collation-server=utf8_general_ci

# 在[mysql]下添加
default-character-set=utf8
```

2. 查看字符集的配置
```sql
-- 查看Mysql的字符集
    show variables like "%character%";
    show variables like "%collation%";
-- 查看database字符集
    show create database 数据库名;
-- 查看table的字符集
    show create table 数据表名;
-- 查看字段编码
    show full columns from 表名;
```

3. 更改字符集
```sql
alter database 库名 character set utf8mb4;

alter 表名  convert to character set utf8mb4 collate utf8mb4_bin;
```


## 配置主从同步
- 参考  
    - https://www.jianshu.com/p/b0cf461451fb  
    - https://dev.mysql.com/doc/refman/5.7/en/start-slave.html

- MySQL主从同步的作用：
    1. 可以作为备份机制，相当于热备份
    2. 可以用来做读写分离，均衡数据库负载

1. 在主数据库上启动binlog日志
    ```conf
    #主数据库端ID号 # 必须配置否则mysql会启动失败
    server_id = 1     
    #开启二进制日志，配置二进制日志所在路径
    log-bin = mysql-bin
    #二进制日志自动删除的天数，默认值为0,表示“没有自动删除”，启动时和二进制日志循环时可能删除  
    expire_logs_days = 7
    #需要复制的数据库名，如果复制多个数据库，重复设置这个选项即可                  
    binlog-do-db = ${db}
    #需要忽略的数据库
    binlog-ignore-db = ${db}
    #设置将从服务器从主服务器收到的更新记入到从服务器自己的二进制日志文件中                 
    log-slave-updates       
    #控制binlog的写入频率。每执行多少次事务写入一次(这个参数性能消耗很大，但可减小MySQL崩溃造成的损失) 
    sync_binlog = 1  
    #将函数复制到slave  
    log_bin_trust_function_creators = 1  

    #这个参数一般用在主主同步中，用来错开自增值, 防止键值冲突
    # auto_increment_offset = 1
    #这个参数一般用在主主同步中，用来错开自增值, 防止键值冲突
    # auto_increment_increment = 1

    # binlog_format = row # MySQL 5.7.7 之前，binlog 的默认格式都是 STATEMENT，在 5.7.7 及更高版本中，binlog_format 的默认值是 ROW
    # STATEMENT 模式:每一条会修改数据的sql语句会记录到binlog中 
    # ROW 模式:仅需记录哪条数据被修改了，修改成什么样了
    # MIXED 模式:以上两种模式的混合使用
    ```

2. 在从数据库上配置binlog
    ```conf
    server_id = 2
    log-bin = mysql-bin
    log-slave-updates
    sync_binlog = 0
    #log buffer将每秒一次地写入log file中，并且log file的flush(刷到磁盘)操作同时进行。该模式下在事务提交的时候，不会主动触发写入磁盘的操作
    innodb_flush_log_at_trx_commit = 0
    #指定slave要复制哪个库，如果复制多个数据库，重复设置这个选项即可
    replicate-do-db = ${db}
    #MySQL主从复制的时候，当Master和Slave之间的网络中断，但是Master和Slave无法察觉的情况下（比如防火墙或者路由问题）。Slave会等待slave_net_timeout设置的秒数后，才能认为网络出现故障，然后才会重连并且追赶这段时间主库的数据
    slave-net-timeout = 60
    log_bin_trust_function_creators = 1
    ```

3. 在master数据库上创建允许slave数据库同步数据的账户
    ```sql
    grant replication slave on *.* to 'USER'@'IP' identified by 'PASSWORD';
    flush privileges;
    ```

4. 在slave数据库上进行配置
    ```sql
    -- master数据库上进行操作，获取master_log_file 和 master_log_pos
    show master status;

    -- slave数据库上进行操作，设置slave连接到master数据库 
    change master to master_host='IP', master_user='slave', master_password='slave',master_log_file='mysql-bin.000001', master_log_pos=590;
    -- slave数据库上进行操作，设置从库只读,防止意外写入，造成同步数据产生冲突，停止同步。
    set global read_only=1;
    ```

5. slave数据库启停主从
    ```sql
    stop slave;
    start slave;
    ```

6. slave数据库查看主从状态
    ```sql
    -- Slave_IO_Running和Slave_SQL_Runing两个参数YES，则表示主从复制关系正常。
    show slave status\G;
    ```