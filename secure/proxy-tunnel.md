# 代理
- 参考文档 https://blog.csdn.net/qq_21419995/article/details/80888680
http://www.squid-cache.org/
- 代理
    1. 正向代理 
    2. 透明代理
    3. 反向代理
    - 正向代理和透明代理代理服务的对象是客户端，反向代理代理服务的对象是服务端

## squid 正向代理软件
1. 安装
yum install squid
2. squid服务端配置 
/etc/squid/squid.conf
```conf
acl 访问控制规则名称 src 10.0.0.0/24 
http_access allow lanhome
http_access allow all  # 允许的 访问控制规则，all是允许所有IP访问
```
3. 客户端连接代理配置
linux配置 /etc/profile
```conf
export http_proxy=192.168.221.139:3128 # http协议访问时使用代理，也可以设置https，ftp等协议
export no_proxy='localhost,127.0.0.1'
```

## goproxy
- https://github.com/snail007/goproxy

### 安装使用
curl -L https://raw.githubusercontent.com/snail007/goproxy/master/install_auto.sh | bash
proxy socks -t tcp -p "0.0.0.0:38080"
--log proxy.log 
--daemon
--forever # 防止进程意外退出

# 隧道
- 参考文件
    - https://www.freebuf.com/sectool/187069.html（Udp2raw-Tunnel：一款功能强大的UDP隧道工具）

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
```