
## iptables
- Linux内核包含了强大的框架Netfilter，是其它内核模块能提供数据包过滤、网络地址转换、负载均衡等功能。
- iptables 命令是与Netfilter 系统进行交互的主要工具，用于提供数据包过滤和NAT。
- 基于“过滤规则链”的概念来阻止或转发流量。
### 命令
- iptables -t ${tabletype} ${action_direction} ${packet_pattern} -j ${what_to_do}
1. -t 定义表类型 filter、nat、mangle、raw; 默认为filter.
2. ${action_direction} 
    - -A 在规则链末尾添加一个规则
    - -D 从规则链删除一个规则
    - -L 显示规则链上当前配置的规则
    - -F 删除当前iptables链上的全部规则
3. 5个方向(五链)
    - INPUT 进入的数据包
    - OUTPUT 传出的数据包
    - FORWARD 转发的数据包
    - PREROUTING 路由前的数据包
    - POSTROUTING  路由后的数据包
4. ${packet_pattern} 筛选需要进行检查的数据包
    1. -s 检查所有的数据包，确定它的源IP地址
    2. ...
5. -j ${what_to_do}
    1. DROP 丢弃数据包
    2. REJECT 丢弃数据包，且向请求计算机发送一个错误消息
    3. ACCEPT 对数据包进行-A选项相关动作的操作

```bash
# 列出当前的iptables配置
iptables -L
```