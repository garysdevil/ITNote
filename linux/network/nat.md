- 内网穿透的方法
    1. 端口映射（Port Forwarding）
        1. 适用场景：有公网 IP 和路由器管理权限。
    2. 反向代理与隧道（Reverse Proxy/Tunneling）
        1. 适用场景：无公网 IP 或无法修改路由器。
        2. 工具：Frp、Ngrok、Cloudflare Tunnel 等。

## Frp
- https://github.com/fatedier/frp
### 服务端配置
```toml
bindAddr = "0.0.0.0"
bindPort = 7000

# 认证配置
[auth]
method = "token"  # 认证方式，支持 "token" 或 "oidc"
token = "服务端自定义token"

# Web管理面板（可选）
[webServer]
addr = "0.0.0.0"
port = 7500
user = "gary"
password = "自定义的密码"
# tls.certFile = "./keys/server.crt"
# tls.keyFile = "./keys/server.key"
# tls.trustedCaFile = "./keys/CA.crt"

# 日志配置
[log]
to = "./frps.log"
level = "debug"
maxDays = 3

[transport]
maxPoolCount = 5
# TLS加密
# tls.force = true  # 强制客户端使用TLS
# tls.certFile = "./keys/server.crt"
# tls.keyFile = "./keys/server.key"
# tls.trustedCaFile = "./keys/CA.crt"
```
### 客户端配置
```toml
serverAddr = "frps服务的公网IP"
serverPort = frps服务的公网端口

# 认证
[auth]
method = "token"
token = "服务端自定义token"

# 日志
[log]
to = "./frpc.log"
level = "info"

[webServer]
addr = "127.0.0.1"
port = 7400
user = "admin"
password = "admin"

# 代理服务
[[proxies]]
name = "rdp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 3389
remotePort = 3389

# [transport]
# tls.enable = true
# tls.certFile = "./keys/client.crt"
# tls.keyFile = "./keys/client.key"
# tls.trustedCaFile = "./keys/CA.crt"
```
### 指令
```sh
./frps -c frps.toml
./frpc -c frpc.toml
```