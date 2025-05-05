---
created_date: 2020-11-16
---

[TOC]

- PostgreSQL

## 相关链接

- https://www.postgresql.org/
- https://www.postgresql.org/about/press/presskit12/zh/

## 安装

### 版本2021

| Version | Current minor | Supported | First Release | Final Release |
| ------- | ------------- | --------- | ------------------ | ----------------- |
| 14 | 14.4 | Yes | September 30, 2021 | November 12, 2026 |
| 13 | 13.7 | Yes | September 24, 2020 | November 13, 2025 |
| 12 | 12.11 | Yes | October 3, 2019 | November 14, 2024 |
| 11 | 11.16 | Yes | October 18, 2018 | November 9, 2023 |
| 10 | 10.21 | Yes | October 5, 2017 | November 10, 2022 |

### 安装

1. Ubuntu安装

```bash
# https://www.postgresql.org/download/linux/ubuntu/
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update

apt-get install postgresql-12 -y
apt-get install libpq-dev -y
```

2. 安装完后

   - 生成一个服务 systemctl status postgresql
   - 生成一个用户 postgres
   - server进程： /usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf
   - 默认配置 远程Ip不能访问
   - 默认会有三个数据库 postgres template1 template2
   - 默认端口 5432

3. 更改数据库目录步骤

   - 初始化数据库
     mkdir /data/postgresql; chown postgres.postgres /data/postgresql
     su - postgres
     /usr/lib/postgresql/12/bin/initdb -D /data/postgresql/
   - 更改配置文件 /etc/postgresql/12/main/postgresql.conf 文件字段 data_directory 。
   - root权限下重启服务 systemctl restart postgresql

4. Centos7安装

```bash
sudo su -
yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum install -y postgresql14-server
/usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl enable postgresql-14
systemctl start postgresql-14
```

5. 登入数据库

```bash
# 方式一 本地登入
su - postgres
psql
# 方式二 远程登入
psql -h IP地址 -p 端口 -d 数据库名 -U 用户名 -W 密码
psql -h 127.0.0.1 -p 5432 -d eth -U eth
```

6. 数据库配置文件 /etc/postgresql/12/main/pg_hba.conf

7. 彻底删除postgres https://www.cnblogs.com/jimlee027/p/6276723.html

## 语法

### 概念

1. 数据库 database
2. 模式 Schema
   - 可以看着是一个表的集合。
   - 一个模式可以包含视图、索引、据类型、函数和操作符等。
3. 表 table

### 常规操作

01. 列举数据库： \\l
02. 切换数据库： \\c 数据库名
03. 列出用户： \\du
04. 切换用户： \\c - 用户名
05. 获取当前连接数据库中可见的schema `\dn` 或 `select * from information_schema.schemata;`
06. 创建schema `create schema schema名字;`
07. 切换schema `set search_path to schema名字;`
08. 查看该当前库当前schema中的所有表： \\dt
09. 查看表结构： \\d 表名
10. 显示字符集： \\encoding
11. 退出psgl： \\q
12. 格式化输出： \\x
13. 执行sql文件： \\i /path/xxx.sql
14. 设置内部变量或者列出所有的变量 \\set

### SQL

#### 软件信息

1. 查看数据目录 `show data_directory;`
2. 查看服务版本 `select version();`

#### 权限

- 用户与数据库

```sql
CREATE USER pg_user WITH PASSWORD '*****';
CREATE DATABASE db_name OWNER pg_user;
GRANT ALL PRIVILEGES ON DATABASE db_name TO pg_user;
```

- 用户与表

```sql
create table table_name;
ALTER TABLE table_name OWNER TO pg_user;
```

- 用户角色密码

```sql
SELECT * FROM pg_roles;
SELECT * FROM pg_user;
ALTER USER user_name WITH PASSWORD 'password';
```

#### SQL

```sql
-- 创建表格
create table gary_user_tb (user_id int,  user_name varchar(40) not null, primary key ( user_id ));

-- 添加索引
CREATE INDEX 索引名
    ON public.表名 USING btree
    (字段名 COLLATE pg_catalog."default")
    TABLESPACE pg_default;


-- 清空表格
TRUNCATE ${tablename} RESTART IDENTITY;
```

## Postgrest

- 参考文档
  1. https://postgrest.org/en/v7.0.0/install.html
- 基于PostgreSQL数据库，实现条件查询和访问性控制，提供RESTful API 的稳定WEB服务。
  1. 数据库结构和约束决定API的端点和操作。
  2. PostgREST可以替代手动的CRUD开发。

### 安装

```bash
curl -O https://github.com/PostgREST/postgrest/releases/download/v7.0.0/postgrest-v7.0.0-ubuntu.tar.xz
xz -d postgrest-v7.0.0-ubuntu.tar.xz
# 或者 tar -xvJf postgrest-v7.0.0-ubuntu.tar.xz
```

### 配置启动

- 配置配置文件 vim postgrest.conf

```conf
db-uri = "postgres://eth:eth@127.0.0.1:5432/eth"
db-schema = "public"
db-anon-role = "eth"
db-pool = 10
server-host = "0.0.0.0"
server-port = 3000
```

- 配置服务 vim /lib/systemd/system/postgrest.service

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

- 启动

```
./postgrest postgrest.conf
```

### API

```bash
tablename=ethtxs
curl http://localhost:3000/${tablename}?limit=10 #获取前10条数据
curl http://localhost:3000/${tablename}?limit=10&offset=30 #分页
curl http://localhost:3000/${tablename}?limit=10&order=height.desc #倒序
curl http://localhost:3000/${tablename}?limit=10&select=height #只获取height字段
curl http://localhost:3000/${tablename}?limit=10&select=height,hash&id.gte.99999 # 获取id>99999的数据
```
