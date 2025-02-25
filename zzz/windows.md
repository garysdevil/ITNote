
# Winodows
1. cmd vs PowerShell
    1. PowerShell是跨平台的，cmd是Windows专用的。
    2. PowerShell有面向对象的管道。
    3. PowerShell能够调用.NET的很多功能。
    4. Powershell是cmd的超集。

## cmd
```sh
ipconfig /all
ipconfig /flushdns

# 查看mac地址
getmac /v

# shutdown 指令
# -s 关机
# -r 重启
# -l 注销
# -h -f 休眠
# -a 取消关机
# -t 1 指定时间后执行


#  变量的创建与使用
set var=value
echo %var%

# 文件夹的创建
mkdir

# 文件的创建
type nul>test.go


# 查看所有任务
tasklist ｜ findstr %PID%


# 查看所有 Windows 服务及其详细信息的列表
sc queryex state=all type=service
sc query %ServiceName%
sc stop %ServiceName%
sc start %ServiceName%

# 查看所有监听的端口
netstat -ano | find "LISTENING" 
```


## PowerShell
```sh
# 1. 变量的创建与使用
$var = 'value'
$var

# 2. 获取当前会话的历史记录
get-history

# 3. 文件的创建
new-item $FILENAEM -type file
```

## Win + r
1. 配置开机启动项 ``msconfig``

## 快捷键
1. Ctrl + W 关闭窗口/标签
2. Alt + F4 关闭窗口


## 端口
1. 135
    1. TCP RCP
    2. TCP RCP 消息队列 、 TCP RCP 远程过程调用 、 TCP RCP Exchange Server
    3. 爆破弱口令
2. 445
    1. SMB
    2. ...
    3. 溢出漏洞
3. 3389
    1. 远程登入端口

# Others
1. RSS
    - https://juejin.cn/post/6844903760142024711