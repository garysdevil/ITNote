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

## 网络工具
### nc 使用TCP或UDP协议跨网络连接读写数据
    1. 检测端口是否在监听 nc -v -z ip port
    2. 监听 nc -l -u -k 8080 -e /bin/bash
    3. 一个简单的静态web页面服务器
        while true;do  nc -l 88  < somepage.html; done

### nmap 网络探索和安全审计的开源工
rpm -vhU http://nmap.org/dist/nmap-5.21-1.i386.rpm
rpm -vhU http://nmap.org/dist/zenmap-5.21-1.noarch.rpm

1. 四种基本的扫描方式：
    1. TCP connect()端口扫描（-sT参数）。
    2. TCP同步（SYN）端口扫描（-sS参数）。
    3. UDP端口扫描（-sU参数）。
    4. Ping扫描（-sP参数）。

2. 扫描 默认会扫描1-1024端口和其他一些常用端口
    nmap -sS -p 0-30000 127.0.0.1

3. 扫描结果分析
    Open 端口在监听中
    filtered 防火墙，过滤器或者其它网络障碍阻止了该端口被访问，Nmap 无法得知 它是 open还是 closed   
    closed 端口未被监听  
    unfiltered 无法确定端口是关闭还是开放时   
    open filtered 监听或者被过滤的  
    closed filtered 关闭或者被过滤的  



### dstat 是一个用来替换vmstat、iostat、netstat、nfsstat和ifstat这些命令的工具，是一个全能系统信息统计工具
- 分组含义及子项字段含义
    ```yaml
    CPU状态: CPU的使用率。显示了用户占比，系统占比、空闲占比、等待占比、硬中断和软中断情况。
    磁盘统计: 磁盘的读写，分别显示磁盘的读、写总数。
    网络统计: 网络设备发送和接受的数据，分别显示的网络收、发数据总数。
    分页统计: 系统的分页活动。分别显示换入（in）和换出（out）。
    系统统计: 统计中断（int）和上下文切换（csw）。
    ```
- 测网速
    nc -l 9999 >/dev/null
    nc IP 9999 </dev/zero
    dstat