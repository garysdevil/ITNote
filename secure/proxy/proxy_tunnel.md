---
created_date: 2025-03-12
---

[TOC]

# 代理
## 服务端代理
### Dante
1. 教程参考 https://blog.csdn.net/qq_41123867/article/details/125667554

### squid 正向代理软件
```bash
# 安装
yum install squid
```

```conf
# squid服务端配置 /etc/squid/squid.conf
acl 访问控制规则名称 src 10.0.0.0/24 
http_access allow lanhome
http_access allow all  # 允许的 访问控制规则，all是允许所有IP访问
```

### goproxy
- 源码 https://github.com/snail007/goproxy

```bash
# 安装使用

curl -L https://raw.githubusercontent.com/snail007/goproxy/master/install_auto.sh | bash
proxy socks -t tcp -p "0.0.0.0:38080" --log proxy.log  --daemon --forever
# --forever # 防止进程意外退出

iptables -A INPUT  -p tcp --dport 38080 -j DROP 
iptables -I INPUT -s ${IP} -p tcp --dport 38080 -j ACCEPT 
```

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

# 隧道



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
PostUp = iptables -A FORWARD -i %i -j ACCEPT #iptables -t nat -A POSTROUTING -o ${network_interface} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT #iptables -t nat -D POSTROUTING -o ${network_interface} -j MASQUERADE
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