---
created_date: 2020-12-06
---

[TOC]

## firewalld
### 概念
- Redhat Enterprise Linux7已经默认使用firewalld作为防火墙

- 被封装过的iptables

- firewall划分不同的区域，不同的区域里可以指定不同的规则，不同的网卡可以指定使用不同的firewall区域，默认为public区域。

- 服务
 systemctl status firewalld.service

### firewall-cmd
- 参数
--permanent 永久设置
--runtime-to-permanent 将当前运行时的配置写入规则配置文件中，使当前内存中的规则为永久性配置。


1. 区域相关操作
默认情况下，默认区域是public
```bash
firewall-cmd --get-default-zone # 查看默认区域
firewall-cmd --set-default-zone=home # 配置默认区域
firewall-cmd --get-active-zones # 
firewall-cmd --permanent --new-zone=${zone-name} # 创建一个区域

```
2. 查看防火墙规则
```bash
# 查看防火墙规则(只显示/etc/firewalld/zones/public.xml中防火墙策略)
firewall-cmd --list-all 

# 查看所有的防火墙策略（即显示/etc/firewalld/zones/下的所有策略）
firewall-cmd --list-all-zones

# 查询端口是否开放
firewall-cmd --query-port=8080/tcp
```

3. 要想使配置的端口号生效,必须重新载入 
firewall-cmd --reload

4. 开放端口或服务 ``最后记得重载配置才生效 firewall-cmd --reload``
``` bash
# 开放80端口 和 移除端口
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --remove-port=8080/tcp
firewall-cmd --permanent --zone=public --add-port=80/tcp 

# 开放服务
firewall-cmd --add-service=${service} # 添加服务
firewall-cmd --remove-service=${service} # 移除服务
```

5. rich-rule
```bash
# 允许指定ip访问指定端口
port=22
ip=127.0.0.1
firewall-cmd --add-rich-rule="rule family=ipv4 source address=${ip} port protocol=tcp port=${port} accept"# 允许${ip}主机访问${port}端口
# --remove-rich-rule 删除
```
6. 端口转发
firewall-cmd --permanent --add-forward-port=port=80:proto=tcp:toport=8080:toaddr=134.175.167.56

7. 应急模式
```bash
firewall-cmd --panic-on  # 拒绝所有流量，远程连接会立即断开，只有本地能登陆
firewall-cmd --panic-off  # 取消应急模式，但需要重启firewalld后才可以远程ssh
firewall-cmd --query-panic  # 查看是否为应急模式
```