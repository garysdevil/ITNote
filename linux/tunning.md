用什么工具能找出性能瓶颈：
有本书叫《Linux Performance Tuning》（Linux 性能调优）这本书是老外写的，作者是 Fernando Apesteguia 
### 硬件：
1. 用vmstat、sar、iostat检测是否是CPU瓶颈
2. 用free、vmstat检测是否是内存瓶颈
3. 用iostat检测是否是磁盘I/O瓶颈
4. 用netstat检测是否是网络带宽瓶

### 操作系统：
进程
文件系统
SWAP 分区
内核参数调整

### 应用程序（MySQL等）：
mysqlreport 性能分析报告
mysqlsla 慢查询日志分析