[TOC]

## 存储方式
- 块存储/文件存储/对象存储
### 块存储
- 裸盘，不能被操作系统直接访问；必须先通过RAID、LVM等方式格式化为文件系统后，才能被操作系统访问。

### 文件存储
- 元数据和数据存在一起。最小存储单元为4k的文件系统，则40m的文件会得到10个最小存储单元。
- 文件存储最明显的特征是支持POSIX的文件访问接口：open、read、write、seek、close等。
1. 本地文件存储：ext3，ext4，NTFS，FAT32，xfs。
2. 网络文件存储：NFS，CIFS。


### 对象存储
- 元数据服务器（服务器+对象存储软件）+ 存储数据的分布式服务器OSD。

## RAID操作
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
# --chunk=256 表示条带单元大小为256; chunk 默认值是 512 KiB; XFS 对 log stripe unit 有更小的限制（最大 256KiB）
mdadm --create --verbose /dev/md0 --level=0 --chunk=256 --raid-devices=7 /dev/nvme[1-7]n1

# 查看 RAID 状态
cat /proc/mdstat
mdadm --detail /dev/md0

# 格式化 RAID 设备
mkfs.xfs -f /dev/md0 # 或 mkfs.ext4 /dev/md0

# 挂载文件系统
mkdir /mnt/data1 && mount /dev/md0 /mnt/data1

# 确保开机自动挂载
blkid /dev/md0  # 获取 UUID
"UUID=<UUID> /mnt/raid xfs defaults 0 0" | tee -a /etc/fstab

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