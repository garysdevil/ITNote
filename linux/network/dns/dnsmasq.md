---
created_date: 2021-07-01
---

[TOC]



- 参考
    - https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist.conf 被墙的域名文件
    - https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf 被墙的域名文件

- dnsmasq DNS解析过程
    1. 寻找本地hosts文件
    2. 寻找本地缓存的域名
    3. 寻找dnsmasq上的 addn-hosts 配置
    4. 寻找dnsmasq上的 server 和 address 配置
    4. 寻找上游dns服务器（resolv-file）

## 安装配置
```bash
yum install -y dnsmasq
systemctl start dnsmasq.service
```

- /etc/dnsmasq.conf
```conf
# strict-order 表示严格按照resolv-file文件中的顺序从上到下进行DNS解析，直到第一个解析成功为止。
# listen-address=0.0.0.0,127.0.0.0 定义dnsmasq监听的地址，默认是监控本机的所有网卡上。
# no-hosts 设置不读取本地/etc/hosts文件
# cache-size=500 设置DNS缓存大小（单位：DNS解析条数）,默认150条。

resolv-file=/etc/resolv.conf # 定义dnsmasq从哪里获取上游DNS服务器的地址， 默认从/etc/resolv.conf获取。
addn-hosts=/etc/hosts # 本地主机解析记录
conf-file=/etc/dnsmasq.d/dnsmasq_gfwlist_ipset.conf # 子配置文件


# 指定DNS
server=/cn/114.114.114.114
server=/taobao.com/114.114.114.114
*server=/google.com/8.8.8.8 # 泛域名解析
# 指定域名解析到特定的IP上 
address=/ad.iqiyi.com/127.0.0.1
* address=/garys.top/101.132.140.53 # 泛域名解析
# 域名解析IP结果存储到名为ipset_name的ipset结构中
ipset=/google.com/ipset_name1,ipset_name2
```

```bash
# 检查配置文件语法是否正确
dnsmasq --test
```

