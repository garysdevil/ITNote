---
created_date: 2020-11-16
---

[TOC]

### Keepalived
- 待补充lvs部分
1. 参考文档
    + https://www.keepalived.org/manpage.html 
    + http://m.elecfans.com/article/700023.html
    + https://www.cnblogs.com/clsn/p/8052649.html

2. keepalived：是开源负载均衡项目LVS的增强和虚拟路由冗余协议VRRP实现的集合，为Linux系统提供了负载均衡和高可用能力的服务软件。

3. 模块组成
    - core 模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。
    - check 模块负责健康检查。
    - vrrp 模块负责实现VRRP协议。

4. VRRP：虚拟路由冗余协议，是一种选择协议，是一种实现路由器高可用的协议。

5. 高可用原理：将N台提供相同功能的路由器组成一个路由器组，这个组里面有一个master和多个backup，master上面有一个对外提供服务的vip，master会发组播，当backup收不到vrrp包时就认为master宕掉了，这时就需要根据VRRP的优先级来选举一个backup当master。通过这个原理就可以保证路由器的高可用。


6. Centos安装keepalived
yum install keepalived -y

7. 文件信息
```bash
/etc/keepalived
/etc/keepalived/keepalived.conf     # keepalived服务配置文件
/etc/sysconfig/keepalived           # 服务启动脚本
/usr/bin/genhash
/usr/libexec/keepalived
/usr/sbin/keepalived
```

