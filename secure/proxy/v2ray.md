---
created_date: 2025-03-12
---

[TOC]

## v2ray
### 安装
- 源码 https://github.com/v2fly/v2ray-core
- 教程 https://www.v2fly.org/guide/start.html
- 安装 https://www.v2fly.org/guide/install.html

- 脚本安装 `bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)`
    - 启动 `systemctl start v2ray`
    - 安装好的官方v2ray-core文件路径如下
        ```txt
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

- 生成UUID `./v2ray uuid`
- 验证配置文件的正确性 `/usr/local/bin/v2ray test -config /usr/local/etc/v2ray/config.json`
- 启动 `./v2ray run -config ./config.json`

### 服务端配置
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

### 客户端配置
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

## v2gen
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

## v2rayA
-  v2ray的GUI管理界面
- 源码 https://github.com/v2rayA/v2rayA
