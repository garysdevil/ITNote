- 基于3.4版本
- 触发器参考文档
    https://www.cnblogs.com/dadonggg/p/8566443.html
    https://www.zabbix.com/documentation/3.4/manual/appendix/triggers/functions
    https://www.zabbix.com/documentation/3.4/manual/config/triggers

#### 触发器
##### 触发器语法
1. 触发器构建语法
```
{<server>:<key>.<function>(<parameter>)\}<operator><constant>
<server>    是模板名称 或者 主机名称
<key>    是server里的监控项
<function>     是触发器表达式
<parameter>    是阈值
<operator>　　操作人，选填
<constant>　　持续性，选填
```
例如：
{Template App Zabbix Agent:agent.ping.nodata(5m)}=1

2. 触发器表达式知识点
    - 触发器表达式不能同时包含有模板和主机里的监控项。
    - A模板上的触发器表达式不能包含非A模板上的监控项。
    - 当触发器同时包含两台主机的触发器时则这个triiger会同时出现在这两台主机上。 

3. 触发器名称可以包含的宏变量
{HOST.HOST}, {HOST.NAME}, {HOST.CONN}, {HOST.DNS}, {HOST.IP}, {ITEM.VALUE}, {ITEM.LASTVALUE} and {$MACRO}.
$1, $2…$9 macros can be used to refer to the first, second…ninth constant of the expression.
##### 触发器表达式
- 基于3.4版本
- 触发器表达式默认的时间单位都是秒。可以加上m,h,d,w单位。
- 基于时间的函数(nodata(), date(), dayofmonth(), dayofweek(), time(), now())，触发器就会由 Zabbix timer 进程每 30 秒重新计算一次。当接收到一
个新值和每隔 30 秒都会重新计算触发器的状态。
-  最不耗程序资源的函数 last()，nodedata()

1. abschange 最近一次值和上一次值的差绝对值。
    - 如果（每核）CPU 1分钟负载浮动大于10则告警 {ttlsa-web-01:system.cpu.load[percpu,avg1].abschange()}>10
    - 对于字符串，=0表示最近一次值和上一次值相等，=1则表示不相等。

2. avg(sec|#num,<time_shift>)
    - avg(#5）：表示最近5次得到值的平均值
    - avg(3600,86400）：表示一天前的一个小时的平均值

4. change 最近一次值和上一次值的差。

5. count (sec|#num<,期望获得的值>,<operator>,<time_shift>)
    - 最近30分钟zabbix.zabbix.com这个主机超过5次不可到达： {zabbix.zabbix.com:icmpping.count(30m,0)}>5 

6. date 返回当前的时间YYYYMMDD
    - 例如 20150731

7. dayofmonth 返回今天是多少号

8. delta(sec|#num,<time_shift>)    返回区间内的最大值与最小值的差值
    - 1小时内可用内存的百份比相差80： AAA.vm.memory.size[available].delta(1h)>80 

9. diff  比较最近一次值和上一次值是否相同
    - =1 表示不同。 =0表示相同。

10. last (<sec|#num>,<time_shift>) 
    - 获取最近的值，last()=last(#1)

11. max (sec|#num,<time_shift>)

12. min (sec|#num,<time_shift>)

13. nodata (sec)
    - =1 表示周期评估时间内没接收到数据。

14. regexp (<pattern>,<sec|#num>)
    -  检查最近的值是否匹配正则表达式
15. str (<string>,<sec|#num>)
    - 查找周期内的值是否包含指定的字符串

16. forecast (sec|#num,<time_shift>,time,<fit>,<mode>) 根据以往的值预测将来的值
    - 根据1小时内的剩余磁盘大小数据预测10小时后的剩余磁盘大小,当预测值小于0时触发告警 {k8s-node01:vfs.fs.size[/,free].forecast(1h,,10h)}<0
    
17. sum (sec|#num,<time_shift>)
    - 返回指定周期中收集到的值的总和
     
##### 高级示例
1. 如果表达式中的两个触发器表达式的结果大于 5，就会使触发器的状态变更为 PROBLEM 状态。
```
({server1:system.cpu.load[all,avg1].last()}>5) + 
({server2:system.cpu.load[all,avg1].last()}>5) + 
({server3:system.cpu.load[all,avg1].last()}>5)>=2
```