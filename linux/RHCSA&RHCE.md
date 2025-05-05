---
created_date: 2020-11-16
---

[TOC]

## RHCSA
- 考核物理系统和虚拟系统上配置网络连接、系统安全、自定义文件系统、软件更新和用户管理等操作能力。
- 2.5小时

## 必备命令
1. 创建引导U盘， dd 块复制覆盖
dd  if=image.name of=/dev/sdc bs=512k
2. 


## RHCE
- 3.5小时
- 若欲取得红帽RHCA认证，您必须通过以下考试中的任意5门考试：
- 考试代码 认证名称
    1. EX210 红帽 OpenStack 认证系统管理员考试
    2. EX220 红帽混合云管理专业技能证书考试
    3. EX236 红帽混合云存储专业技能证书考试
    4. EX248 红帽认证 JBoss 管理员考试
    5. EX280 红帽平台即服务专业技能证书考试
    6. EX318 红帽认证虚拟化管理员考试
    7. EX401 红帽部署和系统管理专业技能证书考试
    8. EX413 红帽服务器固化专业技能证书考试
    9. EX436 红帽集群和存储管理专业技能证书考试
    10. EX442 红帽性能调优专业技能证书考试

## ftp
1. 安装
yum -y install vsftpd
2. 端口
    1. 控制端口 21
    2. 数据端口 
        - 主动模式 传输数据时 启动20端口去连接客户端
        - 被动模式 传输数据时 和客户端协议随机启动一个大于1024的端口号，让客户端来连接
3. 配置/etc/vsftpd/vsftpd.conf
```conf
# 主动模式
connect_from_port_20=YES
pasv_enable=NO
# 被动模式
connect_from_port_20=NO
pasv_enable=YES
pasv_min_port=1024 # (default:0(use any port))
pasv_max_port=65536 # (default:0(use any port))
```

4. 添加新用户
```bash
# 增加用户gary，并指定gary用户的主目录为/data/gary
useradd -d /data/gary gary
passwd gary
usermod -s /sbin/nologin gary
# 从2.3.5之后，vsftpd增加了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报错。
chmod a-w /data/gary # 去除用户主目录的写权限 或者增加一行vsftpd配置 allow_writeable_chroot=YES
```

## kvm  等待实践
1. 查看依赖的内核模块是否已经被加载
```bash
lsmod | grep kvm
modprobe kvm_intel
modprobe kvm_amd # amd处理器
```
2. 使用kvm虚拟化技术安装虚拟机  
    **未实践操作过**  
    1. virt-install
    2. virsh
    3. Kickstart 自动化安装

## 工具
1. mail
如果本地启动了SMTP，25端口
echo 'test' | mail -s '主题'   xxx@qq.com

2. 命令行浏览器
yum install elinks
elinks http://baidu.com

3. ftp客户端
ftp
lftp 自动尝试匿名登录

## 指令
1. alias
创建指令别名  
alias ll='ls -l'

2. grep
-v 取反
-e 通过多个-e指定不同的正则表达式，或的关系

## RHEL7 新网络工具
### ip
1. ip addr
2. ip addr add 192.168.122.150/24 dev eth0
3. ip neigh 显示ARP表
4. ip route 显示路由表
5. ss -tuna4 显示监听的端口

6. ip link set dev ${device} up 启用指定接口

### 网络配置工具
- nmcli
    1. 查看是否启动了网络管理器
    systemctl status NetworkManager
    网络管理器包含了 nmcli 命令行工具

    2. 
    nmcli con reload
    nmcli con down eth0
    nmcli con up eth0

- nmtui

## 安全选项
1. drwxrwxrwt.  
最后的t表示开启‘粘滞’，功能为此目录下只有文件所有者才能删除此文件。

2. 特殊文件属性
    1. lsattr
    2. chattr 
        1. +i  设置root用户也无法删除此文件
        2. +a 只可以添加内容

3. umask
定义创建文件和文件夹时的默认文件权限
设置/etc/profile /etc/bashrc

4. 访问控制列表 acl  ---- 未细看，运维生涯上未使用过此功能
    1. getfacl
    2. setfacl

4. SELinux  未看
    1. 安全模型：主题、对象、动作
        - 主题：进程
        - 对象：可以被主题访问的资源
        - 动作
    2. 查看文件上下文 ls -Z
    3. /etc/selinux/config
    4. 三种配置模式：enforcing  permissive  disabled

## 引导过程
- **待学习和实践**

## 文件系统相关
- fdisk用于管理在BIOS固件上使用传统的MBR分区方案创建的分区。
- gdisk 和 parted 用于管理在UEFI固件上使用GUID方案创建的分区表GPT。
1. findmnt 以树状态格式显示所有已挂载的文件系统