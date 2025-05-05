---
created_date: 2025-01-24
---

[TOC]

## ssh 
```bash
# -o StrictHostKeyChecking=no 告诉SSH客户端不检查主机密钥数据库(/etc/ssh/ssh_known_hosts 或 ~/.ssh/known_hosts)，并自动接受第一次连接到的主机的公钥
ssh -p22 127.0.0.1 -i 私钥文件路径
```

```conf
# 客户端配置文件 ~/.ssh/config
# 定义ssh登入时默认使用的私钥
IdentityFile ~/.ssh/私钥文件名
```


```conf
# 服务端配置文件 /etc/ssh/sshd_config
# 更改完服务端配置文件需要重启ssh服务 service sshd restart

# 问题：用SSH客户端连接linux服务器时，经常会话连接中断。
# 解决方案：设置服务器向SSH客户端连接会话时发送的频率和时间。
ClientAliveInterval 60 # 定义了每隔多少秒给SSH客户端发送一次信号
ClientAliveCountMax 86400 # 定义了超过多少秒后断开与ssh客户端连接
```

```sh
# 免密登入
yum -y install openssh-clients # 此软件含ssh-copy-id指令
ssh-copy-id -i ~/.ssh/公钥文件名 # 被免密登陆的主机的IP
```

## 公钥
```bash
# 扫描其它机器的公钥
ssh-keyscan
# 生成公钥
ssh-keygen -C "备注信息" -t 算法类型
# authorized_keys   id_rsa  id_rsa.pub  know_hosts

# rsa 传统且广泛支持的算法，默认密钥长度为 2048 或 3072 位。
# ecasa 基于椭圆曲线的算法，密钥较短但安全性高，默认长度为 256、384 或 521 位。
# ed25519 现代、高效的椭圆曲线算法，固定长度为 256 位，安全性高且生成速度快。
# 在较新的 OpenSSH 版本中（例如 OpenSSH 7.0 及以上），默认算法可能不再是 RSA，而是更现代的 Ed25519 或 ECDSA，这可能是你在 Windows 环境下生成密钥时发现不是 RSA 的原因。
```

### ssh-agent
- 参考 https://wiki.archlinux.org/index.php/SSH_keys_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

- 普通登入方式 ssh -i 私钥文件路径 ${username}@${ip}
- ssh-agent 是一个代理程序，它能帮助我们管理我们的私钥
- ssh-add 把私钥密钥添加到ssh-agent的高速缓存中
```bash
eval $(ssh-agent) # ssh-agent bash --login -i  # ssh-agent bash
# 将私钥添加到高速缓存中
ssh-add -k 私钥文件路径
```

## VNC
- GUI客户端工具 https://www.realvnc.com/en/connect/download/viewer/

```bash
# Ubuntu 18.04和Ubuntu 20.04操作系统
# 安装
apt-get update

# 安装图图形化界面
apt install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal ubuntu-desktop #gnome
# apt install -y xfce4 xfce4-goodies # xfce

apt-get install tightvncserver -y

# 第一次启动需要设置VNC的登录密码，输入VNC登录密码和确认密码。如果自定义的密码位数大于8位，系统默认只截取前8位作为您的VNC登录密码。
vncserver :0

# 备份VNC的xstartup配置文件。
cp ~/.vnc/xstartup ~/.vnc/xstartup.bak

# 
vim ~/.vnc/xstartup
```

```conf
#!/bin/sh
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:GNOME"
export XDG_MENU_PREFIX="gnome-flashback-"
gnome-session --session=gnome-flashback-metacity --disable-acceleration-check &
```
```conf
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
```

```bash
# 启动一个GUI，名字为 :1
rm -f  /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1
vncserver :1 -rfbport 5901
vncserver -geometry 1920x1080 :1 -rfbport 5901 
# -localhost

# 列出所有的GPU
vncserver -list

# 杀掉某个GUI
vncserver -kill :1
```

```
export USER=root
export DISPLAY=:1
```
