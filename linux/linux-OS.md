- 参考
https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
https://c.isme.pub/2019/02/18/linux-proc/
## linux四个主要部分
1. Linux Shell
2. 文件系统
3. Linux实用工具：编辑器，过滤器，交互程序
	编辑器：用于编辑文件。
	过滤器：用于接收数据并过滤数据。
	交互程序：允许用户发送消息或接收来自其它用户的消息。（用户与机器的信息接口）	

4. 文件目录
    1. bin: 放置在单人维护模式下还能够被操作的指令。这些指令可以被所有的用户使用。主要有：cat,chmod(修改权限), chown, date, mv, mkdir, cp, bash等等常用的指令。
    2. boot: 系统启动的必须文件。
    3. dev: 系统的外部设备。
    4. etc: 系统的所有配置文件。采用系统包管理器安装的的服务配置文件全部保存在此目录中。
    5. home: 普通用户的默认主目录位置。
    6. lib: 动态链接库存放的位置。
    7. mnt: 挂载额外的设备，如 U 盘、移动硬盘和其他操作系统的分区。/media 或 /misc 也是。
    8. opt：安装的第三方软件。
    9. root: root目录。
    10. sbin: 放置用来设定系统环境的指令。这些指令只有root才能够利用来设定系统。包括了开机、修复、还原系统所需要的指令。
    11. tmp:临时文件。
    12. usr:  Unix Software Resource。所有通过系统安装的软件都存储在 /usr 目录下。
    13. var: 用于存储动态数据，例如缓存、日志文件、软件运行过程中产生的文件等。

    14. lost+found: 使用标准的ext2/ext3文档系统格式才会产生的一个目录，目的在于当文件系统发生错误时，将一些遗失的片段放置到这个目录下。
    15. inired:临时目录，初始化引导时候用
    16. proc: 虚拟文件系统。该目录中的数据并不保存在硬盘上，而是保存到内存中。主要保存系统的内核、进程、外部设备状态和网络状态等
    17. sys: 虚拟文件系统。和 /proc/ 目录相似，该目录中的数据都保存在内存中，主要保存与内核相关的信息。
## 各个系统版本
- 都是基于Linux Kernel开发而成
- 主要差异
    1. UI
    2. 软件源

## /proc
### 概要
1. /proc 是Linux 虚拟文件系统文件夹；是Linux内核信息的抽象文件接口；内核运行时参数保存在/proc里面。
2. 在运行时可以通过访问/proc文件夹 来获取Linux内核内部数据结构、改变Linux内核设置。
3. proc文件系统是一个伪文件系统，它只存在内存当中，而不占用磁盘空间。
### 主要组成
1. 进程相关部分
    - /proc下以数字为名的子目录，这个数字就是相关进程的进程ID。
    1. statm 显示进程所占用内存大小的统计信息
    2. stat 包含了所有CPU活跃的信息，该文件中的所有值都是从系统启动开始累计到当前时刻
    3. cgroup 

2. 内核信息部分
    - /proc下的只读文本文件
    1. cgroups 资源隔离
    2. cpuinfo cpu相关信息
    3. stat 包含CPU利用率，磁盘，内存页，内存对换，全部中断，接触开关以及赏赐自举时间（自1970年1月1日起的秒数）。
    4. net/ -> self/net/  此目录下的文件描述或修改了联网代码的行为。可以通过arp,netstat,route和ipfwadm命令设置或查询这些特殊文件中的许多文件。

3. 内核各子系统相关部分 (部分可调) 
    /proc下一些并非以数字命名的特殊目录
    1. 内核参数 etc

## 机制
1. Linux将内核的功能接口制作成系统调用(system call),系统调用是操作系统的最小功能单位,一个系统调用函数就像是汉字的一个笔画。
2. Linux定义一些库函数(library routine)来将系统调用组合成某些常用的功能，库函数就像是汉字的偏旁部首。