---
created_date: 2024-01-02
---

[TOC]

## 安装GUI

```bash
# 安装gnome客户端
sudo apt update
sudo apt upgrade -y
sudo apt install -y ubuntu-desktop
sudo dpkg-reconfigure gdm3
systemctl start gdm3
```

## 自动化点击

```bash
apt-get install xdotool -y
# yum install xdotool -y

# 获取鼠标位置
g  

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
