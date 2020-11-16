
[TOC]
## 部署Qtum
- 使用源码进行安装部署
### 1.安装gcc
yum -y update gcc
yum -y install gcc+ gcc-c++

### 2.安装glibc2.18

```bash
mkdir /data/glibc && cd /data/glibc
wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-2.18.tar.gz
tar zxvf glibc-2.18.tar.gz
mkdir -p glibc-2.18/build && cd glibc-2.18/build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make -j4 && make install

# 校验
strings /lib64/libc.so.6 | grep GLIBC
ll /lib64/libc.so.6
```

### 3.安装gcc v7.4.0

```bash
mkdir /data/gcc && cd /data/gcc
wget https://mirrors.ustc.edu.cn/gnu/gcc/gcc-7.4.0/gcc-7.4.0.tar.gz
tar zxvf gcc-7.4.0.tar.gz
cd gcc-7.4.0/
# 需要用到bzip2，wget工具 yum -y install bzip2
./contrib/download_prerequisites
mkdir /usr/local/gcc-7.4.0
cd /usr/local/gcc-7.4.0/
# 到这里
/data/gcc/gcc-7.4.0/configure -enable-checking=release -enable-languages=c,c++ -disable-multilib
make && make install
rpm -e gcc-c++-4.8.5-39.el7.x86_64
rpm -e --nodeps gcc-4.8.5-39.el7.x86_64

cd /usr/lib64/
cp /usr/local/gcc-7.4.0/stage1-x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.24 ./
rm -rf libstdc++.so.6
ln -s libstdc++.so.6.0.24 libstdc++.so.6
ln -s /usr/local/bin/gcc /usr/local/bin/cc
reboot

# 验证
gcc -v
cc -v
```
### 4.日志配置
```bash
mkdir /data/logs
yum install rsyslog -y
cat << EOF > /etc/rsyslog.d/qtum.conf
if \$programname == 'qtumd' then /data/logs/qtumd.log
EOF

cat << EOF > /etc/rsyslog.d/qtuminfo.conf
if \$programname == 'qtuminfod' then /data/logs/qtuminfod.log
EOF

systemctl restart rsyslog.service
```

### 5.安装qtum-core

```bash
# boost
cd /data
yum install -y python-devel bzip2-devel lbzip2
yum install -y epel-release
yum install -y libtool libdb4-cxx-devel openssl-devel libevent-devel gmp-devel
git clone https://github.com/boostorg/boost.git
cd boost
git checkout boost-1.66.0
git submodule update --init --recursive
./bootstrap.sh --prefix=/usr --libdir=/usr/lib64
./b2 headers
./b2 -j4 install

# qtumd
cd /data
git clone --recursive https://github.com/qtumproject/qtum.git --branch=qtuminfo
cd qtum
# 本文档使用qtuminfo分支，默认会克隆qtuminfo分支下来
./autogen.sh
./configure
make -j4

mkdir /data/qtum_data

cat > /data/qtum_data/qtum.conf << EOF
logevents=1
rpcuser=user
rpcpassword=password
EOF

cat > /usr/lib/systemd/system/qtumd.service << EOF
[Unit]
Description=Qtum-Core
Documentation=https://github.com/qtumproject/qtum
After=network.target
BoundBy=qtuminfod.service

[Service]
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=qtumd
Type=simple
ExecStart=/data/qtum/src/qtumd --conf=/data/qtum_data/qtum.conf --datadir=/data/qtum_data
#ExecStart=/data/qtum/src/qtumd -testnet --conf=/data/qtum_data/qtum.conf --datadir=/data/qtum_data
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start qtumd.service && systemctl status qtumd.service
systemctl enable qtumd.service

# 高度验证
/data/qtum/src/qtum-cli -conf=/data/qtum_data/qtum.conf -datadir=/data/qtum_data/ -getinfo
#/data/qtum/src/qtum-cli -testnet -conf=/data/qtum_data/qtum.conf -datadir=/data/qtum_data/ -getinfo
```

### 6.安装qtuminfo

#### 6.1.安装node v12

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
source /root/.bashrc
nvm install v12.13.0

# 验证
node -v
```

#### 6.2.安装配置mysql v8

```bash
yum install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum makecache
yum install -y mysql-server

