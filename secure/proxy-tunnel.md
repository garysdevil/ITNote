[TOC]
# 代理

- 代理
    1. 正向代理 
    2. 透明代理
    3. 反向代理
    - 正向代理和透明代理代理服务的对象是客户端，反向代理代理服务的对象是服务端

## 服务端代理
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

### goproxy
- 源码 https://github.com/snail007/goproxy

- 安装使用
```bash
    curl -L https://raw.githubusercontent.com/snail007/goproxy/master/install_auto.sh | bash
    proxy socks -t tcp -p "0.0.0.0:38080" --log proxy.log  --daemon --forever
    # --forever # 防止进程意外退出
    ```
    ```bash
    iptables -A INPUT  -p tcp --dport 38080 -j DROP 
    iptables -I INPUT -s ${IP} -p tcp --dport 38080 -j ACCEPT 
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

- ./v2ray uuid
- 验证配置文件的正确性 /usr/local/bin/v2ray test -config /usr/local/etc/v2ray/config.json
- ./v2ray run -config ./config.json

##### 服务端配置
```json
{
    "inbounds": [
        {
            "port": 10086, // 服务器监听端口
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "b831381d-6324-4d53-ad4f-8cda48b30811" // 客户端需要配置相同的id
                    }
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
```
```json
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [{
    "port": 8080,
    "listen": "0.0.0.0",
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": false,
      "ip": "127.0.0.1"
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {},
    "tag": "direct"
  }],
  "policy": {
    "levels": {
      "0": {"uplinkOnly": 0}
    }
  }
}
```

##### 客户端配置
```json
{
    "inbounds": [
        {
            "port": 1080, // SOCKS 代理端口，在浏览器中需配置代理并指向这个端口
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "vmess",
            "settings": {
                "vnext": [
                    {
                        "address": "server", // 服务器地址，请修改为你自己的服务器 ip 或域名
                        "port": 10086, // 服务器端口
                        "users": [
                            {
                                "id": "b831381d-6324-4d53-ad4f-8cda48b30811"
                            }
                        ]
                    }
                ]
            }
        },
        {
            "protocol": "freedom",
            "tag": "direct"
        }
    ],
    "routing": {
        "domainStrategy": "IPOnDemand",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "direct"
            }
        ]
    }
}
```

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
v2gen -u "订阅url" -o /usr/local/etc/v2ray/config.json
```

#### v2rayA
-  v2ray的GUI管理界面
- 源码 https://github.com/v2rayA/v2rayA

### clash
- https://github.com/Dreamacro/clash

### ssh
- 参考 https://www.cnblogs.com/zhugq02/p/16938074.html

1. 正向代理（-L）：相当于 iptable 的 port forwarding
    - 远程端口映射到其他机器。HostB 上启动一个 PortB 端口，映射到 HostC:PortC 上，在 HostB 上运行： ``ssh -L 0.0.0.0:PortB:HostC:PortC user@HostC``
    - 本地端口通过跳板映射到其他机器。HostA 上启动一个 PortA 端口，通过 HostB 转发到 HostC:PortC上，在 HostA 上运行： ``ssh -L 0.0.0.0:PortA:HostC:PortC  user@HostB``
2. 反向代理（-R）：相当于 frp 或者 ngrok
    - HostA 将自己可以访问的 HostB:PortB 暴露给外网服务器 HostC:PortC，在 HostA 上运行：``ssh -R HostC:PortC:HostB:PortB  user@HostC``
    - 使用时需修改 HostC 的 /etc/ssh/sshd_config，添加： GatewayPorts yes
    - 相当于内网穿透.
3. socks5 代理（-D）：相当于 ss/ssr
    - 在 HostA 的本地 1080 端口启动一个 socks5 服务，通过本地 socks5 代理的数据会通过 ssh 链接先发送给 HostB，再从 HostB 转发送给远程主机：``ssh -D localhost:1080  user@HostB``
    - 优化 ``ssh -CqTnN -L 0.0.0.0:PortA:HostC:PortC  user@HostB``
    - 其中 -C 为压缩数据，-q 安静模式，-T 禁止远程分配终端，-n 关闭标准输入，-N 不执行远程命令。此外视需要还可以增加 -f 参数，把 ssh 放到后台运行。



## 客户端代理
### 环境变量方式
```conf
# 配置完执行 source /etc/profile 使配置文件立即生效
export http_proxy=服务端IP地址:端口 # http协议访问时使用代理，也可以设置https，ftp等协议
export https_proxy=服务端IP地址:端口
export no_proxy='localhost,127.0.0.1'
```

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

```bash
tsocks ${command}
```

### proxychains

```bash
apt install proxychains4 -y
PROXYCHAINS_SOCKS5=127.0.0.1:7890 proxychains ${command}

```
- /etc/proxychains4.conf

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

## WireGuard
### 服务端
```bash
apt update
apt install wireguard

# 生成私钥和公钥
wg genkey > /etc/wireguard/privatekey
cat privatekey | wg pubkey > /etc/wireguard/publickey

# 查看访问公网的接口
ip -o -4 route show to default | awk '{print $5}'
# 配置流量路由的虚拟接口
vim /etc/wireguard/wg0.conf

# 将wg0.conf和privatekey文件设置为对普通用户不可读，以此保证私钥的安全。
chmod 600 /etc/wireguard/{privatekey,wg0.conf}

# 启用wg0接口
wg-quick up wg0

# 检查接口状态和配置
wg show wg0
# 输出wg0接口状态
ip a show wg0
# 设置wg0虚拟网卡自动启动
systemctl enable wg-quick@wg0

# 配置服务器转发功能
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p


# 将客户端的公钥和IP地址添加到服务器
wg set wg0 peer ${CLIENT_PUBLIC_KEY} allowed-ips 10.0.0.2
```

- wg0.conf 文件配置
```conf
[Interface]
Address = 10.0.0.1/24
SaveConfig = true
ListenPort = 51820
PrivateKey = ${SERVER_PRIVATE_KEY}
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${network_interface} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${network_interface} -j MASQUERADE
```
### 客户端
```bash
# 生成私钥和公钥
wg genkey > /etc/wireguard/privatekey
cat privatekey | wg pubkey > /etc/wireguard/publickey
# 配置客户端文件
vim /etc/wireguard/wg0.conf

# 打开客户端wg0接口
wg-quick up wg0
# 关闭客户端wg0接口
wg-quick down wg0
```

- /etc/wireguard/wg0.conf
```conf
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY # 客户端生成的私钥
Address = 10.0.0.2/24 # wg0接口的IPv4或IP v6地址


[Peer]
PublicKey = SERVER_PUBLIC_KEY  #服务器端生成的公钥
Endpoint = SERVER_IP_ADDRESS:51820
AllowedIPs = 0.0.0.0/0 # 使用逗号分隔的IPv4或IP v6地址列表，如果数据包与IP列表匹配，这些数据包将走wireguard通道。0.0.0.0/0表示将所有流量都转发到wireguard服务器端。
```

```conf
[Interface]
PrivateKey = OJra2+OwuLsdJ1y9Y3Q/UJgZbpr3PqR7OdN/7Y1mdkw=
Address = 10.0.0.2/24


[Peer]
PublicKey = PTICNQReN7IEIMfB1/lWq1LwGSt4OLEM1LjfDtQPqwY=
Endpoint = 173.82.143.63:51820
AllowedIPs = 0.0.0.0/0
```
wg set wg0 peer zn5kjX/0XqFMMaDDnIKhnPAbhG7bAdUY6tsSQvwQLhk= allowed-ips 10.0.0.2