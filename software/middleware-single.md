---
created_date: 2020-11-16
---

[TOC]


### 2. 安装MongoDB/4.0
#### 2.1 centos7通过yum源安装mongodb
```shell
# 配置yum源
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
# 安装
yum install -y mongodb-org

# 启动mongo（mongodb/bin/mongod 启动方式1）,通过参传递配置，默认数据库目录/data/db，
mkdir -p /data/db
mongod
mongod --auth 
# 启动mongo（启动方式2）
vi /etc/mongod.conf #修改数据库目录，修改的dbPath参
service mongod start
```
#### ubuntu16 apt源安装
- https://docs.mongodb.com/v4.0/tutorial/install-mongodb-on-ubuntu/#install-mongodb-community-edition
```
wget -qO - https://www.mongodb.org/static/pgp/server-4.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

sudo apt-get update

apt-get install mongodb-org -y 
```
#### 2.2 通过二进制文件安装mongodb
- mongodb官网内的所有版本： https://www.mongodb.com/download-center/community   
```shell
cd /opt/jadepool-all/mongodb
# 下载centos系统的安装包
curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-4.0.3.tgz

echo "解压安装包，更改文件夹名字为mongodb"

# 创建配置
vi ./bin/mongod.conf
dbpath = /opt/jadepool-all/mongodb/data/db #数据文件存放目录
logpath = /opt/jadepool-all/mongodb/logs/mongodb.log #日志文件存放目录
port = 27017  #端口
fork = true  #以守护程序的方式启用，即在后台运行
bind_ip = 0.0.0.0    #允许所有的连接
auth = true 
# logappend=true  #使用追加方式写日志
# maxConns=5000   #最大连接数

mkdir ./data/db  ./logs
# 
vim ~/.bash_profile     #修改本用户下的环境变量
mongodbPath=/opt/jadepool-all-mongodb/bin
PATH=$PATH:${mongodbPath}
# 加载启动
./mongod -f /usr/local/mongodb/bin/mongodb.conf

```
#### 2.3 使用
```shell
# 创建数据库账户密码（MongoDB 默认安装完成以后，只允许本地连接，同时不需要使用任何账号密码就可以直接连接MongoDB）
use admin
db.createUser({user:"admin",pwd:"admin",roles:["root"]})  # role角色只在admin库中可用
use 业务数据库
db.createUser({user:"jadepool",pwd:"jadepool",roles:["dbOwner"]}) # 在每个业务数据库里创建的账户
# 登陆认证
mongo IP/数据库名 -u 用户 -p 密码
# use admin
# db.auth("admin", "admin")

# 先进行管理员用户的验证，查看所有的用户 db.system.users.find().pretty()
```
### 3. 安装Redis/5.0
```shell
# 下载源码包进行编译安装
curl -O http://download.redis.io/releases/redis-5.0.4.tar.gz
# 安装依赖.
yum install gcc
yum install gcc-c++
# 进入目录,编译安装
cd redis-5.0.4
make
# 后台启动：
nohup src/redis-server redis.conf > ./redis.log 2>&1 &
# 关闭命令：src/redis-cli shutdown
# 强制关闭：kill -9 id

# 开启密码登陆
# vi redis.conf
# 将 requirepass 的注释解除掉，在后面加上自己的密码。然后重新运行 redis 服务。

# 增加密码后连接命令：src/redis-cli -a mypassword
# 增加密码后关闭命令：src/redis-cli -a mypassword shutdown
```
### 4. 安装consul
```shell
# 单节点安装一个consul即可
curl -O  https://releases.hashicorp.com/consul/1.6.0/consul_1.6.0_linux_amd64.zip
unzip consul_1.6.0_linux_amd64.zip
mv consul /usr/bin/
cd /opt/jadepool-all/consul
mkdir  ./data  ./config
nohup consul agent -server -bootstrap-expect=1 -data-dir=./data -node=master -bind=127.0.0.1 -config-dir=./config -client 0.0.0.0 -ui > ./consul-server.log 2>&1 &
```

### 5. seed的安装使用
1. 安装
```shell
mkdir data
# 初始化seed,设置密码，请务必记住设置的密码，忘记密码将不能恢复。
./seed --path=./data/  
# 启动seed
screen -S seed
./seed --path=./data/
```
2. 查看设置
./seed --path=./data/ --list
3. 配置白名单
./seed --path=./data/ --config
输入client回车
输入IP
4. 设置需要支持的链
./seed --path=./data/ --data
