---
created_date: 2020-11-30
---

[TOC]


## vagrant
- 参考 https://www.jianshu.com/p/0cabd5072b86
### 概念 
1. vagrant是一个工具，用于创建和部署虚拟化开发环境的。

2. VirtualBox Vagrant是一个开源软件，可以自动化虚拟机的安装和配置流程。基础设施即代码。

3. VirtualBox会开放一个管理虚拟机的接口，Vagrant会利用这个接口创建虚拟机，并且通过Vagrant来管理，配置和自动安装虚拟机。


### 指令
```bash
vagrant reload # 重启
vagrant halt # 关机
vagrant destroy # 销毁
vagrant ssh # 登录虚拟机，登录之后可以使用 ifconfig 命令查看虚拟机ip地址，然后使用Xshell登陆虚拟机
vagrant port # 查看端口映射列表

vagrant box list # 列出所有的虚拟机 
```