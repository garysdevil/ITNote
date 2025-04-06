
# Winodows
## Windows11
- winget 是 Windows 11 自带的包管理器，可以快速安装最新版 PowerShell。
```sh
# 安装 PowerShell 7
winget install --id Microsoft.PowerShell --source winget
# 安装完成后，运行 pwsh 启动 PowerShell 7
```

## 指令
- cmd vs PowerShell
    1. PowerShell是跨平台的，cmd是Windows专用的。
    2. PowerShell有面向对象的管道。
    3. PowerShell能够调用.NET的很多功能。
    4. Powershell是cmd的超集。

### cmd
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

# 临时环境变量的创建与使用
set var=value
echo %var%
# 设置环境变量
setx VAR_NAME value
# 环境变量更新或追加值
setx VAR_NAME "value" /m

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

# 更改名字
net user 用户名 /fullname:显示名称
wmic useraccount where name=当前用户名 rename 新用户名
```

### PowerShell
```powershell
# 查看版本
$PSVersionTable
# PowerShell Core / PowerShell 7：版本号为 6.x 或 7.x，需单独安装。

# 1. 变量的创建与使用
$var = 'value'
$var

# 设置临时环境变量
$env:VAR_NAME="value"
$env:VAR_NAME

# 检查环境变量
$env:PATH -split ";"

# 2. 获取当前会话的历史记录
get-history

# 3. 文件的创建
new-item $FILENAEM -type file

$service_name='scfrpc'
# 服务的创建
New-Service -Name $service_name -BinaryPathName "C:\path\to\myapp.exe" -StartupType Automatic
Remove-Service -Name $service_name
# 启动类型 Boot, System, Automatic, Manual, Disabled
Get-Service -Name $service_name | Select-Object Name, Status, StartType, DisplayName
Get-CimInstance -ClassName Win32_Service -Filter "Name = '$service_name'" | Format-List Name, PathName, State, StartMode, Description
Start-Service -Name $service_name
Get-EventLog -LogName "System" | Where-Object { $_.Source -eq "Service Control Manager" -and $_.Message -like "*$service_name*" }
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

## 远程连接
1. RDPWrap 
    1. https://github.com/sebaxakerhtc/rdpwrap/releases/tag/v1.8.9.9
    2. rdpwrap.ini 
        1. https://github.com/sebaxakerhtc/rdpwrap.ini 
        2. https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini
    3. RDPWrap 的主要功能
        1. 支持多用户同时远程登录：默认情况下，Windows 只允许一个用户通过远程桌面连接登录。RDPWrap 可以解除这一限制，允许多个用户同时远程登录。
        2. 在 Windows 家庭版上启用远程桌面：Windows 家庭版默认不支持远程桌面协议（RDP），RDPWrap 可以启用这一功能。
        3. 绕过远程桌面连接数的限制：即使是非服务器版本的 Windows（如 Windows 10/11 专业版），RDPWrap 也可以解除远程桌面连接数的限制。
        4. 保持本地登录用户不受影响：使用 RDPWrap 后，远程桌面连接不会断开本地登录的用户。
    4. RDPWrap 的工作原理
        1. RDPWrap 通过替换或扩展 Windows 系统的 termsrv.dll 文件（负责远程桌面服务的核心组件），来实现对远程桌面功能的增强。它不会修改系统文件，而是通过一个服务（RDPWrapper）来动态加载配置。
    5. win11允许的威胁
        1. HackTool:Win32/RemoteAdmin!MSR
        2. PUA:Win32/RDPWrap
2. 配置指定用户不能从网络登入
    1. Win+R，gpedit.msc，计算机配置，Windows设置，安全设置，本地策略，用户权限分配，拒绝从网络访问这台计算机
# Others
1. RSS
    - https://juejin.cn/post/6844903760142024711


2. NSSM（Non-Sucking Service Manager）
    1. 可以将非服务程序（如 frpc）包装为 Windows 服务，确保正确运行并响应 SCM。
    2. `./nssm.exe install 程序服务名 `