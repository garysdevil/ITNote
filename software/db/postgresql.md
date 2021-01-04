## Postgresql
- 安装参考文档 https://www.postgresql.org/
### 安装
##### ubuntu安装
1. 安装
```bash
# https://www.postgresql.org/download/linux/ubuntu/
echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list # ubuntu16

echo  'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main'  >> /etc/apt/sources.list.d/pgdg.list # ubuntu18
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update

apt-get install postgresql-10
apt-get install libpq-dev

```
2. 安装完后
    - 生成一个服务 systemctl status postgresql
    - 生成一个用户 postgres
    - server进程： /usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf
    - 默认配置 远程Ip不能访问
    - 默认会有三个数据库 postgres template1 template2
    - 默认端口 5432

4. 更改数据库目录步骤 
    - 初始化数据库 
        mkdir /data/postgresql; chown postgres.postgres /data/postgresql
        su - postgres
        /usr/lib/postgresql/10/bin/initdb -D /data/postgresql/
    - 更改配置文件/etc/postgresql/10/main/postgresql.conf文件。

5. 进入数据库
```bash
sudo -i -u postgres
psql -h IP地址 -p 端口 -d 数据库名 -U 用户名 -W 密码

psql -h 127.0.0.1 -p 5432 -d eth -U eth
```

6. 数据库配置文件    /etc/postgresql/10/main/pg_hba.conf

7. 彻底删除postgres https://www.cnblogs.com/jimlee027/p/6276723.html
### 概念
1. 模式 Schema
    - 可以看着是一个表的集合。
    - 一个模式可以包含视图、索引、据类型、函数和操作符等。
### 基本操作
1. 
show data_directory;

2. 权限
    - 用户与数据库
    ```sql
    CREATE USER pg_user WITH PASSWORD '*****';
    CREATE DATABASE db_name OWNER pg_user;
    GRANT ALL PRIVILEGES ON DATABASE db_name TO pg_user;
    ```

    - 用户与表
    ```sql
    ALTER TABLE table_name OWNER TO pg_user;
    ```
    
    - 用户角色密码
    ```sql
    SELECT * FROM pg_roles;
    SELECT * FROM pg_user;
    ALTER USER user_name WITH PASSWORD 'password';
    ```

3. 常规操作
    1. 列举数据库：\l
    2. 切换数据库：\c 数据库名
    2. 切换用户 \c - 用户名
    3. 查看该某个库中的所有表：\dt
    4. 切换数据库：\c interface
    5. 查看某个库中的某个表结构：\d 表名
    6. 查看某个库中某个表的记录：select * from apps limit 1;
    7. 显示字符集：\encoding
    8. 退出psgl：\q
    9. 格式化输出： \x 

4. 添加索引
```sql
CREATE INDEX 索引名
    ON public.表名 USING btree
    (字段名 COLLATE pg_catalog."default")
    TABLESPACE pg_default;
```

5. sql
    1. 清空表格 TRUNCATE ${tablename} RESTART IDENTITY;
## Postgrest
- 参考文档 https://postgrest.org/en/v7.0.0/install.html
- 基于PostgreSQL数据库，实现条件查询和访问性控制，提供RESTful API 的稳定WEB服务。
    - 数据库结构和约束决定API的端点和操作。 
    - PostgREST可以替代手动的CRUD开发。

### 安装配置Postgrest
curl -O https://github.com/PostgREST/postgrest/releases/download/v7.0.0/postgrest-v7.0.0-ubuntu.tar.xz
xz -d postgrest-v7.0.0-ubuntu.tar.xz
或者 tar -xvJf postgrest-v7.0.0-ubuntu.tar.xz
```conf vim postgrest.conf
db-uri = "postgres://eth:eth@127.0.0.1:5432/eth"
db-schema = "public"
db-anon-role = "eth"
db-pool = 10
server-host = "0.0.0.0"
server-port = 3000
```

```conf
# /lib/systemd/system/postgrest.service
[Unit]
Description=postgrest
After=postgresql.service
[Service]
User=platon
Group=platon
ExecStart=/bin/bash -c '/data/postgrest/postgrest /data/postgrest/postgrest.conf >> /data/postgrest/log.txt 2>&1'
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
RestartSec=5
StartLimitInterval=0
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target

```
./postgrest postgrest.conf

### API
```bash
tablename=ethtxs
curl http://localhost:3000/${tablename}?limit=10 #获取前10条数据
curl http://localhost:3000/${tablename}?limit=10&offset=30 #分页
curl http://localhost:3000/${tablename}?limit=10&order=height.desc #倒序
curl http://localhost:3000/${tablename}?limit=10&select=height #只获取height字段
curl http://localhost:3000/${tablename}?limit=10&select=height,hash&id.gte.99999 # 获取id>99999的数据
```