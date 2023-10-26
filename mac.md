
## 链接
1. 苹果官网序列号查询 https://checkcoverage.apple.com/cn/zh

## 终端命令
```bash
# 1. 查看端口、PID映射
lsof -i -P
# 查看某端口占用情况
lsof -i:8080

# 2. 打开一个服务
open -a Docker

# 3. 关闭docker服务
osascript -e 'quit app "Docker"'

# 4. 查看内存  
top -l 1 | head -n 10 | grep PhysMem

# 5. 查看本地IP
ifconfig en0

# 6. 清除dns缓存
sudo killall -HUP mDNSResponder

# 7. 查看某个域名的 DNS 缓存
nslookup -q=ns baidu.com
```
```bash
# 删除终端命令记录
# 默认登录 shell 是 zsh的话，用以下命令：
rm ~/.zsh_history
# 默认登录 shell 是 bash ，用以下命令：
rm ~/.bash_history

# 压缩一个文件并且加密
zip -e ${filename}.zip ${filename}

# 使用 openssl 的 rand 方法，生成一个 30 位字符的随机字符，可以作为密码
openssl rand -base64 30
while ;do openssl rand -base64 16;done;

# 磁盘管理工具
diskutil list
```

## 软件
### Command Line Tools
1. Command Line Tools 是 Xcode IDE的可选命令行工具子部分
2. 从MacOS High Sierra，Sierra，OS X El Capitan，Yosemite，Mavericks开始，无需先安装整个Xcode软件包，也无需登录开发人员帐户，就可以单独安装Command Line Tools。
3. 安装： xcode-select --install
4. 包含： svn，git，make，GCC，clang，perl，size，strip，strings，libtool，cpp，what以及其他很多能够在Linux默认安装中找到的有用的命令。
5. 安装好的工具被放置在这个目录内 /Library/Developer/CommandLineTools/usr/bin/

### App Store
1. 截图工具 Lightshot Screenshot

