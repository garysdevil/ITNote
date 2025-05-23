---
created_date: 2021-05-13
---

[TOC]

- Linux系统讲解
- 参考
  - https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
  - https://c.isme.pub/2019/02/18/linux-proc/

## 起源

- Linux 内核最初是由李纳斯•托瓦兹(Linus Torvalds)在赫尔辛基大学读书时出于个人爱好而编写的，当时他觉得教学用的迷你版 UNIX 操作系统 Minix 太难用了，于是决定自己开发一个操作系统。
- Linux 系统第 1 版本于 1991 年 9 月发布，当时仅有 10 000 行代码。
- Linux 是一套免费使用和自由传播的类 Unix 操作系统，是一个基于 POSIX 标准和 UNIX 的多用户、多任务、支持多线程和多 CPU 的操作系统。
  - POSIX 可移植操作系统接口（Portable Operating System Interface）

## Linux系统主要组成

1. Linux内核

   1. 对下，管理系统的所有硬件设备，对硬件访问进行抽象（例如磁盘，显示，网络接口卡（NIC）），从而形成一套系统调用接口。
   2. 对内，通过一系列子系统，来负责整个系统资源的分配与管理。
      1. 文件系统管理
      2. 内存管理
      3. 进程管理
      4. 网络接口
   3. 对上，提供系统调用接口，给Library Routine（例如C库）或者其它应用程序进行访问。

2. Linux Shell

3. 文件系统

4. 文件目录

   01. bin: 放置在单人维护模式下还能够被操作的指令。这些指令可以被所有的用户使用。主要有：cat,chmod(修改权限), chown, date, mv, mkdir, cp, bash等等常用的指令。

   02. boot: 系统启动的必须文件。

   03. dev: 系统的外部设备。

   04. etc: 系统的所有配置文件。采用系统包管理器安装的的服务配置文件全部保存在此目录中。

   05. home: 普通用户的默认主目录位置。

   06. lib: 动态链接库存放的位置。

   07. mnt: 挂载额外的设备，如 U 盘、移动硬盘和其他操作系统的分区。/media 或 /misc 也是。

   08. opt：安装的第三方软件。

   09. root: root目录。

   10. sbin: 放置用来设定系统环境的指令。这些指令只有root才能够利用来设定系统。包括了开机、修复、还原系统所需要的指令。

   11. tmp:临时文件。

   12. usr: Unix Software Resource。所有通过系统安装的软件都存储在 /usr 目录下。

   13. var: 用于存储动态数据，例如缓存、日志文件、软件运行过程中产生的文件等。

   14. lost+found: 使用标准的ext2/ext3文档系统格式才会产生的一个目录，目的在于当文件系统发生错误时，将一些遗失的片段放置到这个目录下。

   15. inired:临时目录，初始化引导时候用

   16. proc: 虚拟文件系统。该目录中的数据并不保存在硬盘上，而是保存到内存中。主要保存系统的内核、进程、外部设备状态和网络状态等

   17. sys: 虚拟文件系统。和 /proc/ 目录相似，该目录中的数据都保存在内存中，主要保存与内核相关的信息。

## Linux系统接口

1. Linux系统提供了一套具体设备的抽象接口，比如字符设备, 块设备，网络设备，位图显示器等等。
2. Linux系统将内核的功能接口制作成系统调用(system call)，系统调用是操作系统的最小功能单位，一个系统调用函数就像是汉字的一个笔画。
3. Linux系统定义一些库函数(library routine)来将系统调用组合成某些常用的功能，库函数就像是汉字的偏旁部首。

## Linux系统一切皆文件

- Linux系统中所有内容都是以文件的形式保存和管理的，即一切皆文件。
  1. 普通文件是文件，目录（Windows 下称为文件夹）是文件。
  2. 硬件设备（键盘、监视器、硬盘、打印机）是文件。
  3. 套接字（socket）、网络通信等资源也都是文件。

## /proc虚拟目录

### 概要

1. /proc 是Linux 虚拟文件系统文件夹；是Linux内核信息的抽象文件接口；内核运行时参数保存在/proc里面。
2. 在运行时可以通过访问/proc文件夹 来获取Linux内核内部数据结构、改变Linux内核设置。
3. proc文件系统是一个伪文件系统，它只存在内存当中，而不占用磁盘空间。

### 主要组成

1. 进程相关部分

   - /proc目录下以数字为名的子目录，这个数字就是相关进程的进程ID。

   1. statm 显示进程所占用内存大小的统计信息
   2. stat 包含了所有CPU活跃的信息，该文件中的所有值都是从系统启动开始累计到当前时刻
   3. cgroup

2. 内核信息部分

   - /proc目录下的只读文本文件

   1. cgroups 资源隔离
   2. cpuinfo cpu相关信息
   3. stat 包含CPU利用率，磁盘，内存页，内存对换，全部中断，接触开关以及赏赐自举时间（自1970年1月1日起的秒数）。
   4. net/ -> self/net/ 此目录下的文件描述或修改了联网代码的行为。可以通过arp,netstat,route和ipfwadm命令设置或查询这些特殊文件中的许多文件。

3. 内核各子系统相关部分 (部分可调)

   - /proc目录下一些并非以数字命名的特殊目录

   1. 内核参数 etc

## 各个系统版本

- 都是基于Linux Kernel开发而成

-

- 主要差异

  1. UI
  2. 包管理系统/软件源

- Ubuntu 版本

  - Focal Fossa Ubuntu20
  - Bionic Beaver Ubuntu18
  - Xenial Xerus Ubuntu16

## 子系统

### 进程线程

- 进程是系统进行资源分配和调度的基本单位。
- 线程是操作系统能够进行运算调度的最小单位。

## IO多路复用机制

- I/O多路复用又被称为“事件驱动”。

- I/O多路复用是什么： 实现一个线程可以监视多个文件句柄。

- 目前Linux系统中提供了5种IO处理模型

  1. 阻塞IO
  2. 非阻塞IO
  3. IO多路复用
  4. 信号驱动IO
  5. 异步IO

- 目前IO多路复用的方案

  - select
    - 循环遍历所有的描述符，并在内核太和用户太之间拷贝
    - 默认的管理的最大文件描述符数量是1024个
  - poll
    - 同select机制，但使用了动态数组所所以文件描述符数量没有限制
  - epoll
    - 内核太和用户太共享某一段内存，避免了相互拷贝的资源开销
    - 使用红黑树结构存储数据
