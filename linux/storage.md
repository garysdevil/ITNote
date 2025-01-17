[TOC]
# 硬盘和磁盘
## 概念
- 硬盘和磁盘
	- 硬盘（Hard Disk）是计算机中用于存储数据的硬件设备，属于存储介质的一种。
	- 磁盘（Disk）是一个更广泛的概念，通常指存储数据的盘状介质，可以是物理的，也可以是逻辑上的。

- 硬盘分类
	- 最快的固态 Nvme
	- 固态硬盘 SSD(Solid State Drives)
	- HDD 机械硬盘
		- 机械硬盘 SAS
		- 最慢的机械硬盘 SATA

## 磁盘扩容/非关机状态下
- 添加新硬盘进行扩容，重新扫描SCSI总线来添加设备 
	echo "- - -" >  /sys/class/scsi_host/host最大的序号/scan
- 在原有硬盘上进行扩容 
	echo '1' > /sys/class/scsi_disk/对应的硬盘/device/rescan

## 磁盘分区
### 情景一 2T以下磁盘
#### 交互式
1. 查看所有磁盘的分区。
	- fdisk -l
2. 进入磁盘进行分区。
	1. fdisk /dev/sdb
	2. 依次输入如下指令进行分区：
		1. n 创建新磁盘
		2. p 创建主分区
		3. 创建分区ID 1-4为主分区（回车即可）
		4. 根据提示选择磁盘开始位置（回车即可）
		5. 选择结束位置（回车即可）
	3. 更改partition's system id为Linux LVM
		1. t
		2. 8e
	4. 查看此磁盘的分区
		1. p 
	5. 输入 wq 保存退出。
	
3. 通知系统内核分区表的变化 partprobe /dev/sdb # install parted
#### 非交互式
- vi fdisk.txt
```
n
p
1


t
8e

p
wq
```
```bash
fdisk /dev/sdb < fdisk.txt
partprobe /dev/sdb # install parted # 通知系统内核分区表的变化
```

### 情景二 2T以上磁盘：
```bash
# 交互式操作
parted /dev/sdb

# 创建一个分区表，分区表类型为gpt
parted /dev/sdf mklabel gpt
# 进行分区  模版： parted /dev/sdf mkpart 1/primary/2/extended 文件系统格式 开始位置 结束位置
parted /dev/sdf mkpart 1 ext4 1 5.5T 
parted /dev/sdf mkpart primary ext4 1 100%

# 查看所有分区
parted -l
# 查看分区
parted -s /dev/sdf print
# 删除分区
parted -s /dev/sdf rm ${number}
```

## 其它指令
1. Linux查看硬盘是固态还是机械
```bash
# ROTA为0表示不可以旋转，就是SSD  # 1 代表是机械硬盘，0 则就是 ssd 

# 查看某个磁盘类型 方式一
cat /sys/block/{block_name}/queue/rotational
# 查看所有磁盘类型 方式二
grep ^ /sys/block/*/queue/rotational
# 查看所有磁盘类型 方式三
lsblk -d -o name,rota
```
2. 查看硬盘信息
```sh
### hdparm（即硬盘参数）是Linux的命令行程序之一，用于处理磁盘设备和硬盘。借助此命令，您可以获得有关硬盘，更改写入间隔，声学管理和DMA设置的统计信息。
disk=/dev/sda
hdparm  ${disk} # 显示指定硬盘的相关信息
hdparm -t ${disk} # 评估硬盘读取效率
```
3. 查看磁盘信息
```sh
# 1. 查看所有块设备信息 
lsblk -m
# 2. 打印磁盘信息 
blkid 
# 3. 查看磁盘分区
cat /proc/partitions
lsblk
fdisk -l
```

## 存储方式

### 1. 块存储
- 概述：裸盘，不能直接被操作系统访问。必须通过RAID、LVM等技术格式化为文件系统后才能使用。
- 特点：
  - 高性能，适合数据库和虚拟机磁盘等场景。

### 2. 文件存储
- 概述：数据和元数据一起存储。最小存储单元为文件系统的簇（如4KB）。
- 特点：
  - 支持POSIX文件访问接口（如open、read、write等）。
- 类型：
    1. 本地文件存储：ext3、ext4、NTFS、FAT32、XFS。
    2. 网络文件存储：NFS、CIFS。

