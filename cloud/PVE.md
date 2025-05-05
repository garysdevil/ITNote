---
created_date: 2021-05-12
---

[TOC]

# 虚拟化系统程序

1. ESXi，是VMWare vSphere Hypervisor套件之下重要组件。前身是ESX，依赖Linux源码，后来抛弃Linux源码做成了ESXi。整个产品企业气息浓重，界面清晰易用，但硬件兼容性较差，没什么扩展性（毕竟不是linux）。

2. PVE，全称Proxmox Virtual Environment，是基于Debian的Linux系统，虚拟机内核为KVM。硬件兼容性优秀。界面功能不强，很多操作要靠命令行，但扩展能力几乎是无限的。

3. unRaid，其实是个NAS系统，是基于Slackware的Linux系统，虚拟机内核也是KVM。磁盘阵列管理非常有特色，灵活性很高。同时还有很不错的插件、Docker和虚拟机支持。

4. KVM + OpenStack

## Proxmox

- 参考

  - https://pve.proxmox.com/pve-docs/

- 安装方式

  - 方式一：直接通过PVE的ISO安装
  - 方式二：先装Debian再添加proxmox的安装源来安装

- 默认路径

  - iso存放路径： /var/lib/vz/template/iso/
  - 备份路径： /var/lib/vz/dump/

### 指令

1. 查看集群状态

   - pvecm status

2. 重启PVE服务8006端口
   service pveproxy restart && service pvedaemon restart

3. 解锁VM
   qm unlock ${PVE_VM_ID}

4.

### 相关工具

#### 定时快照工具

- 参考

  - https://github.com/Corsinvest/cv4pve-autosnap
  - http://blog.heishacker.com/Proxomox-autosnapshot

- cv4pve-autosnap

```bash
# 下载解压
https://github.com/Corsinvest/cv4pve-autosnap/tags
# 在PVE的web界面创建用户,并且给予 VM.Audit 和 VM.Snapshot 权限

#  创建快照
./cv4pve-autosnap --host 127.0.0.1 --username ${username} --password ${password} --vmid ${vmid} snap --label 'daily' --keep=7 --state

```
