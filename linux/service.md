# service
- 开机启动service配置文件存放位置
ls /etc/init.d/

- 常用指令
```bash
service ${服务名} start
service --status-all

chkconfig --list
# 设置服务开机自动启动
chkconfig ${service} on
# 设置服务开机不自动启动
chkconfig ${service} off
# 以全屏幕文本界面设置服务开机时是否自动启动
ntsysv
```


## systemctl 
- 参考
    - http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html
    - https://www.cnblogs.com/jimbo17/p/9107052.html 资源管理
- 兼容service指令

- 所有可用的单元文件存放在 /usr/lib/systemd/system/ 和 /etc/systemd/system/ 目录（后者优先级更高）

- 开机执行脚本
/etc/rc.d/rc.local
查看rc-local.service是否启动 systemctl | grep rc-local.service

- systemd有自己的资源控制机制

### 创建服务
- vim /usr/lib/systemd/system/XXXXX.service
```conf
[Unit]
Description=XXXXX
Documentation=https://github.com/garysdevil/ITNote
After=network.target

[Service]
User=myuser
Group=myuser

Type=simple
Environment="变量名=变量值"
Environment="JVM_OPTIONS=-server -Xms64m -Xmx64m -XX:MetaspaceSize=16m $GC_OPTS $GC_LOG_OPTS $OTHER_OPTS"
ExecStartPre=/bin/sh -c -- 'pwd'
ExecStart=/bin/sh -c -- "/usr/bin/java -jar /opt/application/XXXXX/XXXXX.jar 1>> /opt/application/XXXXX/logs/XXXXX.out.log 2>> /opt/application/XXXXX/logs/XXXXX.err.log"
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
# ExecStopPost=
Restart=always # 只要不是通过systemctl stop来停止服务，任何情况下都必须要重启服务，默认值为no
StartLimitInterval=0 # 默认是10秒内如果重启超过5次则不再重启，设置为0表示不限次数重启
RestartSec=10 # 重启间隔,默认值0.1s

LimitNOFILE=102400
LimitNPROC=102400
LimitCORE=infinity

# 资源管理
Delegate=yes # 默认为no。Delegate=yes 将更多的资源控制交给进程自己管理，unit可以在单其cgroup下创建和管理其自己的cgroup的私人子层级，systemd将不在维护其cgoup以及将其进程从unit的cgroup里移走。
MemoryLimit=4G
CPUShares=1024
# cat /proc/${PID}/cgroup 可以看到 8:memory:/  变为 8:memory:system.slice/filebeat.service
# /sys/fs/cgroup/memory/system.slice/XXXXX

[Install]
WantedBy=multi-user.target
```
- 在systemd配置选项上，cgroup v2相比cgroup v1有如下不一样的地方：
    1. CPU： CPUWeight=和StartupCPUWeight=取代了CPUShares=和StartupCPUShares=。cgroup v2没有"cpuacct"控制器。
    2. Memory：MemoryMax=取代了MemoryLimit=. MemoryLow= and MemoryHigh=只在cgroup v2上支持。
    3. IO：BlockIO前缀取代了IO前缀。在cgroup v2，Buffered写入也统计在了cgroup写IO里，这是cgroup v1一直存在的问题。

### 常用指令
```bash
# 查看运行失败的单元
systemctl --failed
```

## supervisorctl
1. Supervisor（http://supervisord.org/）是用Python开发的一个client/server服务，是Linux/Unix系统下的一个进程管理工具，不支持Windows系统。它可以很方便的监听、启动、停止、重启一个或多个进程。用Supervisor管理的进程，当一个进程意外被杀死，supervisort监听到进程死后，会自动将它重新拉起。
2. 安装

3. 启动Supervisor服务
supervisord -c /etc/supervisord.conf
4. 进入交互界面
supervisorctl

## 资源限制
- 参考 https://www.cnblogs.com/jimbo17/p/9107052.html
- cgroup有两个版本: v1和v2
- 在新版的Linux（4.x）上，v1和v2同时存在，但同一种资源（CPU、内存、IO等）只能用v1或者v2一种cgroup版本进行控制

```bash
# 创建一个cgroup # mkdir -p /sys/fs/cgroup/memory/XXXXX
cgcreate -g memory:XXXXX 
# 设置最大内存
bash -c "echo 2G > /sys/fs/cgroup/memory/XXXXX/memory.limit_in_bytes"
bash -c "echo 2G > /sys/fs/cgroup/memory/XXXXX/memory.memsw.limit_in_bytes"
# mkdir -p /sys/fs/cgroup/cpu/XXXXX
# bash -c "echo 100000 > /sys/fs/cgroup/cpu/XXXXX/cpu.cfs_period_us"
# bash -c "echo 100000 > /sys/fs/cgroup/cpu/XXXXX/cpu.cfs_quota_us"
# bash -c "echo 1024 > /sys/fs/cgroup/cpu/XXXXX/cpu.shares"
# cat /proc/${PID}/cgroup
# 启动一个进程
cgexec -g memory:test /root/temp/sh_scripts/useup_mem.sh &
```
