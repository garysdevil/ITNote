
# Winodows
1. cmd vs PowerShell
    1. PowerShell是跨平台的，cmd是Windows专用的。
    2. PowerShell有面向对象的管道。
    3. PowerShell能够调用.NET的很多功能。
    4. Powershell是cmd的超集。

## cmd
ipconfig /all
ipconfig /flushdns

### 基本指令
1. 变量的创建与使用
set var=value
echo %var%

2. 文件夹的创建
mkdir

3. 文件的创建
type nul>test.go



## PowerShell

1. 变量的创建与使用
$var = 'value'
$var

2. 获取当前会话的历史记录
get-history

3. 文件的创建
new-item $FILENAEM -type file

