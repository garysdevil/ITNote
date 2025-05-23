---
created_date: 2020-11-24
---

[TOC]

## SkyAPM-php-sdk

- 参考
  https://github.com/SkyAPM/SkyAPM-php-sdk\
  https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md

### 裸安装 v3.3.2

- 参考
  https://www.jianshu.com/p/a30dc7b19f7a
  https://github.com/SkyAPM/SkyAPM-php-sdk/blob/v3.3.2/docs/install.md 官方

1. php配置

```conf
[skywalking]
; Loading extensions in PHP
extension=skywalking.so

; enable skywalking
skywalking.enable = 1

; Set skyWalking collector version (5 or 6 or 7 or 8)
skywalking.version = 8

; Set app code e.g. MyProjectName
skywalking.app_code = MyProjectName

; sock file path default /tmp/sky-agent.sock
; Warning *[systemd] please disable PrivateTmp feature*
; Warning *Make sure PHP has read and write permissions on the socks file*
skywalking.sock_path=/tmp/sky-agent.sock
```

2. 启动
   ./sky-php-agent --grpc=${IP}:11800 --socket=/tmp/sky-agent.sock

### centos裸安装 v4.1.0

1. 安装文档 https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md
   Install Protobuf

```bash
sudo yum install autoconf automake libtool curl make gcc-c++ unzip -y
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git checkout v3.13.0
git submodule update --init --recursive
./autogen.sh

./configure
make -j$(nproc)
make check
sudo make install
sudo ldconfig # refresh shared library cache.
```

Install GRPC

```bash
yum groupinstall "Development Tools" "Development Libraries"
yum install  autoconf libtool cmake
git clone https://github.com/grpc/grpc.git
cd grpc
git submodule update --init --recursive

mkdir -p cmake/build
cd cmake/build
cmake ../.. -DBUILD_SHARED_LIBS=ON -DgRPC_INSTALL=ON
make -j$(nproc)
sudo make install
make clean
sudo ldconfig
```

```bash
curl -Lo v4.1.0.tar.gz https://github.com/SkyAPM/SkyAPM-php-sdk/archive/v4.1.0.tar.gz
tar zxvf v4.1.0.tar.gz
cd SkyAPM-php-sdk-4.1.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib64/
phpize && ./configure && make && make install
```

2. 如果有多个php版本，注意配置使用的php版本
   ./configure --with-php-config=-----/bin/php-config

#### 遇到的错误

1. cmake: command not found
   解决措施

```bash
yum install gcc7* -y # gcc -v 查看gcc版本，根据情况升级
yum install openssl-devel -y # 解决 Could not find OpenSSL.
sudo yum install build-essential libssl-dev
# sudo apt remove --purge cmake
# find last stable release at https://github.com/Kitware/CMake/releases and download the source .tar.gz,eg:
wget https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz
tar -zxvf cmake-3.18.4.tar.gz
cd cmake-3.18.4
./bootstrap
make 
sudo make install
echo "end----"
```

2. fatal error: src/network/v3/language-agent/Tracing.pb.h: No such file or directory
   参考方案：https://github.com/SkyAPM/SkyAPM-php-sdk/issues/289
   解决措施：
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib64/
   或者将"/usr/local/lib64/" >> /etc/ld.so.conf && ldconfig

#### php配置与启动

1. php.ini

```conf
[skywalking]
; Loading extensions in PHP
extension=skywalking.so

; enable skywalking
skywalking.enable = 1

; Set skyWalking collector version (5 or 6 or 7 or 8)
skywalking.version = 8

; Set app code e.g. MyProjectName
skywalking.app_code = MyProjectName

; Set grpc address
skywalking.grpc=127.0.0.1:11800

; 设置日志
skywalking.log_enable = 1
skywalking.log_path = /tmp/skywalking-php.log
```

2. php-fpm程序必须是前台启动模式
   bin/php-fpm --daemonize no 或者 bin/php-fpm\
   后台启动模式：后台守护进程先启动A主进程，A主进程又另外单独起了B主进程，这个B主进程启动完毕后,A进程会退出。但是v4的消费和生产线程是由A 启动的，A关闭后，相关线程会退出，所以不能用后台守护进程模式启动。

3. 配置完成后重启php即可

### 容器安装

docker run -d -e SW_OAP_ADDRESS=127.0.0.1:11800 -p 9000:9000 skyapm/skywalking-php
