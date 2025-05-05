---
created_date: 2020-12-06
---

[TOC]


## iptables
- Linux的2.4版内核引入了一种全新的网络包处理引擎Netfilter，能为其它内核模块提供数据包过滤、网络地址转换、负载均衡等功能。
- iptables 命令是与Netfilter 系统进行交互的主要工具，用于提供数据包过滤和NAT。
- 基于“过滤规则链”的概念来阻止或转发流量。
- ip set 是linux内核的一个内部框架，ipset是iptables的扩展。

### 命令
- iptables -t ${tabletype} ${action_direction} ${direction}  ${packet_pattern} -j ${what_to_do}
1. ${tabletype} 总共4张表，每张表提供了特定的功能，默认为filter表。使用方式 ``-t ${tabletype}``
     - filter
     - nat
     - mangle
     - raw
2. ${direction} 5个方向(五链) （每个链都代表了数据需要经过的地点）
    1. PREROUTING 路由前的数据包
    2. FORWARD 转发的数据包
    3. INPUT 进入的数据包
    4. OUTPUT 传出的数据包
    5. POSTROUTING  路由后的数据包
3. ${action_direction}  匹配到规则后，停止搜索，因此前面的规则权重大于后面的规则
    - -I 在规则链头部添加一个规则
    - -A 在规则链末尾添加一个规则
    - -D 从规则链删除一个规则
    - -L 显示规则链上当前配置的规则
    - -F 删除当前iptables链上的全部规则
4. ${packet_pattern} 筛选需要进行检查的数据包
    1. -s 检查所有的数据包，确定它的源IP地址
    2. ...
5. -j ${what_to_do}
    1. DROP 丢弃数据包
    2. REJECT 丢弃数据包，且向请求计算机发送一个错误消息
    3. ACCEPT 对数据包进行-A选项相关动作的操作
    4. REDIRECT 重定向，主要用于实现端口重定向


```bash
# -p 指定协议， -p all 代表所有协议
# -m 指定要加载的模块
```

```bash
# 列出当前的iptables配置
iptables -L
iptables -t filter -L --line-number
iptables -t filter -L INPUT --line-number -n
iptables -t ${tabletype} -L ${direction} --line-number
# --line-number 显示编号
# -n 以数字格式显示地址和端口号I
# -v 显示详细信息


# 根据编号删除规则
iptables -t ${tabletype}  -D ${direction} ${line_number}
iptables -t nat  -D PREROUTING ${line_number}
iptables -t filter -D INPUT ${line_number}


# 端口转发
iptables -t nat -I PREROUTING -p tcp --dport 80 -m set --match-set kujiutest dst -j REDIRECT  --to-port 1080
iptables -t nat -I PREROUTING -p tcp -m multiport --dports 80,443 -m set --match-set kujiutest dst -j REDIRECT  --to-port 1080


# 禁止访问某个IP
iptables -A OUTPUT -d ${IP} -j REJECT


# 允许/禁止某个IP被访问
# IP=127.0.0.1 或 IP=192.168.0.1/16
iptables -A INPUT -j DROP #禁止其他所有流量进入
iptables -A INPUT -s ${IP} -j DROP # 禁止${IP}访问
iptables -A INPUT -p tcp --dport 8545 -j DROP  # 禁止所有IP访问8545端口
iptables -A INPUT -d ${IP} -p tcp --dport ${PORT} -j DROP  # 禁止所有IP通过TCP协议访问特${IP}:${PORT}
iptables -I INPUT -s ${IP} -p tcp --dport ${PORT} -j ACCEPT # 允许${IP}通过TCP协议访问本地的${PORT}端口


# 将本地的端口转发到本机端口
iptables -t nat -A PREROUTING -p tcp --dport 2222 -j REDIRECT --to-port 22
# 将本机的端口转发到其他机器
iptables -t nat -A POSTROUTING -d 192.168.172.131 -p tcp --dport 80 -j SNAT --to 192.168.172.130:80

iptables -t nat -F PREROUTING #清空nat表的PREROUTING链
iptables -F # 清空所有表格的所有链
```

### multiport扩展
- 以离散方式定义多端口匹配；最多匹配指定15个端口
```bash
iptables -I INPUT -p tcp -m multiport --dport 8545,8546 -j DROP 
```

### iprange扩展
- 指明连续的（但一般是不能扩展为整个网络）ip地址范围时使用.
```bash
# 指明连续的（但一般是不能扩展为整个网络）ip地址范围时使用
–src-range from[-to] # 指明连续的源ip地址范围
–dst-range from[-to] # 指明连续的目标IP地址范围

iptables -I INPUT -m iprange –src-range 192.168.1.1-192.168.1.10 -j DROP
```

### time扩展
- 根据报文到达的时间与指定的时间范围进行匹配
```bash
iptables -I INPUT -p tcp --dport 8545 -m time –timestart 00:00 –timestop 12:00 -j DROP
–datestart
–datestop

–monthdays
–weekdays
```

### ipset扩展
- ipset hash类型的集合默认大小为1024。当在iptables/ip6tables中使用了ipset hash类型的集合，则该集合将不能再新增条目。

```bash
# Centos安装ipset
yum install ipset

# ipset 查看所有的集合
ipset list
ipset list ${setname}

# ipset 创建blacklist集合
ipset create blacklist hash:ip hashsize 2048 maxelem 65536 timeout 0 # timeout表示多少秒后失效，0表示永久生效。集合的默认大小hashsize为2048；集合默认最大为65536
ipset -N blacklist iphash # 方式二

#  ipset 在blacklist集合中添加元素
ipset add blacklist ${IP1}

#ipset  删除blacklist集合里的某个元素
ipset del blacklist ${IP}

# ipset 导出blacklist集合规则进文件blacklist.txt
ipset save blacklist -f blacklist.txt

# ipset 删blacklist除集合
ipset destroy blacklist

# ipset 清空集合
ipset flush ${setname}

# ipset 从文件导入集合规则
ipset restore -f blacklist.txt
```

```bash
# iptables使用ipset
# ipset配合iptables使用方式
-m set --match-set ${setname} src/dst

# 禁止IP访问
ipset create blacklist hash:ip # 创建名为 blacklist 的集合，以 hash 方式存储，存储内容是 IP 地址
iptables -I INPUT -m set --match-set blacklist src -j DROP # 在集合 blacklist 里的IP将被过滤掉

# 只允许指定ip连接指定端口
iptables -I INPUT -m set --match-set whitelist src -d ${IP} -p tcp --dport ${PORT} -j ACCEPT # 通过whitelist的IP通过tcp协议访问${IP}:${PORT}
```