### 3. 对象存储
- 概述：分布式存储系统，数据以对象形式存储，每个对象包括数据、元数据和唯一标识符。
- 特点：
  - 高扩展性，适合海量数据存储。
  - 包括元数据服务器和分布式存储节点（OSD）。

# 块存储
## LVM
- LVM是在磁盘分区和文件系统之间添加的一个逻辑层,目的在于解决磁盘扩容问题。
- 物理卷: pv ; 卷组: vg ; 逻辑卷: lv 
- 可以简单理解pv对应着物理分区，lv对应着文件夹，vg为pv与lv的纽带。
	
### LVM查询操作 
```bash
# 1. 先查看所有的逻辑卷
lvs  #或者 lvdisplay
# 2. 先查看所有的卷组
vgs
# 3. 先查看所有的物理卷
pvs
# 4. 其它查询操作
lvscan，vgscan，pvscan
```

### 进行LVM操作
```bash
# 0. 如果没有lvm 则 
yum -y install lvm2
# 1. 初始化硬盘为物理卷pv： pvcreate 磁盘或者分区的位置
pvcreate /dev/sdb1
# 2. 创建卷组vg：vgcreate  vg名称  pv地址1 pv地址2
vgcreate vg_data /dev/sdb1 /dev/sdb2
# 3. 创建逻辑卷lv：lvcreate -n 逻辑卷名称 -L  磁盘大小  卷组名字（假设vg大小为2000g,则磁盘一般最大设置为1999.98G）
lvcreate -n lv_data -L 1999.99G vg_data
# 4. 格式化lvm, mkfs.文件系统 /dev/卷组名称/逻辑卷名称
mkfs.xfs /dev/vg_data/lv_data
mkfs.ext4 /dev/vg_data/lv_data
# 5. 写入 /etc/fstab 文件，使机器每次开机自动挂载磁盘：/dev/卷组名称/逻辑卷名称 挂载的磁盘目录 磁盘格式 default 0 0
mkdir /data
echo '/dev/vg_data/lv_data   /data   xfs    defaults    0  0'  >> /etc/fstab
# 6. 根据配置文件重新执行挂载操作
mount -a

#  单独挂载某个磁盘
mount -t xfs /dev/磁盘分区地址  /目录
```
### 添加新pv扩容现有的lvm逻辑卷
- 思路：创建新的PV---将新的PV加入到当前VG---扩容现有LV---扩容文件系统
```bash
# 1. 创建新的pv：pvcreate 磁盘路径
pvcreate /dev/sdb2
# 2. 将新的PV加入到当前VG：vgextend 现有的vg名称 PV的绝对路径
vgextend  vg_data /dev/sdb2
# 3. 扩容现有的lv （lvdisplay查看lv信息） vextend -L +需要扩的空间 现有逻辑卷的绝对路径
lvextend -L +9999G /dev/vg_data/lv_data
# 4. 扩容文件系统：xfs_growfs /dev/卷组名/逻辑卷名
xfs_growfs /dev/vg_data/lv_data  # （扩容xfs格式）
resize2fs /dev/vg_data/lv_data   # （扩容ext格式）
```

### 删除LVM卷
- 顺序：卸载磁盘，删除逻辑卷，删除卷组，删除物理卷。
```bash
# - 查看目前磁盘的挂载情况 df -h

# 1. 卸载文件系统： umount 文件夹的绝对路径 
umount /data
# 2. 删除逻辑卷：lvremove /dev/卷组/逻辑卷  
lvremove /dev/vg_data/lv_data
# 2. 删除卷组：vgremove 卷组名
vgremove vg_data
# 3. 删除物理卷：pvremove 物理卷地址
pvremove /dev/sdc 
```

## RAID
- RAID
    1. RAID 0：条带化，分片，提供高性能，无冗余。（一块磁盘以上）
    2. RAID 1：镜像备份，数据冗余，有容错。（只能有两块磁盘）
    3. RAID 5：条带化 + 奇偶校验，平衡性能和冗余。（3块磁盘以上）
    4. RAID 6：类似 RAID 5，多一组奇偶校验，更高容错。
    5. RAID 10：RAID 1 + RAID 0，既有性能又有冗余；先备份后分片。（4块磁盘以上）

