---
created_date: 2021-08-05
---

[TOC]

# SQL

## SQL语句

### SQL语句分类

1. DDL 数据定义语言，用来定义数据库对象：库、表、列
   - 代表性关键字：create alter drop
2. DML 数据操作语言，用来定义数据库记录
   - 代表性关键字:insert delete update
3. DCL 数据控制语言，用来定义访问权限和安全级别
   - 代表性关键字:grant deny revoke
4. DQL 数据查询语言，用来查询记录数据
   - 代表性关键字:select

### 简单SQL

```sql
create database test default character set=utf8mb4;
use test;
-- create table
create table if not exists `gary_user_tb` (`user_id` int unsigned auto_increment , `user_name` varchar(40) not null, primary key ( `user_id` )) comment '表的注释' engine=InnoDB default charset=utf8;
-- delete table
drop table gary_user_tb;


-- add data
insert into gary_user_tb (user_name) values('gary');

-- delete data
delete from gary_user_tb where id = 1;

--update data
update gary_user_tb set user_name = 'adam' where user_name = 'gary';

-- select data
select user_id, user_name from gary_user_tb limit 10;
select * from gary_user_tb where user_name like  "%gary%" limit 1;

-- 排序 默认asc 升序
sql语句 order by 字段名 desc limit 5;
```

### 进阶SQL

```sql
-- 将查询的结果插入表中
insert into gary_user_tb(user_name) select user_name from gary_user_tb where user_id=1;

-- 显式加 S 锁
select ... lock in share mode;
-- 显式加 X 锁 
select ... for update;
```

### 事务

1. 禁止事务自动提交

```sql
SET AUTOCOMMIT=0 
```

2. 显式地开启一个事务

```sql
BEGIN; -- 或 START TRANSACTION 显式地开启一个事务
-- 执行sql语句;
SAVEPOINT identifier;
-- 执行sql语句;
ROLLBACK TO identifier;
COMMIT; -- 或 ROLLBACK
```

### 多表查询

- 连表查

```sql
-- 1. 交叉连接，生成笛卡尔积 
select * from table_A, table_B where table_A.字段=table_B.字段;

-- 2. 内连接 
select * from table_A inner join table_B on table_A.字段=table_B.字段;
-- 3. 左外连接 
select * from table_A left join table_B on table_A.字段=table_B.字段;
-- 4. 全外连接 
select * from table_A left join table_B on table_A.字段=table_B.字段 union select * from table_A right join table_B on table_A.字段=table_B.字段;
```

- 子查询

```sql
select name from table_B where id = (select id from table_A where 字段 = '');

select name from table_B where id not in (select id from table_A where 字段 = '' or 字段 = '');
```

- 联合查询

```sql
-- 可以将不同表中符合条件的数据信息显示在同一列中
-- 在每个查询表中，对应列的数据结构必须一样
select * from table_A union select * from table_A;
```

## 存储过程

## 注意事项

- timestamp
  - CURRENT_TIMESTAMP 当要向数据库执行insert操作时，无论这个字段有没有set值，都插入当前系统时间
  - ON UPDATE CURRENT_TIMESTAMP 当执行update操作时，无论这个字段值有没有变化，它的值都会更新为当前UPDATE操作时的时间。
  - NULL
