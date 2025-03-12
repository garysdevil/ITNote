- Openvpn
- 参考
    - 官方 https://openvpn.net/access-server-manual/deployment-overview/
    - https://www.wanhebin.com/openvpn/639.html

## 安装
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

## 使用openVPN自带的http-proxy作代理
- OpenVPN本身可以使用http代理，也就是说，OpenVPN客户端不是直接和OpenVPN服务器连接，而是使用http代理进行连接。这个特性是OpenVPN的外围特性，不是其核心的，然而却能解决很多实际问题，它相当于隧道外面又套了一个隧道，不过这个外面的隧道并不是真实的隧道，因为它并没有封装，而仅仅是伪装了端口信息而已。
- OpenVPN客户端 -->  http代理服务器（squid）  -->  OpenVPN服务器

## Openvpn客户端配置
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
#block-outside-dns # 阻止使用外部的DNS
# 证书密钥
ca ca.crt #指定CA证书的文件路径
cert client.crt #指定当前客户端的证书文件路径
key client.key #指定当前客户端的私钥文件路径
# 代理设置
route-nopull # 不添加路由，也就是不会有任何网络请求走 openvpn 代理
route 192.168.2.0 255.255.255.0 vpn_gateway # 指定网络段才走 openvpn 代理
route 172.121.0.0 255.255.0.0 net_gateway # 与 vpn_gateway 相反，它是指定哪些IP不走 openvpn 代理
```