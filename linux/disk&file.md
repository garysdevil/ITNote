[TOC]
# Disk
## 非关机状态下扩容磁盘
- 添加新硬盘进行扩容，重新扫描SCSI总线来添加设备 
	echo "- - -" >  /sys/class/scsi_host/host最大的序号/scan
- 在原有硬盘上进行扩容 
	echo '1' > /sys/class/scsi_disk/对应的硬盘/device/rescan

## 对磁盘进行分区
### 情景一 2T以下磁盘：
	1. 查看所有磁盘的分区。
		fdisk -l
	2. 进入磁盘进行分区。
		1. fdisk /dev/sdb
		2. 依次输入如下指令进行分区：
			n 创建新磁盘
			p 创建主分区
			创建分区ID 1-4为主分区（回车即可）
			根据提示选择磁盘开始位置（回车即可）
			选择结束位置（回车即可）
		3. 更改partition's system id为Linux LVM
			t
			8e
		4. 查看此磁盘的分区
			p 
		5. 输入 wq 保存退出。
- 通知系统内核分区表的变化
partprobe /dev/sdb # install parted  
### 非交互式
``` fdisk.txt
n
p
1


t
8e

p
wq
```
fdisk /dev/sdb < fdisk.txt

### 情景二 2T以上磁盘：
	1. parted /dev/sdb


## LVM
- 物理卷: pv ; 卷组: vg ; 逻辑卷: lv 
- LVM是在磁盘分区和文件系统之间添加的一个逻辑层,目的在于解决磁盘扩容问题。可以简单理解pv对应着物理分区，lv对应着文件夹，vg为pv与lv的纽带。
	
### LVM查询操作 
1. 先查看所有的逻辑卷
	lvs
2. 先查看所有的卷组
	vgs
3. 先查看所有的物理卷
	pvs
4. 查看所有的pv,vg,lv及相关信息
	lvdisplay
5. 其它查询操作
	lvscan，vgscan，pvscan
### 进行LVM操作
0. 如果没有lvm 则 yum -y install lvm2
1. 创建物理卷pv： pvcreate 磁盘或者分区的位置
	pvcreate /dev/sdb1
2. 创建卷组vg：vgcreate  vg名称  pv地址
	vgcreate  vg_data  /dev/sdb1
3. 创建逻辑卷lv：lvcreate -n 逻辑卷名称 -L  磁盘大小  卷组名字（假设vg大小为2000g,则磁盘一般最大设置为1999.98G）
	lvcreate -n lv_data -L  1999.99G  vg_data
4. 格式化lvm, mkfs.文件系统 /dev/卷组名称/逻辑卷名称
	mkfs.xfs /dev/vg_data/lv_data
5. 写入/dev/fstab文件，使机器每次开机自动挂载磁盘：/dev/卷组名称/逻辑卷名称 挂载的磁盘目录 磁盘格式 default 0 0
	mkdir /data
	vim /etc/fstab
	/dev/vg_data/lv_data   /data   xfs    defaults    0  0
6. 根据配置文件重新执行挂载操作
	mount -a

- 单独挂载某个磁盘
	mount -t xfs /dev/磁盘分区地址  /目录

### 添加新pv，扩容现有的lvm逻辑卷
- 思路：创建新的PV---将新的PV加入到当前VG---扩容现有LV---扩容文件系统
1. 创建新的pv：pvcreate 磁盘路径
	pvcreate /dev/sdb2
2. 将新的PV加入到当前VG：vgextend 现有的vg名称 PV的绝对路径
	vgextend  vg_data /dev/sdb2
3. 扩容现有的lv （lvdisplay查看lv信息） vextend -L +需要扩的空间 现有逻辑卷的绝对路径
	lvextend -L +9999G /dev/vg_data/lv_data
4. 扩容文件系统：xfs_growfs /dev/卷组名/逻辑卷名
	xfs_growfs /dev/vg_data/lv_data  （扩容xfs格式）
	resize2fs /dev/vg_data/lv_data   （扩容ext格式）
### 删除LVM卷
- 顺序：卸载磁盘，删除逻辑卷，删除卷组，删除物理卷。
1. 卸载磁盘
	- 查看目前磁盘的挂载情况 
	df -h
	- 卸载磁盘：umount 文件夹的绝对路径 
	umount /data
2. 删除逻辑卷：lvremove /dev/卷组/逻辑卷  
	lvremove /dev/vg_data/lv_data
2. 删除卷组：vgremove 卷组名
	vgremove vg_data
3. 删除物理卷：pvremove 物理卷地址
	pvremove /dev/sdc 

# File
1. 硬盘的最小存储单位: 扇区-Sector, 每个扇区储存512字节-相当于0.5KB.
2. 文件存取的最小单位: 块-block, 操作系统读取硬盘的时候, 不会一个个扇区的读取,这样效率太低,而是一次性连续读取多个扇区, 即一次性读取一个 块-block。 块的大小, 最常见的是4KB, 即连续八个sector组成一个block.
3. 文件存储在块中。
4. 文件元信息存储在inode中。
5. 每一个文件都有对应的inode。
6. Unix/Linux系统内部不使用文件名，而使用inode号码来识别文件。
7. 查看文件的inode信息 stat ${file}
    1. Links 链接数，即有多少文件名指向这个inode
8. ln
	1. 硬链接,这两个文件将指向同一个inode 
		- ln oldFile newFile  
	2. 软链接,文件newFile将指向文件oldFile的名称  
		- ln -s oldFile newFile  
		- cp oldFile newFile
		