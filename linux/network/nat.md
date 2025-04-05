- 内网穿透的方法
    1. 端口映射（Port Forwarding）
        1. 适用场景：有公网 IP 和路由器管理权限。
    2. 反向代理与隧道（Reverse Proxy/Tunneling）
        1. 适用场景：无公网 IP 或无法修改路由器。
        2. 工具：Frp、Ngrok、Cloudflare Tunnel 等。

## Frp
- https://github.com/fatedier/frp
```sh
./frps -c frps.toml
./frpc -c frpc.toml
```