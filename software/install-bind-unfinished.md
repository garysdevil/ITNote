参考文档：
https://qizhanming.com/blog/2017/05/27/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7
http://www.178linux.com/83491
源码：
https://github.com/isc-projects/bind9
### 安装bind
1. 源码安装
cd bind源码所在的目录
./configure –prefix=/opt/bind –without-openssl 
#make && make install 
2. yum源安装
yum update
yum install bind bind-utils
### 配置主DNS
#### 配置1
假设有如下4台机器：
172.16.212.127 作为dns1
172.16.212.128 作为dns2
172.16.212.129 作为与域名相映射的主机host1
172.16.212.130 作为与域名相映射的主机host2
1. 配置哪些计算机可以使用我们这个域名服务进行递归域名查询。
    - 在 options 块前面，创建一个 ACL（Access Control List） 块,名称为 “trusted”；
    - 修改 options 模块的 allow-query 从 localhost 改为 trusted。

2. 配置从DNS服务器
    - 修改option块；添加 allow-transfer 条目，设置为 dns2 的地址，

3. 在文件的最后，添加这一行 include "/etc/named/named.conf.local";

vim /etc/named.conf
---
acl "trusted" {
	172.16.212.127;  # dns1 - can be set to localhost
	172.16.212.128;  # dns2
	172.16.212.129;  # host1
	172.16.212.130;  # host2
};
options {
	listen-on port 53 { 127.0.0.1; 10.11.0.199; };
    # listen-on-v6 port 53 { ::1; };
    #allow-query     { localhost; };
    allow-query     { trusted; };
    allow-transfer  { 172.16.212.128; };
...
include "/etc/named/named.conf.local"
---
#### 配置2
配置DNS,指定正向域反向域文件位置
vim /etc/named/named.conf.local
---
zone "bj1.example.com" {
    type master;
    file "/etc/named/zones/db.bj1.example.com"; # zone file path
};
zone "212.16.172.in-addr.arpa" {
    type master;
    file "/etc/named/zones/db.172.16.212";  # 172.16.212.0/24 subnet
};
---

#### 配置3
chmod 755 /etc/named
mkdir /etc/named/zones

1. 创建正向域文件
vim /etc/named/zones/db.bj1.example.com

2. 创建反向域文件
vim /etc/named/zones/db.172.16.212

#### 检查 bind 配置
使用 named-checkconf 命令检查 named.conf* 文件

named-checkzone 命令检查域文件语法是否错误
named-checkzone bj1.example.com /etc/named/zones/db.bj1.example.com
named-checkzone 212.16.172.in-addr.arpa /etc/named/zones/db.172.16.212

#### 启动bind

### 配置从DNS

和主DNS的区别是在  ”配置DNS,指定正向域反向域文件位置“的文件里多了两行type slave;
vim /etc/named/named.conf.local
---
zone "bj1.example.com" {
    type slave;
    type master;
    file "/etc/named/zones/db.bj1.example.com"; # zone file path
};
zone "212.16.172.in-addr.arpa" {
    type slave;
    type master;
    file "/etc/named/zones/db.172.16.212";  # 172.16.212.0/24 subnet
};