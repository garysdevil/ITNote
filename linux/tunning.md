[TOC]
- 参考 
    - Linux Performance Tuning》（Linux 性能调优）作者是 Fernando Apesteguia

## 硬件
1. 用vmstat、sar、iostat检测是否是CPU瓶颈
2. 用free、vmstat检测是否是内存瓶颈
3. 用iostat检测是否是磁盘I/O瓶颈
4. 用netstat检测是否是网络带宽瓶

## 操作系统：
1. 进程
2. 文件系统
3. SWAP 分区
4. 内核参数调整

## 应用程序（MySQL等）：
1. mysqlreport 性能分析报告
2. mysqlsla 慢查询日志分析