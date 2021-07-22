## service
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


### systemctl 
- 参考
    - http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html
- 兼容service指令

- 所有可用的单元文件存放在 /usr/lib/systemd/system/ 和 /etc/systemd/system/ 目录（后者优先级更高）

- 开机执行脚本
/etc/rc.d/rc.local
查看rc-local.service是否启动 systemctl | grep rc-local.service

- 创建服务
/usr/lib/systemd/system/XXXXX.service
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

[Install]
WantedBy=multi-user.target
```

- 常用指令
```bash
# 查看运行失败的单元
systemctl --failed
```

### supervisorctl
1. Supervisor（http://supervisord.org/）是用Python开发的一个client/server服务，是Linux/Unix系统下的一个进程管理工具，不支持Windows系统。它可以很方便的监听、启动、停止、重启一个或多个进程。用Supervisor管理的进程，当一个进程意外被杀死，supervisort监听到进程死后，会自动将它重新拉起。
2. 安装

3. 启动Supervisor服务
supervisord -c /etc/supervisord.conf
4. 进入交互界面
supervisorctl