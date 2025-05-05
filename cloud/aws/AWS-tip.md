---
created_date: 2021-05-23
---

[TOC]

1. 磁盘在线扩容

   - https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
   - 扩展 NVMe EBS 卷的文件系统

   ```bash
   # 如果有分区在则扩展卷的分区
   sudo growpart /dev/nvme0n1 1
   # 扩展每个卷上的文件系统
   sudo xfs_growfs -d /data  # XFS 文件系统 # yum install xfsprogs
   # sudo resize2fs /dev/nvme1n1 # ext4 文件系统

   ```

2. 添加多个IP

   1. 实例 --> 联网 --> 管理私有IP地址 --> 分配新IP
   2.

   ```bash
   ip addr add 10.2.22.218/19 dev eth0
   echo 'ip addr add 10.2.22.218/19 dev eth0' >> /etc/rc.local
   ```

   3. 弹性 --> 关联弹性IP地址 --> 网络接口

3. 要实时的确认哪些SQL语句消耗了多少内存

   1. 启用增强监测以以最短为一秒的时间间隔检查指标。

      - 增强监测在主机级别收集统计数据，CloudWatch 每 60 秒从管理程序级别收集数据。您可以使用增强监测来识别仅发生一秒钟的增加或减少，并查看各个进程使用的 CPU 和内存。

   2. 在“增强监测”页面中对进程 ID 进行排序，以查看 CPU 占用最多的进程的 ID。

   3. 以主用户身份执行以下查询：

   ```sql
   select * from performance_schema.threads where THREAD_OS_ID in (ID shown in the Enhanced Monitoring window)\G
   -- 例如，如果 Thread_OS_Id 10374 和 1432 使用了最多的内存，则执行以下查询：
   select * from performance_schema.threads where THREAD_OS_ID in (10374, 1432)\G
   ```

   4. 从此查询的输出中获取 PROCESSLIST_ID 列。这为您提供了与 SHOW FULL PROCESSLIST 中的进程 ID 值相匹配的进程 ID。
