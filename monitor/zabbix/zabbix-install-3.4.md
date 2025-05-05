---
created_date: 2020-11-16
---

[TOC]

## centos安装zabbix服务
- zabbix服务由3个组件组成
    + 数据库
    + zabbix后端程序
    + zabbix-web

### 一 安装数据库mariadb
1. 安装
```bash
yum -y install mariadb mariadb-server 
# 安装mysql-server
# wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm  根据centos版本选择参数7-5。
# rpm -ivh mysql-community-release-el7-5.noarch.rpm
# yum install mysql-server

systemctl start mariadb

# Created symlink from /etc/systemd/system/multi-user.target.wants/mariadb.service to /usr/lib/systemd/system/mariadb.service
systemctl enable mariadb

# 设置密码
 mysqladmin -u root -h localhost password XXXXXX
```
2. 配置MariaDB的字符集
```bash
 vi /etc/my.cnf
 # 在[mysqld]标签下添加
init_connect='SET collation_connection = utf8_unicode_ci' 
init_connect='SET NAMES utf8' 
character-set-server=utf8 
collation-server=utf8_unicode_ci 
skip-character-set-client-handshake

vi /etc/my.cnf.d/client.cnf
# 在[client]中添加
default-character-set=utf8

vi /etc/my.cnf.d/mysql-clients.cnf
# 在[mysql]中添加
default-character-set=utf8

systemctl restart mariadb
systemctl status mariadb

# 查看字符集的配置
show variables like "%character%";
show variables like "%collation%";
```
### 二 安装zabbix后端程序
- 在centos7下安装zabbix-server3.4或zabbix-proxy3.4，使用mysql-mariadb数据库
- 官方教程： https://www.zabbix.com/documentation/3.4/manual/installation/install_from_packages/rhel_centos
#### 二.A 安装zabbix-server
- 在centos7下安装zabbix-server3.4或者zabbix-proxy3.4，使用mysql-mariadb数据库
- 官方教程： https://www.zabbix.com/documentation/3.4/manual/installation/install_from_packages/rhel_centos
```bash
# 1 创建zabbix用户和数据库
mysql -uroot -pXXXXXX -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -pXXXXXX -e "grant privileges on zabbix.* to zabbix@localhost identified by 'zabbix'; flush privileges;"

# 2 下载zabbix的yum包
rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

# 3 安装zabbix-server
yum install zabbix-server-mysql -y

# 4 导入数据表结构和数据进zabbix数据库
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix -D zabbix

# 5 修改zabbix-server的数据库配置，配置数据库的密码
sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf

# 6 配置zabbix-server跟随系统启动
systemctl enable zabbix-server

# 7 启动程序
systemctl start zabbix-server
systemctl status zabbix-server
```
#### 二.B 安装zabbix-proxy
```bash
# 1 创建zabbix用户和数据库
mysql -uroot -pXXXXXX -e "create database zabbix_proxy character set utf8 collate utf8_bin;"
mysql -uroot -pXXXXXX -e "grant privileges on zabbix_proxy.* to zabbix@localhost identified by 'zabbix'; flush privileges;"

# 2 下载zabbix的yum包
rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm

# 3 安装zabbix-proxy
yum install zabbix-proxy-mysql -y

# 4 导入数据表结构和数据进zabbix_proxy数据库
zcat /usr/share/doc/zabbix-proxy-mysql*/schema.sql.gz | mysql -uzabbix -pzabbix -D zabbix_proxy

# 5 修改zabbix-proxy的数据库配置，配置数据库的密码
sed -i 's/# DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_proxy.conf

# 6 配置zabbix-proxy跟随系统启动
systemctl enable zabbix-proxy

# 7 启动程序
ystemctl start zabbix-proxy
ystemctl status zabbix-proxy
```
### 三 安装zabbix-web 
1. 安装
```bash
# 1 安装
yum-config-manager --enable rhel-7-server-optional-rpms
# 如果 yum-config-manager: command not found 则 yum -y install yum-utils
yum install zabbix-web-mysql -y

# 2 配置zabbix-web的时区
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Hong_Kong/' /etc/httpd/conf.d/zabbix.conf
# zabbix-web的文字、字符编码配置文件
# /usr/share/zabbix/include/locales.inc.php

# 3 配置zabbix的web客户端跟随系统启动
systemctl enable httpd

# 4 启动zabbix-web
systemctl start httpd
systemctl status httpd
```
2. 打开网页
http://IP/zabbix
- /etc/zabbix/web/zabbix.conf.php 被创建
- 默认管理员账号密码 Admin/zabbix

## 密码重置 
```bash
select userid,alias,passwd from users;
echo -n  admin  | openssl md5
update users set  passwd='21232f297a57a5a743894a0e4a801fc3' where userid = '1';
```