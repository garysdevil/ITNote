
### 终端命令
1. 查看端口、PID映射
lsof -i -P

2. 打开一个服务
open -a Docker

3. 
osascript -e 'quit app "Docker"'

### launchctl
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
        <string>gary.test.plist</string>
        <key>ProgramArguments</key>
        <array>
                <string>/Users/admin/devops/jenkins_agent/start.sh</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
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