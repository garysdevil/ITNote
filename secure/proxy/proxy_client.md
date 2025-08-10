---
created_date: 2025-03-12
---

[TOC]

### 环境变量方式

```conf
# vi /etc/profile.d/proxy.conf
# source /etc/profile.d/proxy.conf # 使配置文件立即生效
#export all_proxy=http://10.0.0.51:8080  http://user:pass@10.0.0.10:8080    socks4://10.0.0.51:1080  socks5://192.168.1.1:1080
#export ftp_proxy=
export http_proxy=
export https_proxy=
export no_proxy='localhost,127.0.0.1'

# 取消环境变量的设置
#unset http_proxy
#unset https_proxy
#unset ftp_proxy
#unset no_proxy
```

```bash
# Ubuntu-apt 代理配置
apt -o Acquire::http::proxy="http://192.168.1.2:3128/" update

# 单独设置yum代理访问，如下文件的变量
echo "proxy=http://127.0.0.1:8080/" >> /etc/yum.conf
```

- 账号密码中有特殊符号，则需要转换
- 参考 http://ascii.911cha.com/
  | @ | 0x40 |
  | ---- | ---- |
  | : | 0x3A |
  | ~ | 0x7E |
  | # | 0x23 |
  | $ | 0x24 |
  | % | 0x25 |
  | & | 0x26 |

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
PROXYCHAINS_SOCKS5_HOST=127.0.0.1 PROXYCHAINS_SOCKS5_PORT=4321 proxychains zsh

```

- /etc/proxychains4.conf

### clash生态

1. 内核 https://github.com/MetaCubeX/mihomo
2. Clah(Windows/Linux) https://github.com/Dreamacro/clash 原开发者下架了
3. ClashX(Mac) https://github.com/yichengchen/clashX 原开发者下架了
4. ClashVerg(Windows/Mac) https://github.com/clash-verge-rev/clash-verge-rev
5. v2rayNG(Android) https://github.com/2dust/v2rayNG

### 其它

1. Shadowrocket https://shadowsocks.org
2. V2ray https://v2ray.com
3. Surge
4. karing（IOS） https://github.com/KaringX/karing
