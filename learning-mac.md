
### 终端命令
1. 查看端口、PID映射
lsof -i -P

2. 打开一个服务
open -a Docker

3. 
osascript -e 'quit app "Docker"'

4. 查看内存  
top -l 1 | head -n 10 | grep PhysMem

### Command Line Tools
1. Command Line Tools 是 Xcode IDE的可选命令行工具子部分
2. 从MacOS High Sierra，Sierra，OS X El Capitan，Yosemite，Mavericks开始，无需先安装整个Xcode软件包，也无需登录开发人员帐户，就可以单独安装Command Line Tools。
3. 安装： xcode-select --install
4. 包含： svn，git，make，GCC，clang，perl，size，strip，strings，libtool，cpp，what以及其他很多能够在Linux默认安装中找到的有用的命令。
5. 安装好的工具被放置在这个目录内 /Library/Developer/CommandLineTools/usr/bin/

### launchctl
0. 位置
如果需要 root，并且是需要用户登陆后才能运行，把 plist 放在 /Library/LaunchAgents/下
如果需要 root，并且不需要用户登陆后都能运行，把 plist 放在 /Library/LaunchDaemons/下

1. 查看所有的服务
launchctl list

2. 设置服务开机启动
sudo vim /Library/LaunchDaemons/gary.test.plist
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>gary.test.plist</string> <!-- 唯一标识 -->

        <key>UserName</key>
        <string>gary</string> <!-- 运行的用户，只有Launchd作为root运行时生效 -->

        <key>ProgramArguments</key> <!-- 可执行文件位置 -->
        <array>
                <string>/Users/admin/devops/jenkins_agent/start.sh</string>
        </array>

        <key>KeepAlive</key>
        <false/>

        <key>RunAtLoad</key> <!-- 表示launchd在加载完该项服务之后立即启动路径指定的可执行文件 -->
        <true/> 

        <key>StandardErrorPath</key>
        <string>/tmp/jenkins_agent.err</string>
        <key>StandardOutPath</key>
        <string>/tmp/jenkins_agent.out</string>
</dict>
</plist>
```
sudo launchctl load -w /Library/LaunchDaemons/gary.test.plist

3. 设置服务开机不启动
sudo launchctl unload -w /Library/LaunchDaemons/gary.test.plist

4. 停止一个服务
sudo launchctl stop gary.test.plist

5. plutil命令验证plist的格式是否正确
plutil -lint gary.test.plist