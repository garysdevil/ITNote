---
created_date: 2023-11-14
---

[TOC]

## 镜像

- iso属于光盘镜像文件，vhd属于虚拟硬盘文件（微软出品）

## multipass

- https://multipass.run/install

```bash
# Launch an instance (by default you get the current Ubuntu LTS)
multipass launch --name foo

# Run commands in that instance, try running bash (logout or ctrl-d to quit)
multipass exec foo -- lsb_release -a

# See your instances
multipass list

# Stop and start instances
multipass stop foo bar
multipass start foo

# Clean up what you don’t need
multipass delete bar
multipass purge

# Find alternate images to launch
multipass find

# Pass a cloud-init metadata file to an instance on launch. See using cloud-init with multipass for more details
multipass launch -n bar --cloud-init cloud-config.yaml

# See your instances
multipass list

# Get help、
multipass help
multipass help <command>
```

## VMware vSphere PowerCLI

- - https://learn.microsoft.com/zh-cn/virtualization/hyper-v-on-windows/quick-start/try-hyper-v-powershell

```bash
# 显示 PowerShell 命令的可搜索列表
Get-Command -Module hyper-v | Out-GridView

# 查看某个指令的具体信息
Get-Help Get-VM

# 返回虚拟机列表
Get-VM

# 返回已启动的虚拟机列表
Get-VM | where {$_.State -eq 'Running'}

# 列出所有处于关机状态的虚拟机
Get-VM | where {$_.State -eq 'Off'}

# 启动所有当前已关机的虚拟机
Get-VM | where {$_.State -eq 'Off'} | Start-VM

# 关闭所有正在运行的虚拟机
Get-VM | where {$_.State -eq 'Running'} | Stop-VM

# 创建 VM 快照
Get-VM -Name 虚拟机名称 | Checkpoint-VM -SnapshotName 快照名称

# 创建新的虚拟机
New-VM -Name 虚拟机名字 -MemoryStartupBytes 虚拟机内存bit  -BootDevice VHD -VHDPath   "vhdx镜像地址"   -SwitchName 虚拟网卡的名称;
New-VM -Name vm001 -MemoryStartupBytes 536870912  -BootDevice VHD -VHDPath   "E:\hyper-v\vDisk\cq (1).vhdx"   -SwitchName "外部虚拟交换机";
New-VM -Name vm_1 -MemoryStartupBytes 1GB  -VMISOPath "D:\APP\ISO\cn_windows_7_ultimate_with_sp1_x86_dvd_u_677486.iso"
```

- 默认虚拟机目录 C:\\ProgramData\\Microsoft\\Windows\\Hyper-V
- 默认虚拟硬盘目录 C:\\ProgramData\\Microsoft\\Windows\\Virtual Hard Disks