### 创建RAID
```sh
# 下载 mdadm
apt update && sudo apt install -y mdadm  # Debian/Ubuntu
yum install -y mdadm  # CentOS/RHEL

# 使用7块磁盘做 RAID 0
# --level=0 表示做 RAID 0
# --chunk=256 表示条带单元大小为256; 512-B; XFS 对 log stripe unit 有更小的限制（最大 256KiB）
mdadm --create --verbose /dev/md0 --level=0 --chunk=256 --raid-devices=7 /dev/nvme[1-7]n1

# 查看 RAID 状态
cat /proc/mdstat
mdadm --detail /dev/md0

# 格式化 RAID 设备
mkfs.xfs -f /dev/md0 # 或 mkfs.ext4 /dev/md0
xfs_info /dev/md0 # 查看文件系统信息

# 确保开机自动挂载
mkdir /data1
blkid /dev/md0  # 获取 UUID
echo 'UUID=<UUID> /data1 xfs defaults 0 0'  >> /etc/fstab
# 刷新
mount -a

# 保存 RAID 配置
mdadm --detail --scan >> /etc/mdadm/mdadm.conf  # Debian/Ubuntu  
# mdadm --detail --scan >> /etc/mdadm.conf       # CentOS/RHEL
```
### 删除RAID
```sh
# 确保 RAID 未被使用，卸载挂载点
umount /mnt/data1
# 停止 RAID 阵列并释放设备
mdadm --stop /dev/md0
# 从阵列中移除磁盘
mdadm --remove /dev/md0
# 清除 RAID 超级块
mdadm --zero-superblock /dev/nvme[1-7]n1
# 清理配置文件，移除已删除阵列的条目
vim /etc/mdadm/mdadm.conf
update-initramfs -u
```

# 文件存储
## NFS
- 参考
  - https://ubuntu.com/server/docs/service-nfs

- NFS 即网络文件系统（Network File-System），可以通过网络让不同机器、不同系统之间可以实现文件共享。通过 NFS，可以访问远程共享目录，就像访问本地磁盘一样。
- NFS 只是一种文件系统，本身并没有传输功能，是基于 RPC（远程过程调用）协议实现的，采用 C/S 架构。
- NFS 是由Sun公司开发的，于1984年向外公布。
- 
### 服务端 Server
```bash
# 在ubuntu系统上安装 # install NFS in ubuntu 
apt install nfs-kernel-server
# 启动 # start
systemctl start nfs-kernel-server.service
systemctl status nfs-kernel-server.service

# 创建被挂载的目录
mkdir -p /tank1/nfs1
mkdir -p /tank1/nfs2
mkdir -p /tank1/nfs3
# 编辑配置文件 # edit configuration file
vim /etc/exports
# 检查配置语法正确性 check configuration
exportfs -rv
# 应用配置 # apply configuration
exportfs -a
```

```conf
/tank1/nfs2 *(ro,insecure,sync,no_subtree_check)
# 只有特定的IP才能访问
/tank1/nfs3 ${IP}(rw,insecure,async,no_root_squash,no_subtree_check)

# sync： 将数据同步写入内存缓冲区与磁盘中，效率低，但是可以保证数据的一致性；
# async： 将数据先保存在内存缓冲区中，必要时才写入磁盘；
# wdelay： 检查是否有相关的写操作，如果有则将这些写操作一起执行，这样可以提高效率。（默认配置）
# no_wdelay： 若有写操作立即执行，应与sync配合使用；
```

### 客户端 Client
```bash
apt install nfs-common


# 创建目录 create folder
mkdir -p /opt/example1
mkdir -p /opt/example2
mkdir -p /opt/example3

# 
mount ${IP}:/tank1/nfs1 /opt/example1
# 以只读的方式挂载（这种方式是只读，不可创建文件夹等操作.会报错read-only file system）
mount -t nfs -o ro,bg,soft,nolock ${IP}:/tank1/nfs2 /opt/example2
# 以写的方式挂载（挂载成功后正常读写主机文件与文件夹
mount -t nfs -o rw,bg,soft,nolock ${IP}:/tank1/nfs3 /opt/example2
# 
umount /opt/example2

# 开机自动挂载
echo "${IP}:/tank1/nfs  /opt/example2  nfs4  defaults  0  0" >> /etc/fstab
```