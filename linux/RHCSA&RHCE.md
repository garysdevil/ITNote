# RHCSA
- 考核物理系统和虚拟系统上配置网络连接、系统安全、自定义文件系统、软件更新和用户管理等操作能力。
- 2.5小时

## 

## 必备命令
1. 创建引导U盘， dd 块复制覆盖
dd  if=image.name of=/dev/sdc bs=512k
2. 


# RHCE
- 
- 3.5小时

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
pasv_min_port=1024(default:0(use any port))
pasv_max_port=65536(default:0(use any port))
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

2. 命令行游览器
yum install elinks
elinsk http://baidu.com

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
