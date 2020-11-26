## SkyAPM-php-sdk
- 参考
https://github.com/SkyAPM/SkyAPM-php-sdk  
https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md
### 裸安装 v3.2.1
sky-php-agent --grpc 172.31.84.175:11800 /var/run/sky-agent.sock 

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

### 裸安装 v4.0.1
1. 安装文档 https://github.com/SkyAPM/SkyAPM-php-sdk/blob/master/docs/install.md
2. 如果有多个php版本，注意配置使用的php版本
./configure --with-php-config=-----/bin/php-config

#### 遇到的错误 
1. cmake: command not found
解决措施
```bash 
yum install gcc7* # gcc -v 查看gcc版本，根据情况升级
yum install openssl-devel # 解决 Could not find OpenSSL.
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
#### php配置
php.ini
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
### 容器安装
docker run -d -e SW_OAP_ADDRESS=127.0.0.1:11800  -p 9000:9000 skyapm/skywalking-php