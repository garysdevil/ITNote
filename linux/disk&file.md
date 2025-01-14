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

## 操作
1. Linux查看磁盘是固态还是机械
```bash
# ROTA为0表示不可以旋转，就是SSD
# 1 代表是机械硬盘，0 则就是 ssd 

# 查看某个磁盘类型
cat /sys/block/{block_name}/queue/rotational
# 查看所有磁盘类型 方式一
grep ^ /sys/block/*/queue/rotational
# 查看所有磁盘类型 方式二
lsblk -d -o name,rota
```

2. 查看磁盘信息
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

3. 查看硬盘信息
```sh
### hdparm（即硬盘参数）是Linux的命令行程序之一，用于处理磁盘设备和硬盘。借助此命令，您可以获得有关硬盘，更改写入间隔，声学管理和DMA设置的统计信息。
disk=/dev/sda
hdparm  ${disk} # 显示指定硬盘的相关信息
hdparm -t ${disk} # 评估硬盘读取效率
```


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

# 文件
## 概念
1. 硬盘的最小存储单位: 扇区-Sector, 每个扇区储存512字节-相当于0.5KB.
2. 文件存取的最小单位: 块-block, 操作系统读取硬盘的时候, 不会一个个扇区的读取,这样效率太低,而是一次性连续读取多个扇区, 即一次性读取一个块block。 块的大小, 最常见的是4KB, 即连续八个sector组成一个block.
3. 文件存储在块中。
4. 文件元信息存储在inode中。
5. 每一个文件都有对应的inode。
6. Unix/Linux系统内部不使用文件名，而使用inode号码来识别文件。

## 操作
```sh
# stat 查看文件的inode信息
stat ${file}
	# Links 代表链接数，即有多少文件名指向这个inode

# ln 文件链接
# 硬链接，这两个文件将指向同一个inode
ln ${old_file} ${new_file}
# 软链接，文件${new_file}将指向文件${old_file}的名称  
ln -s ${old_file} ${new_file}
```


### dd
- dd 指令用于处理磁盘设备文件

1. 数据来源选择 if=/dev/zero
	1. 使用 /dev/urandom 生成随机数据，可能稍慢。
	2. 使用 /dev/zero 可生成零填充数据，速度更快。
	3. 使用特定内容进行填充 echo "Hello Filecoin!" > input_data.txt
2. 输出路径 of=output.bin
3. 其它参数
	1. 显示进度 status=progress
	2. 异步进行 oflag=dsync
	3. 块的大小 bs=1M
	4. 块的数量 count=N
	5. 在输出文件中跳过的块数量 seek=N
4. 示范 
	1. 创建文件 dd if=/dev/urandom of=urandom.bin bs=1G count=17 status=progress
	2. 备份磁盘分区 dd if=/dev/sda1 of=backup.img status=progress

### 传文件
```bash
# 本地快速拷贝文件夹
tar cvf – 源文件夹路径 | tar xvf – -C 目的文件夹路径
```

```bash
# scp  -i 指定密钥文件 -C 允许压缩 源文件 目的地址
scp -P22 home.tar 192.168.205.34:/home/home.tar
# -r 拷贝目录

# rsync支持在本地计算机与远程计算机之间，或者两个本地目录之间同步文件
rsync -P --rsh=ssh home.tar 192.168.205.34:/home/home.tar
rsync -P -e'ssh -p 22' home.tar 192.168.205.34:/home/home.tar
# -P 可以实现意外中断后，下次继续传。当于 --partial --progress
# -r 拷贝目录
# -a 参数可以替代-r，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）,从而做到增量同步
# --exclude='文件名' 排除某些文件或目录
# -e 指定协议
# --partial 允许恢复中断的传输
# --append 文件接着上次中断的地方，继续传输
# --append-verify 跟--append参数类似，但会对
传输完成后的文件进行一次校验。如果校验失败，将重新发送整个文件。非常影响传输速度。
# -z 同步时压缩数据
# -S 传输稀疏文件 sparse file
# --bwlimit=1024 # 单位为KB/s
# -x 指定传输时不能跨文件系统
# --inplace

# 通过ssh协议远程同步目录时的参数
# --append-verify -P -a -z -e'ssh -p 22'
# -P -a -z -e'ssh -p 22'
rsync -P -a -z -e'ssh -p 22' 192.168.205.34:/home/home ./
```

- rsync 使用-a参数时，文件夹内的文件太多，可能会导致这个问题，例如当文件夹内含有8691137个文件时 ``No space left on device (28)``

### 稀疏文件
- 稀疏文件 sparse file
    - 稀疏文件就是在文件中留有很多空余空间，留备将来插入数据使用。如果这些空余空间被ASCII码的NULL字符占据，并且这些空间相当大，那么，这个文件就被称为稀疏文件，而且，并不分配相应的磁盘块。
    - Linux中常见的qcow2文件和raw文件，都是稀疏文件。
```bash
# 创建稀疏文件，将创建一个5MB大小的文件，但不在磁盘上存储数据（仅存储元数据）
spare_file_path=spare_file
# dd命令创建
dd of=${spare_file_path} bs=1k seek=5120 count=0
# truncate命令创建
truncate -s 5M sparse_file_name
# qemu-img命令创建
qemu-img create -f qcow2 ${spare_file_path}.qcow2 5M

# 查看稀疏文件的大小
qemu-img info ${spare_file_path}
```

### 传稀疏文件
```bash
# 拷贝稀疏文件的几种方式 # 两台机器的文件系统必须相同，否则下面的指令无效

# 进行拷贝稀疏文件测试 稀疏文件大小：virtual size: 1.93 GiB, disk size: 860 MiB, 传输速度维持在11.27MB/s左右

# rsync传输
rsync -P -S -e'ssh -p 22' 0  10.10.1.42:~/ # 2m55.485s

# rsync压缩传输
rsync -P -S -z -e'ssh -p 22' 0  10.10.1.42:~/ # 0m46.092s # 显示的传输速度为 43.35MB/s，应该是由于压缩原因，实际上是传输大小减小了
rsync -P -S -z  0  10.10.1.42:~/  # 0m50.225s

# tar打包，rsync传输
tar Scvf 0.tar 0 && rsync -P -S -e'ssh -p 22' 0.tar  10.10.1.42:~/ && ssh 10.10.1.42 tar xvf ~/0.tar # 1m23.187s

# tar打包压缩，rsync传输
tar Sczvf 0.tar.gz 0 && rsync -P -S -e'ssh -p 22' 0.tar.gz  10.10.1.42:~/ && ssh 10.10.1.42 tar xzvf ~/0.tar.gz # 1m7.679s

# tar打包压缩, scp传输
tar Scjvf - 0 | ssh 10.10.1.42 tar xjvf - -C ./  # 1m41.213s
tar Sczvf - 0 | ssh 10.10.1.42 tar xzvf - -C ./  # 0m46.807s

# 最佳实践
time rsync -P -S -a -z  -e'ssh -p 22' ./aa  10.10.3.76:/tank1/
```