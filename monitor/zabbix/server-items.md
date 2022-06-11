[TOC]

- 基于3.4版本
- 监控项参考文档
    https://www.cnblogs.com/wyzhou/p/10832442.html
    https://www.zabbix.com/documentation/3.4/manual/config/items/itemtypes/zabbix_agent
    https://www.zabbix.com/documentation/3.4/manual/appendix/items

## 监控项
1. 监控项接口
    - agent、jmx、impi、snmp

2. 监控项类型
    - Zabbix agent, Zabbix trapper, Simple checks, SNMP, Zabbix internal, IPMI, JMX monitoring ...

3. 监控项item名称
    - 监控项item名称可以使用宏变量：$1, $2…$9，这9个参数对应item key的参数位置。
    - 例如： Free disk space on $1
    - 如果item key为“vfs.fs.size[/,free]”,那么对应的名称会变成”Free disk space on /“，$1对应了第一个参数”/“

4. 主动模式下一个正常的监控项获取数据的过程
    ```
    Server opens a TCP connection
    Server sends agent.ping\n
    Agent reads the request and responds with <HEADER><DATALEN>1
    Server processes data to get the value, '1' in our case
    TCP connection is closed
    ```

5. 从Zabbix 3.4版本后，监控项多了一个功能Preprocessing，在监控项收集的数据存储到数据库前，可以预先对数据进行处理。

## Zabbix agent监控项
- 一些常用的监控项
  
1. Agent
    1. agent可达性：agent.ping 
2. 操作系统 system
    1. 当前登录到系统中的用户数量 system.users.num
    2. CPU的利用率system.cpu.util[<cpu>,<type>,<mode>]
    3. 获取cpu硬件的信息 system.hw.cpu[<cpu>,<info>] 
    4. 在agent上运行指令 system.run[command,<mode>] 
        - agent配置文件必须有此条配置 EnableRemoteCommands=1
3. 日志信息 log  logrt  
    - 只支持 active 模式
    1. 日志文件监控 log[file,<regexp>,<encoding>,<maxlines>,<mode>,<output>,<maxdelay>] 
        - 例如 查看日志文件里面是否有错误 log[/var/log/syslog,error]
4. 网络信息(Network interfaces) net
    1. 网卡流出的流量：net.if.out[network interface name,mode]
    2. 网卡流入的流量：net.if.in[network interface name,mode]
    3. TCP端口是否处于监听状态 net.tcp.listen[port]
    4. TCP端口是否能被连接 net.tcp.port[<ip>,port] 
    5. 服务是否是运行状态且是否能进行TCP连接 net.tcp.service[service,<ip>,<port>] 
5. 进程监控
    1. 进程的CPU利用率 proc.cpu.util[<name>,<user>,<type>,<cmdline>,<mode>,<zone>] 
    2. 进程的内存使用情况 proc.mem[<name>,<user>,<mode>,<cmdline>,<memtype>] 

6. 文件系统监控
    1. 磁盘读取数据监控 vfs.dev.read[<device>,<type>,<mode>] 
    2. 检索文件是否存在 vfs.file.exists[file]
    3. 查找文件中的字符串，返回匹配的那行字符串 vfs.file.regexp[file,regexp,<encoding>,<start line>,<end line>,<output>]
    4. 目录大小监控 vfs.dir.size[dir,<regex_incl>,<regex_excl>,<mode>,<max_depth>]
    5. 检验文件是否存在 vfs.file.exists[filepath]
    6. 磁盘空间 vfs.fs.size[fs,<mode>]

7. 内存
    1. 获取内存信息 vm.memory.size[<mode>] 

8. web监控
    1. 获取web界面的加载时间    web.page.perf[host,<path>,<port>] 
9. 安全信息
    1. 获取文件校验值 vfs.file.cksum[/etc/passwd]

## 自定义监控项
```conf
UserParameter=device.tps[*],Device=$1 && iostat -d -k ${Device} | grep "${Device} "  | awk '{printf("%f",$2)}'
UserParameter=device.kB_read[*],Device=$1 && iostat -d -k ${Device} | grep "${Device} "  | awk '{printf("%f",$3)}'
UserParameter=device.kB_write[*],Device=$1 && iostat -d -k ${Device} | grep "${Device} "  | awk '{printf("%f",$4)}'
```