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

### ftp
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

### kvm  等待实践
1. 依赖的内核模块是否已经被加载
```bash
lsmod | grep kvm
modprobe kvm_intel
modprobe kvm_amd # amd处理器
```
2. 使用kvm虚拟化技术安装虚拟机  
    **未实践操作过**  
    1. virt-install
    2. virsh
    3. Kickstart