8. 配置信息
- /etc/keepalived/keepalived.conf
```conf
# 全局配置
 global_defs {              
    router_id LVS_DEVEL     # 定义路由标识信息，相同局域网唯一/必须配置

    notification_email {    # 定义报警邮件地址
      acassen@firewall.loc
      failover@firewall.loc
    } 
    notification_email_from Alexandre.Cassen@firewall.loc  # 定义发送邮件的地址
    smtp_server 192.168.200.1    # 邮箱服务器 
    smtp_connect_timeout 30      # 定义超时时间

    script_user root             # 执行脚本时配置否则会有警告
    enable_script_security       # 执行脚本时配置否则会有警告

 } 

# 自定义VRRP实例健康检查脚本，keepalived只能做到对自身问题和网络故障的监控，Script可以增加其它的监控来判定是否需要切换主备。
vrrp_script consul {
    script "cmd || shell_path"
    interval 2  # 执行脚本间隔
}

# 虚拟ip配置，实现高可用
vrrp_instance VI_1 {     # 定义实例
    state MASTER         # 状态参数 master/backup 只是说明
    interface eth0       # 虚IP地址放置的网卡位置，master节点会在此网卡上添加需IP
    virtual_router_id 51 # 同一个集群id一致，取值 1到255
    priority 100         # 优先级决定是主还是备，越大越优先
    advert_int 1         # 在局域网内发送组播的时间间隔
    authentication {     # 认证，集群内的配置需一致
        auth_type PASS
        auth_pass 1111
    }                         
    virtual_ipaddress {  # 设备之间使用的虚拟ip地址
        192.168.200.16    
        192.168.200.17
    }
    track_script {       # 启用脚本检查方式
        consul
    }
}

# 负载均衡配置 - 检验失败 - 当VIP调度非本机的真实IP时，web访问失败
```conf
# 虚拟ip配置，实现负载均衡
virtual_server 10.10.10.3 1358 { # 虚拟Ip
    delay_loop 3               # 健康检查时间间隔
    lb_algo rr                 # lvs调度算法rr|wrr|lc|wlc
    lb_kind NAT                # 负载均衡转发规则NAT|DR|RUN
    persistence_timeout 50     # 会话超时时间 
    protocol TCP

    real_server 192.168.200.4 1358 { # 配置真实IP
        weight 1    # 权重，取值-254..254，0无效
        HTTP_GET {  # 定义检查方式
            url {
              path /testurl/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d   #生成方式 genhash -s 192.168.2.188 -p 80 -u /testurl/test.jsp
              status_code 200                           
            }
            url {
              path /testurl2/test.jsp
              digest 640205b7b0fc66c1ea91c463fac6334d
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
    # real_server 192.168.200.5 1358 {...}

```
9. 启动
```bash
systemctl start keepalived
# 配置文件里定义了要使用的网卡和虚Ip，通过以下指令可以看到master的网卡上添加了一个虚IP
ip a 
```

10. ipvsadm
- 是linux下的LVS虚拟服务器的管理工具，LVS工作于内核空间，而ipvsadm则提供了用户空间的接口
```bash 
yum -y install ipvsadm

# 调整默认超时时间
ipvsadm -L --timeout
# Timeout (tcp tcpfin udp): 900 120 300
ipvsadm --set 1 2 1

# 查看所有的虚拟服务
ipvsadm -Ln

# 添加一个虚服务
ipvsadm -A -t 192.168.237.131:80 -s rr
ipvsadm -a -t 192.168.237.131:80 -r 192.168.237.171:80 -m
# 开启IP转发功能
echo 1 > /proc/sys/net/ipv4/ip_forward
```

11. 负载调度算法讲解
    - 轮询(rr)：将收到的访问请求按照顺序轮流分配给群集中的各个节点（真实服务器），均等地对侍每一台服务器，而不管服务器实际的连接数和系统负载。
    - 加权轮询(wrr)：根据真实服务器的处理能力轮流分配收到的访问请求，调度器可以自动查询各节点的负载情况，并动态调整其权重。这样可以保证处理能力强的服务器承担更多的访问流量。
    - 最少连接(lc)：根据真实服务器已建立的连接数进行分配，将收到的访问请求优先分配给连接数最少的节点。如果所有服务器节点性能相近，采用这种方式可以更好地均衡负载。
    - 加权最少连接(wlc)：在服务器节点的性能差异较大的情况下，可以为真实服务器自动调整权重，权重较高的节点将承担更大比例的活动连接负载。

12. 负载均衡模式
    - 网络地址转换(NAT)：类似于防火墙的私有网络结构，负载调度器作为所有服务器节点的网关，即作为客户机的访问入口，也是各节点回应客户机的访问出口。服务器节点使用私有IP地址。与负载调度器位于同一个物理网络，安全性要优于其他两种方式。
    - IP隧道(TUN)：采用开放式的网络结构，负载调度器仅作为客户机的访问入口，各节点通过各自的INTERNET连接直接回应客户机，而不再经过负载调度器。服务器节点分散在互联网中的不同位置。具有独立的公网IP地址，通过专用IP隧道与负载调度器相互通信。
    - 直接路由（DR）：采用半开放式的网络结构，与TUN模式的结构类似，但各节点并不是分散在各地，而是与调度器位于同一个物理网络。负载调度器与各节点服务器通过本地网络连接，不需要建立专用的IP隧道。

### 错误日志
1. 路由集群内的virtual_router_id和局域网内的其它路由集群的virtual_router_id有冲突
- 解决办法： 修改/etc/keepalived/keepalived.conf 配置文件里的 virtual_router_id 值
```log
Apr 01 17:32:58 garys-126 Keepalived_vrrp[47600]: VRRP_Instance(VI_1) Dropping received VRRP packet...
Apr 01 17:32:59 garys-126 Keepalived_vrrp[47600]: (VI_1): ip address associated with VRID 51 not present in MASTER advert : 172.16.212.118
Apr 01 17:32:59 garys-126 Keepalived_vrrp[47600]: bogus VRRP packet received on ens192 !!!
```

2. 可能是从windows上复制过来的字符问题
```log
Missing '{' at beginning of configuration block
Unknown keyword 'script'
Unknown keyword 'interval'
Unknown keyword '}'
```

3. 警告1
- 解决办法：在 /etc/keepalived/keepalived.conf 配置文件里增加 script_user
global_defs {
   script_user root
}
```log
WARNING - default user 'keepalived_script' for script execution does not exist - please create.
```

4. 警告2
解决办法：在 /etc/keepalived/keepalived.conf 配置文件里增加 enable_script_security
global_defs {
   enable_script_security
}
```log
SECURITY VIOLATION - scripts are being executed but script_security not enabled.
```


