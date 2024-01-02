- GUI客户端工具 https://www.realvnc.com/en/connect/download/viewer/

```bash
# 参考 https://help.aliyun.com/zh/simple-application-server/use-cases/use-vnc-to-build-guis-on-ubuntu-18-04-and-20-04#21e0b772d7fgc
# Ubuntu 18.04和Ubuntu 20.04操作系统
# 安装

apt-get update

apt install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal ubuntu-desktop

apt-get install tightvncserver -y

# 第一次启动需要设置VNC的登录密码，输入VNC登录密码和确认密码。如果自定义的密码位数大于8位，系统默认只截取前8位作为您的VNC登录密码。
vncserver

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

```bash
# 启动一个GUI，名字为 :1
vncserver :1 -rfbport 5901
vncserver -geometry 1920x1080 :1 -rfbport 5901 -localhost 0.0.0.0

# 列出所有的GPU
vncserver -list

# 杀掉某个GUI
vncserver -kill :1
```

```bash
apt-get install xdotool
# yum install xdotool

# 获取鼠标位置
xdotool getmouselocation   

# 将鼠标移动到（X，Y）坐标为（153,63）的位置
xdotool mousemove 153 63

# 单击左键
xdotool click 1
# 双击左键
xdotool click 1 click 1

# 移动鼠标并单击
xdotool mousemove $x $y click 1

# 模拟击键使用命令
xdotool key $key
# 切换窗口组合键 Alt+Tab
xdotool key alt+Tab

# 输入
xdotool type ''
```