# 修改数据目录
mkdir /data/mysql
chown mysql:mysql /data/mysql
vim /etc/my.cnf
-----
datadir=/data/mysql
log-error=/data/logs/mysqld.log
-----

touch /data/logs/mysqld.log
chown mysql:mysql /data/logs/mysqld.log
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql
systemctl start mysqld
systemctl status mysqld

grep "password" /data/logs/mysqld.log
# A temporary password is generated for root@localhost: Brr25oOJHs*u

mysql -u root -p
mysql> set global validate_password.policy=0;
mysql> set global validate_password.length=4;
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'garys@123';
mysql> CREATE DATABASE IF NOT EXISTS qtum_mainnet;
mysql> CREATE DATABASE IF NOT EXISTS qtum_testnet;
mysql> CREATE USER 'qtum'@'%' IDENTIFIED WITH mysql_native_password BY 'qtum123';
mysql> GRANT ALL PRIVILEGES ON qtum_mainnet.* TO 'qtum'@'%' WITH GRANT OPTION;
mysql> GRANT ALL PRIVILEGES ON qtum_testnet.* TO 'qtum'@'%' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
mysql> exit

mysql -u qtum -p
mysql> show databases;
+--------------------+
| Database |
+--------------------+
| information_schema |
| qtum_mainnet |
| qtum_testnet |
+--------------------+
3 rows in set (0.00 sec)
```

#### 6.3.安装qtuminfo

```bash
cd /data
git clone https://github.com/qtumproject/qtuminfo.git
cd qtuminfo && npm install

# 初始化数据库
#sed -i "s/utf8mb4_unicode_ci/utf8mb4_0900_ai_ci/g" /data/qtuminfo/doc/structure.sql
mysql -u qtum -p
mysql> use qtum_testnet;
Database changed
mysql> source /data/qtuminfo/doc/structure.sql
...
Query OK, 0 rows affected

vim qtuminfo-node.json
---
"chain": "mainnet",
"uri": "mysql://qtum:qtum123@localhost/qtum_mainnet"
"rpc"."port": 3889,
"peer"."port": 3888
---
"chain": "testnet",
"uri": "mysql://qtum:qtum123@localhost/qtum_testnet"
"rpc"."port": 13889,
"peer"."port": 13888
---
```

#### 6.4.服务化qtuminfo进程

```bash
# 配置启动文件start.sh
cat > /data/qtuminfo/start.sh << EOF
export PATH=$PATH:/data/qtuminfo/bin:/root/.nvm/versions/node/v12.13.0/bin/
cd /data/qtuminfo
/data/qtuminfo/bin/qtuminfo-node.js start
EOF
# 配置服务
cat > /usr/lib/systemd/system/qtuminfod.service << EOF
[Unit]
Description=Qtum-Info
After=network.target qtumd.service
BindsTo=qtumd.service

[Service]
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=qtuminfod
ExecStart=/bin/bash /data/qtuminfo/start.sh
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start qtuminfod.service && systemctl status qtuminfod.service
systemctl enable qtuminfod.service
```

### 7.安装qtuminfo-api/ui

#### 7.1.安装配置redis 5

```bash
mkdir /data/redis && cd /data/redis
wget http://download.redis.io/releases/redis-5.0.6.tar.gz
tar zxvf redis-5.0.6.tar.gz
cd redis-5.0.6/
make MALLOC=libc
cd src
make install

# 修改主配置文件redis.conf
---
requirepass qtuminfo
dir /data/redis_data
logfile "/data/logs/redisd.log"
---

# 服务化redis进程
cat > /usr/lib/systemd/system/redisd.service << EOF
[Unit]
Description=Redis-Server

[Service]
ExecStart=/data/redis/redis-5.0.6/src/redis-server /data/redis/redis-5.0.6/redis.conf
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启动
systemctl enable redisd 
systemctl start redisd && systemctl status redisd 
```

#### 7.2.安装配置qtuminfo-api

```bash
cd /data/
git clone https://github.com/qtumproject/qtuminfo-api.git
# 本文档使用master分支
cd qtuminfo-api && npm install

# 以下为测试网配置文件
# 主网则 修改13889为3889，testnet为mainnet，数据库qtum_mainnet
cat > /data/qtuminfo-api/config/config.default.js << EOF
const path = require('path')
const Redis = require('ioredis')

const redisConfig = {
host: 'localhost',
port: 6379,
password: 'qtuminfo',
db: 0
}

