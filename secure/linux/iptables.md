
## iptables
- Linux的2.4版内核引入了一种全新的网络包处理引擎Netfilter，能为其它内核模块提供数据包过滤、网络地址转换、负载均衡等功能。
- iptables 命令是与Netfilter 系统进行交互的主要工具，用于提供数据包过滤和NAT。
- 基于“过滤规则链”的概念来阻止或转发流量。
- ip set 是linux内核的一个内部框架，ipset是iptables的扩展。

### 命令
- iptables -t ${tabletype} ${action_direction} ${direction}  ${packet_pattern} -j ${what_to_do}
1. ${tabletype}
     - -t 定义表类型 
     - filter、nat、mangle、raw; 默认为filter. （每张表提供了特定的功能）
2. ${direction} 5个方向(五链) （每个链都代表了数据需要经过的地点）
    1. PREROUTING 路由前的数据包
    2. FORWARD 转发的数据包
    2. INPUT 进入的数据包
    3. OUTPUT 传出的数据包
    4. POSTROUTING  路由后的数据包
    
3. ${action_direction} 
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
# 列出当前的iptables配置
iptables -L
iptables -t nat -L --line-number

# 根据编号删除规则
iptables -t nat -L --line-number
iptables -t nat  -D PREROUTING 1

# 端口转发
iptables -t nat -I PREROUTING -p tcp --dport 80 -m set --match-set kujiutest dst -j REDIRECT  --to-port 1080
iptables -t nat -I PREROUTING -p tcp -m multiport --dports 80,443 -m set --match-set kujiutest dst -j REDIRECT  --to-port 1080
# -m 指定要加载的模块

# 禁止访问某个IP
iptables -A OUTPUT -d ${IP} -j REJECT
```

### ipset
1. 安装
yum install ipset

2. 禁止IP访问
    ```bash
    ipset create blacklist hash:ip # 创建名为 blacklist 的集合，以 hash 方式存储，存储内容是 IP 地址
    # ipset -N blacklist iphash
    iptables -I INPUT -m set --match-set blacklist src -j DROP # 在集合 blacklist 里的IP将被过滤掉
    iptables -I INPUT -s ${IP} -j DROP
    ipset add blacklist ${IP1}
    ipset add blacklist ${IP2}
    # ipset add blacklist ...
    ipset list blacklist
    ```

3. 
```bash
# 查看所有的集合
ipset list
ipset list ${name}

# 规则保存进文件
ipset save blacklist -f blacklist.txt

# 删除ipset 集合
ipset destroy blacklist

# 导入ipset 集合
ipset restore -f blacklist.txt
```