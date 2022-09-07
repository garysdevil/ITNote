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
    # 执行 source /etc/profile，使配置文件立即生效
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
#### v2ray
- 源码 https://github.com/v2fly/v2ray-core
- 教程 https://www.v2fly.org/guide/start.html
- 安装 https://www.v2fly.org/guide/install.html

- 脚本安装 bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
    - 启动 systemctl start v2ray
    - 安装好的官方v2ray-core文件路径如下
        ```
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

- 验证配置文件的正确性 /usr/local/bin/v2ray -test -config /usr/local/etc/v2ray/config.json

#### v2gen
- 通过订阅模式配置v2ray
```bash
#下载v2gen
wget https://github.com/iochen/v2gen/releases/latest/download/v2gen_amd64_linux
#改名
mv v2gen_amd64_linux v2gen
#加上执行权限
chmod u+x v2gen
#移动文件
mv v2gen /usr/local/bin/

# 生成config.json文件
v2gen -u “订阅url” -o /usr/local/etc/v2ray/config.json
```

#### v2rayA
-  v2ray的GUI管理界面
- 源码 https://github.com/v2rayA/v2rayA

### clash
- https://github.com/Dreamacro/clash


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
    - 官方 https://openvpn.net/access-server-manual/deployment-overview/
    - https://www.wanhebin.com/openvpn/639.html
### 安装
```bash
# Centos系统
# 安装epel 仓库源
wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

rpm -Uvh epel-release-6-8.noarch.rpm

yum install easy-rsa openvpn

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
```
```bash
# Ubuntu系统
apt-get install openvpn
```

```bash
# 客户端启动
openvpn  /etc/openvpn/client/client.ovpn
openvpn --ca /etc/openvpn/client/ca.crt --config /etc/openvpn/client/client.ovpn --auth-user-pass /etc/openvpn/client/passwd --log-append /tmp/openvpn.log
```

### 使用openVPN自带的http-proxy作代理
- OpenVPN本身可以使用http代理，也就是说，OpenVPN客户端不是直接和OpenVPN服务器连接，而是使用http代理进行连接。这个特性是OpenVPN的外围特性，不是其核心的，然而却能解决很多实际问题，它相当于隧道外面又套了一个隧道，不过这个外面的隧道并不是真实的隧道，因为它并没有封装，而仅仅是伪装了端口信息而已。
- OpenVPN客户端 -->  http代理服务器（squid）  -->  OpenVPN服务器

### Openvpn客户端配置
- *.ovpn
```conf
client #指定当前VPN是客户端
dev tun #使用tun隧道传输协议
proto udp #使用udp协议传输数据
remote ${IP} 1194 #openvpn服务器IP地址端口号
resolv-retry infinite #断线自动重新连接，在网络不稳定的情况下非常有用
nobind #不绑定本地特定的端口号
verb 3 #指定日志文件的记录详细级别，可选0-9，等级越高日志内容越详细
persist-key #通过keepalive检测超时后，重新启动VPN，不重新读取keys，保留第一次使用的keys
persist-tun #检测超时后，重新启动VPN，一直保持tun是linkup的。否则网络会先linkdown然后再linkup
; block-outside-dns # 阻止使用外部的DNS
# 证书密钥
ca ca.crt #指定CA证书的文件路径
cert client.crt #指定当前客户端的证书文件路径
key client.key #指定当前客户端的私钥文件路径
# 代理设置
route-nopull # 不添加路由，也就是不会有任何网络请求走 openvpn 代理
route 192.168.2.0 255.255.255.0 vpn_gateway # 指定网络段才走 openvpn 代理
route 172.121.0.0 255.255.0.0 net_gateway # 与 vpn_gateway 相反，它是指定哪些IP不走 openvpn 代理
```

## UDPspeeder
- 源码 https://github.com/wangyu-/UDPspeeder
    
## Udp2raw-Tunnel
- 参考 https://www.freebuf.com/sectool/187069.html

- 源码 https://github.com/wangyu-/udp2raw
- 定义 Udp2raw-Tunnel是一款功能强大的UDP隧道工具