exports.keys = 'qtuminfo-api'

exports.security = {
csrf: {enable: false}
}
#exports.middleware = ['ratelimit']

exports.redis = {
client: redisConfig
}

exports.ratelimit = {
db: new Redis(redisConfig),
headers: {
remaining: 'Rate-Limit-Remaining',
reset: 'Rate-Limit-Reset',
total: 'Rate-Limit-Total',
},
disableHeader: false,
errorMessage: 'Rate Limit Exceeded',
duration: 10 * 60 * 1000,
max: 10 * 60
}

exports.io = {
redis: {
...redisConfig,
key: 'qtuminfo-api-socket.io'
},
namespace: {
'/': {connectionMiddleware: ['connection']}
}
}

exports.sequelize = {
dialect: 'mysql',
database: 'qtum_testnet',
host: 'localhost',
port: 3306,
username: 'qtum',
password: 'qtum123'
}

exports.qtum = {
chain: 'testnet'
}

exports.qtuminfo = {
path: path.resolve('..', 'qtuminfo'),
port: 3001,
rpc: {
protocol: 'http',
host: 'localhost',
port: 13889,
user: 'user',
password: 'password'
}
}

exports.cmcAPIKey = null

EOF

# 编写启动脚本
vim /data/qtuminfo-api/start.sh
---
# /bin/bash
export PATH=$PATH:/root/.nvm/versions/node/v12.13.0/bin/
cd /data/qtuminfo-api
echo '程序web日志存在~/logs目录下' > /data/logs/qtuminfo-apid.log
npm start >> /data/logs/qtuminfo-apid.log
---

# 服务化进程
# 首先修改package.json文件
sed -i "s/--daemon//" package.json

cat > /usr/lib/systemd/system/qtuminfo-apid.service << EOF
[Unit]
Description=Redis-Server
After=redisd.service qtuminfod.service
Requires=redisd.service qtuminfod.service
[Service]
ExecStart=/bin/bash /data/qtuminfo-api/start.sh
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StartLimitInterval=0
RestartSec=20

[Install]
WantedBy=multi-user.target
EOF
# 配置，启动
systemctl enable qtuminfo-apid
systemctl start qtuminfo-apid && systemctl status qtuminfo-apid
# 验证
curl localhost:7001/info
```

#### 7.3.安装qtuminfo-ui [TODO]

```bash
cd /data/
git clone https://github.com/qtumproject/qtuminfo-ui.git
cd qtuminfo-ui && npm install
[TODO]
```

#### 7.4.反代 [TODO]

```nginx
server {
listen 80;
listen [::]:80;
server_name qinfo.garys.net;
location / {
proxy_pass http://127.0.0.1:3000;
proxy_redirect off;
proxy_set_header Host \$host;
proxy_set_header X_Real_IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Nginx-Proxy true;
}
location /api/ {
proxy_pass http://127.0.0.1:7001;
proxy_redirect off;
proxy_set_header Host \$host;
proxy_set_header X_Real_IP \$remote_addr;
proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header X-Nginx-Proxy true;
}

access_log /var/log/nginx/qtum.info.access.log;
error_log /var/log/nginx/qtum.info.error.log;
}
```
## 2 Qtum运维须知

1. 启动服务进程 rsyslog
    - 作为qtum-core服务 和 qtuminfo服务 的日志模块

2. qtum-core：扫描公网同步块高的核心二进制程序
    - 服务化qtum-core二进制程序为qtumd服务
    - 启动服务进程 qtumd 默认p2p端口: 3888

3. qtuminfo 和 qtuminfo-api 模块 基于node编写而成

4. qtuminfo：将数据块存在mysql里
    - 服务化qtuminfo程序为qtuminfod服务，强依赖于qtumd服务
    - 启动服务进程 mysql-v8 默认端口: 3006
    - 启动服务进程 qtuminfod 默认端口: 3001

5. qtuminfo-api
    - 后台启动进程 redis-v5 默认端口: 6379
    - 启动qtuminfo-api进程 npm start 默认RPC端口: 7001

6. 日志位置
    - /data/logs目录下：mysqld.log qtumd.log qtuminfod.log
    - qtuminfo-api的日志在启动程序用户的家目录下
    - redis日志在 /data/redis

7. API查看块高命令
    - curl localhost:7001/info


