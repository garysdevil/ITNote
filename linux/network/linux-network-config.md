
### Linux重启网卡的三种方法：
1. network
service networking restart
或者/etc/init.d/networking restart
2. ifdown/ifup
ifdown eth0
ifup eth0
3. ifconfig
ifconfig eth0 down
ifconfig eth0 up

### Ubuntu16配置
- 网关,IP,DNS
1. vi /etc/network/interfaces 
```conf
iface eth0 inet static
address 192.168.1.3
netmask 255.255.255.0
gateway 192.168.1.1
dns-nameservers 114.114.114.114 8.8.8.8
```
2. 修改后重置网卡
ip addr flush ens32
systemctl restart networking

3. 使用ifconfig命令配置 网关,IP（临时生效）
ifconfig eth0 192.168.0.1 netmask 255.255.255.0 up

### Ubuntu18.04配置
1. 配置
- 网关,IP,DNS
vi /etc/netplan/50-cloud-init.yaml
```yaml
network:
    ethernets:
        eth160:
            addresses: [172.26.12.76/24]
            gateway4: 172.26.12.254
            nameservers:
                    addresses: [114.114.114.114,8.8.8.8]
    version: 2
```
netplan apply

2. 查看
systemctl status systemd-networkd
networkctl status 

### Centos7.5配置
1. 查看网卡
    ip a
2. 编辑配置文件
cd /etc/sysconfig/network-scripts
vi 网卡所在的文件
```conf
TYPE=Ethernet # 网络类型
NAME=eth0 # 网卡名称

BOOTPROTO=static # 默认dhcp,改为static,表示启用静态IP地址
ONBOOT=yes # 开启自动启用网络连接
IPADDR=192.168.1.73 # 静态IP地址，如果使用虚拟机桥接模式，静态IP一定要和主机在同一个网段，且IP唯一未被使用
GATEWAY=192.168.1.254 # 网关，需和公网主机配置的网关一致
NETMASK=255.255.255.0 # 子网掩码，需和公网主机配置的网关一致
DNS1=8.8.8.8 # 第一个dns服务器，BOOTPROTO=static 的时候不会自动生成DNS解析，最好在这里也一并配置上
```

## 其它
### ifconfig
1. 配置临时网卡eth0:0
ifconfig eth0:0 192.168.6.100 netmask 255.255.255.0 up
2. 删除网卡
ifconfg eth0:0 down