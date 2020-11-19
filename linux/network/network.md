## iptables
iptables：administration tool for IPv4/IPv6 packet filtering and NAT
Linux的2.4版内核引入了一种全新的网络包处理引擎Netfilter，同时还有一个管理它的命令行工具iptables。

## route
- 参考
https://ivanzz1001.github.io/records/post/linuxops/2018/11/14/linux-route
1. Linux系统的route命令用于显示和操作IP路由表（show/manipulate the IP routing table)。
2. 要实现两个不同的子网之间的通信，需要一台连接两个网络的路由器，或者同时位于两个网络的网关来实现。
3. 在Linux系统中，设置路由通常是为了解决一个问题：该Linux系统在一个局域网中，局域网中有一个网关，能够让机器访问internet，那么就需要将网关地址设置为该Linux机器的默认路由。

4. 查看路由表 route -n
Destination: 目标网络(network)或者目标主机(host)。
Gateway: 网关地址，*表示并未设置网关地址。
Genmask: 子网掩码。其中’255.255.255’用于指示单一目标主机；’0.0.0.0’用于指示默认路由，表示所有地址通过对应的网关进行转发。

5. 配置缺省网关
```bash
route del default gw 10.0.0.254 # 删除默认网关
route add default gw 10.0.0.254 # 添加默认网关

# 或者
route add -net 0.0.0.0 netmask 0.0.0.0 gw 10.0.0.254
```

## ifconfig
1. 配置临时网卡
ifconfig eth0:0 192.168.6.100 netmask 255.255.255.0 up
ifconfg eth0:0 down