### brew
#### 安装brew
- 安装brew
```bash
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# 新版本安装方式
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 配置环境变量
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

- 设置代理
```bash
# brew下载安装包时使用的是curl指令
vi ~/.curl
export ALL_PROXY=socks5://127.0.0.1:7890
```

#### 常用指令
```bash
brew service list
brew service start $name # 底层调用的是launchctl
brew service stop $name
brew tap $user/$repo
brew install vim
```

#### 软件安装包源
1. formulae & casks
    - formulae 意思是一些软件包，一般是命令行工具、开发库、一些字体、插件，共性是不提供界面，提供给终端或者是开发者使用。
    - casks 是用户软件，比如 chrome、mvim、wechat、wechatwork 这些提供用户交互界面的软件。

2. brew tap 
    - brew tap 指令可以添加安装包源
    ```bash
    brew tap $user/$repo
    # user/repo 对应 https://github.com/user/homebrew-repo 
    # brew untap $user/$repo

    # 示范
    brew install vim  # installs from homebrew/core
    brew install username/repo/vim  # installs from your custom repo
    ```

3. 常用的安装包源
    1. homebrew/php:和php关联的formulae
    2. denji/nginx: nginx modules 的tap
    3. InstantClientTap/instantclient: Oracle客户端实例的tap
    4. petere/postgresql: 允许同时安装多个PostgreSQL版本的tap
    5. dunn/emacs: Emacs package的tap
    6. sidaf/pentest: 渗透测试工具的tap
    7. osrf/simulation: 机器仿真的tap

### brew下载软件

1. 安装mysql-shell
  - brew install caskroom/cask/mysql-shell

2. mysql
  ```bash
  brew install mysql@5.7
  ```
  ```log
  To connect run:
      mysql -uroot

  mysql@5.7 is keg-only, which means it was not symlinked into /opt/homebrew,
  because this is an alternate version of another formula.

  If you need to have mysql@5.7 first in your PATH, run:
    echo 'export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc

  For compilers to find mysql@5.7 you may need to set:
    export LDFLAGS="-L/opt/homebrew/opt/mysql@5.7/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/mysql@5.7/include"


  To have launchd start mysql@5.7 now and restart at login:
    brew services start mysql@5.7
  Or, if you don't want/need a background service you can just run:
    /opt/homebrew/opt/mysql@5.7/bin/mysql.server start
  ```

3. 安装redis
  ```bash
  brew install redis
  brew services start redis
  ```
  ```log
  Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/redis/bin/redis-server /opt/homebrew/etc/redis.conf
  ```

4. java
  ```bash
  # 本人选择从官方下载dmg包进行安装 https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html
  brew tap adoptopenjdk/openjdk # 加载第三方仓库
  brew install adoptopenjdk/openjdk/adoptopenjdk8

  brew tap homebrew/cask-versions  # 加载第三方仓库
  brew reinstall adoptopenjdk8
  ```

5. ansible
  ```bash
  brew install ansible
  # brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
  arch -arm64 brew install sshpass.rb

  arch -arm64 brew install ansible-lint
  ```
  - sshpass.rb
  ```rb 
  require 'formula'

  class Sshpass < Formula
    url 'http://sourceforge.net/projects/sshpass/files/sshpass/1.06/sshpass-1.06.tar.gz'
    homepage 'http://sourceforge.net/projects/sshpass'
    sha256 'c6324fcee608b99a58f9870157dfa754837f8c48be3df0f5e2f3accf145dee60'

    def install
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end

    def test
      system "sshpass"
    end
  end
  ```

6. 安装v2ray
  - brew install v2ray
  - 配置/opt/homebrew/etc/v2ray/config.json 
  - 启动 brew services start v2ray
  - 进程 /opt/homebrew/opt/v2ray/bin/v2ray -config /opt/homebrew/etc/v2ray/config.json

### 第三方软件
1. 多屏屏幕，鼠标快速移动 https://github.com/round/CatchMouse
2. Chrome   https://www.google.com/chrome/thank-you.html?statcb=0&installdataindex=empty&defaultbrowser=0 
3. Openvpn  https://openvpn.net/downloads/openvpn-connect-v3-macos.dmg
4. Vscode   https://code.visualstudio.com/Download
5. 雅思哥   https://ieltsbro.com/
6. Mysql官方可视化工具
    - https://dev.mysql.com/downloads/workbench/
    - Mac M1上 8.0.23 闪退，8.0.22 正常使用
    ```bash
    # 安装MySQLWorkbench，然后配置命令行mysql指令
    export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
    mysql --version
    ```
7. 监控工具 stats https://github.com/exelban/stats
8. 远程控制ToDesk https://www.todesk.com/download.html
9. 贝瑞向日葵

## 服务管理launchctl
### launchctl
1. plist的全称是Property lists，是一种用来存储串行化后的对象的文件。属性列表文件的文件扩展名为.plist，因此通常被称为plist文件

2. plist文件的位置
    - 如果需要 root，并且是需要用户登陆后才能运行，放在 /Library/LaunchAgents/
    - 如果需要 root，并且不需要用户登陆后都能运行，放在 /Library/LaunchDaemons/
    - 如果只当特定用户登入时，程序才自动启动，例如当用户名称为gary时，放在 /Users/gary/Library/LaunchAgents/
        - 程序没法被kill或者stop掉，只有通过这种方式停止 launchctl unload ~/Library/LaunchAgents/${name}
    - 由操作系统为用户定义的任务项，则被放在 /System/Library/LaunchAgents

3. 通常brew在安装软件时brew为我们自动生成与加载plist。 

```bash
# 1. 对服务设置别名方便操作
vim ~/.bash_profile 或 vim .~/zshrc #编辑添加如下示范脚本
alias mysqld.start="/bin/launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql@5.7.plist"
alias mysqld.stop="/bin/launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql@5.7.plist"

# 2. 查看所有运行的的服务
launchctl list # 包含了系统的、用户的、gui的

# 3. 查看所有gui下的的服务
launchctl print gui/501 # 其中501是用户UID号，501是创建的第一个帐户。

# 4. 设置服务开机不启动
sudo launchctl unload -w /Library/LaunchDaemons/gary.test.plist

# 5. 停止一个服务
sudo launchctl stop gary.test.plist

