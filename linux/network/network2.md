## iptables
iptables：administration tool for IPv4/IPv6 packet filtering and NAT
Linux的2.4版内核引入了一种全新的网络包处理引擎Netfilter，同时还有一个管理它的命令行工具iptables。

## gRPC
- 参考
https://grpc.io/docs/

1. 客户端应用可以像调用本地方法一样直接调用另一台机器上服务端应用的方法

2. 数据交换格式 ProtoBuf 

## 数据包
### Linux抓包
```bash
tcpdump -n -i eth0 'port 80' -s0 -w result.pcap
tcpdump -i eth1 udp # 协议过滤  
tcpdump -i eth0 dst ${HOST} and port ${PORT} # 抓取特定目标ip和端口的包

-X # 告诉tcpdump命令，需要把协议头和包内容都原原本本的显示出来（tcpdump会以16进制和ASCII的形式显示），这在进行协议分析时是绝对的利器。
-s snaplen  # snaplen表示从一个包中截取的字节数。0表示包不截断，抓完整的数据包。默认的话 tcpdump 只显示部分数据包,默认68字节。
-c # 指定抓包的数量，达到后终止
src host ${HOST} # 指定源地址为{HOST}
src port ${PORT} # 指定源端口为{PORT}
dst host ${HOST} # 指定目的地址为{HOST}
dst port ${PORT} # 指定目的端口为{PORT}
port ${PORT} # 目的或源端口是${PORT}的网络数据

tcpdump -r result.pcap # 读取抓取到的包
```
### 数据包分析
TCP Flags
```
* F : FIN - 结束; 结束会话
* S : SYN - 同步; 表示开始会话请求
* R : RST - 复位;中断一个连接
* P : PUSH - 推送; 数据包立即发送
* A : ACK - 应答
* U : URG - 紧急
* E : ECE - 显式拥塞提醒回应
* W : CWR - 拥塞窗口减少
```