[TOC]
# 代理

- 代理
    1. 正向代理 
    2. 透明代理
    3. 反向代理
    - 正向代理和透明代理代理服务的对象是客户端，反向代理代理服务的对象是服务端

## 代理服务
### squid 正向代理软件
1. 安装
    ```bash
    yum install squid
    ```

2. squid服务端配置 /etc/squid/squid.conf
    ```conf
    acl 访问控制规则名称 src 10.0.0.0/24 
    http_access allow lanhome
    http_access allow all  # 允许的 访问控制规则，all是允许所有IP访问
    ```

3. 客户端HTTP方式连接代理配置 linux系统配置 /etc/profile
    ```conf
    export http_proxy=squid服务端IP地址:3128 # http协议访问时使用代理，也可以设置https，ftp等协议
    export https_proxy=squid服务端IP地址:3128
    export no_proxy='localhost,127.0.0.1'
    ```

### goproxy
- 源码 https://github.com/snail007/goproxy

- 安装使用
    ```bash
    curl -L https://raw.githubusercontent.com/snail007/goproxy/master/install_auto.sh | bash
    proxy socks -t tcp -p "0.0.0.0:38080"
    --log proxy.log 
    --daemon
    --forever # 防止进程意外退出
    ```

### shadowsocks
- 参考 
    - http://ivo-wang.github.io/2018/02/24/ss-redir/

### v2ray
- 源码 https://github.com/v2fly/v2ray-core
- 教程 https://www.v2fly.org/guide/start.html
- 安装 https://www.v2fly.org/guide/install.html

- 脚本安装 bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
```
启动 systemctl start v2ray
安装好的官方v2ray-core文件路径如下
installed: /usr/local/bin/v2ray
installed: /usr/local/bin/v2ctl
installed: /usr/local/share/v2ray/geoip.dat
installed: /usr/local/share/v2ray/geosite.dat
installed: /usr/local/etc/v2ray/config.json
installed: /var/log/v2ray/
installed: /var/log/v2ray/access.log
installed: /var/log/v2ray/error.log
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service

```
## 前置代理工具
### Proxy SwitchyOmega
- Google游览器代理管理工具插件

### tsocks
- 通过SOCKS4或SOCKS5代理提供透明的网络访问。
    ```bash
    apt install tsocks
    ```

- vi /etc/tsocks.conf  
    ```conf
    local = 192.168.1.0/255.255.255.0  #不使用socks代理的网络
    local = 127.0.0.0/255.0.0.0  #不使用socks代理的网络
    server = 127.0.0.1   #socks服务器的IP  
    server_type = 5  #socks服务版本  
    server_port = 1080 #socks服务使用的端口 
    ```


# 隧道

## Openvpn
- 参考
    - https://openvpn.net/access-server-manual/deployment-overview/
    - https://www.wanhebin.com/openvpn/639.html
### 安装
```bash
# 安装epel 仓库源
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

rpm -Uvh epel-release-6-8.noarch.rpm

yum install easy-rsa openvpn

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
```

## UDPspeeder
- 源码 https://github.com/wangyu-/UDPspeeder
    
## Udp2raw-Tunnel
- 参考 https://www.freebuf.com/sectool/187069.html

- 源码 https://github.com/wangyu-/udp2raw
- 定义 Udp2raw-Tunnel是一款功能强大的UDP隧道工具