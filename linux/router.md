---
created_date: 2022-06-27
---

[TOC]

## 路由器
- openwrt论坛 https://forum.gl-inet.com/
- openwrt安装v2ray https://github.com/kuoruan/openwrt-v2ray
    - mips_siflower架构版本 https://github.com/kuoruan/openwrt-v2ray/issues/171

### 嵌入式设备
- 安装包 ipk
- 包管理工具 opkg
```bash
opkg update # 更新可以获取的软件包列表
opkg upgrade # 对已经安装的软件包升级
opkg list # 获取软件列表
opkg install ${package_name} # 安装指定的软件包
opkg remove # 卸载已经安装的指定的软件包

# 打印系统架构
opkg print-architecture
```

```bash
wget https://github.com/aspark/openwrt-v2ray/releases/download/v5.1.0-1/v2ray-core_5.1.0-1_mips_siflower.ipk
opkg install ./v2ray-core_5.1.0-1_mips_siflower.ipk 
/usr/bin/v2ray 
```