# 6. plutil命令验证plist的格式是否正确
plutil -lint gary.test.plist
```

### 设置服务开机启动
```bash
# 配置
sudo vim /Library/LaunchDaemons/gary.test.plist
# 加载服务配置文件，让服务开机自启
sudo launchctl load -w /Library/LaunchDaemons/gary.test.plist
```
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

        <key>RunAtLoad</key> 
        <true/>  <!-- 表示launchd在加载完该项服务之后立即启动路径指定的可执行文件 -->
        <key>StandardErrorPath</key>
        <string>/tmp/jenkins_agent.err</string>
        <key>StandardOutPath</key>
        <string>/tmp/jenkins_agent.out</string>
</dict>
</plist>
```

- 每个.plist文件中，有3个属性控制着是否会开机自启动。
    1. KeepAlive: 决定程序是否需要一直运行，如果是false则需要才启动，默认false；
    2. RunAtLoad: 开机时是否运行，默认为false；
    3. SuccessfulExit: 此项为true时，程序正常退出时重启（即退出码为0）；为false时，程序非正常退出时重启。此项设置时会隐含默认RunAtLoad = true，因为程序需要至少运行一次才能获得退出状态
- 如果KeepAlive = false：
    - 当RunAtLoad = false时，程序只有在有需要的时候运行。
    - 当RunAtLoad = true时，程序在启动时会运行一次，然后等待在有需要的时候运行。
    - 当SuccessfulExit = true / false时，不论RunAtLoad值是什么，都会在启动时运行一次。气候根据SuccessfulExit值来决定是否重启。
- 如果KeepAlive = true：
    - 不论RunAtLoad/SuccessfulExit值是什么，都会启动时运行且一直保持运行状态。


## 环境变量
- 参考 https://www.jianshu.com/p/acb1f062a925

- 环境变量文件，加载顺序为：
    - /etc/profile 
    - /etc/paths 
    - ~/.bash_profile 
    - ~/.bash_login 
    - ~/.profile 
    - ~/.bashrc

- 环境变量文件，关于修改
    - 编辑环境变量文件，将环境变量添加到环境变量文件中 ，一行一个路径
        - Hint：输入环境变量时，不用一个一个地输入，只要拖动文件夹到 Terminal 里就可以了。
    - /etc/paths （全局建议修改这个文件 ）
    - /etc/profile （建议不修改这个文件 ），全局（公有）配置，不管是哪个用户，登录时都会读取该文件。
    - /etc/bashrc （一般在这个文件中添加系统级环境变量）全局（公有）配置，bash shell执行时，不管是何种方式，都会读取此文件。
    - ～/.profile 文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行.并从/etc/profile.d目录的配置文件中搜集shell的设置
        - 使用注意：如果你有对/etc/profile有修改的话必须得重启你的修改才会生效，此修改对每个用户都生效。
    - ./bashrc 每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取.
        - 使用注意 对所有的使用bash的用户修改某个配置并在以后打开的bash都生效的话可以修改这个文件，修改这个文件不用重启，重新打开一个bash即可生效。
    - ./bash_profile 该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该文件被读取.（每个用户都有一个.bashrc文件，在用户目录下）
        - 使用注意 需要需要重启才会生效，/etc/profile对所有用户生效，~/.bash_profile只对当前用户生效。

    - source ./.bash_profile 或者 ./.profile 环境信息生效

- 操作篇-全局设置
    ```bash
    # 创建一个文件：
    sudo touch /etc/paths.d/mysql
    # 用 vim 打开这个文件（如果是以 open -t 的方式打开，则不允许编辑）：
    sudo vim /etc/paths.d/mysql
    # 编辑该文件，键入路径并保存（关闭该 Terminal 窗口并重新打开一个，就能使用 mysql 命令了）
    /usr/local/mysql/bin
    # 生效配置环境
    source /etc/paths.d/mysql # 
    ```

## 快捷键
1. Command + F3  显示桌面
2. Control + Space  切换输入法
3. Command + Q  退出程序
4. Command + W  关闭当前窗口

5. Command + T  打开新的窗口/新建标签页
6. Command + L  游览器快速输入网址
7. Command + Option + I 游览器开发者工具
8. Command + left 游览器页面后退
9. Command + R 刷新页面
10. Command + up APP后退
11. Command + Shift + 3 整个屏幕截图
12. Command + Shift + 4 选择区域截图
13. Command + Shift + + Control + 4 选择区域截图

14. open -nj /Applications/WeChat.app/Contents/MacOS/WeChat 双开微信
 