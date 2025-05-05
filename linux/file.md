---
created_date: 2025-01-15
---

[TOC]

# 文件
## 概念
1. 硬盘的最小存储单位: 扇区-Sector, 每个扇区储存512字节-相当于0.5KB.
2. 文件存取的最小单位: 块-block, 操作系统读取硬盘的时候, 不会一个个扇区的读取,这样效率太低,而是一次性连续读取多个扇区, 即一次性读取一个块block。 块的大小, 最常见的是4KB, 即连续八个sector组成一个block.
3. 文件存储在块中。
4. 文件元信息存储在inode中。
5. 每一个文件都有对应的inode。
6. Unix/Linux系统内部不使用文件名，而使用inode号码来识别文件。

## 指令
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

### 查看文件大小
```bash
# 查看所有目录包含隐含目录的大小
du -sh * .[^.]*
# 只查看隐含目录的大小
du -sh .[!.]*
# 排除指定文件
--exclude="proc"
--exclude="data*"
```