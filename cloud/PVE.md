# 虚拟化系统程序

1. ESXi，是VMWare vSphere Hypervisor套件之下重要组件。前身是ESX，依赖Linux源码，后来抛弃Linux源码做成了ESXi。整个产品企业气息浓重，界面清晰易用，但硬件兼容性较差，没什么扩展性（毕竟不是linux）。

2. PVE，全称Proxmox Virtual Environment，是基于Debian的Linux系统，虚拟机内核为KVM。硬件兼容性优秀。界面功能不强，很多操作要靠命令行，但扩展能力几乎是无限的。

3. unRaid，其实是个NAS系统，是基于Slackware的Linux系统，虚拟机内核也是KVM。磁盘阵列管理非常有特色，灵活性很高。同时还有很不错的插件、Docker和虚拟机支持。

## Proxmox