
## 链接
1. 苹果官网序列号查询 
  - https://checkcoverage.apple.com/cn/zh
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
```

## 软件
### Command Line Tools
1. Command Line Tools 是 Xcode IDE的可选命令行工具子部分
2. 从MacOS High Sierra，Sierra，OS X El Capitan，Yosemite，Mavericks开始，无需先安装整个Xcode软件包，也无需登录开发人员帐户，就可以单独安装Command Line Tools。
3. 安装： xcode-select --install
4. 包含： svn，git，make，GCC，clang，perl，size，strip，strings，libtool，cpp，what以及其他很多能够在Linux默认安装中找到的有用的命令。
5. 安装好的工具被放置在这个目录内 /Library/Developer/CommandLineTools/usr/bin/

### App Store
1. 安装MySQL客户端
  ```bash
  # App Store安装MySQLWorkbench，然后
  export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS
  mysql --version
  ```

### brew

- 设置代理
  - export ALL_PROXY=socks5://127.0.0.1:1080

- brew services list

1. 安装brew
  ```bash
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  ```

2. formulae & casks
    - formulae 意思是一些软件包，一般是命令行工具、开发库、一些字体、插件，共性是不提供界面，提供给终端或者是开发者使用。
    - casks 是用户软件，比如 chrome、mvim、wechat、wechatwork 这些提供用户交互界面的软件。

3. brew tap 
    - brew tap可以为brew的软件的 跟踪,更新,安装添加更多的的tap formulae
    ```bash
    brew tap $user/$repo
    # user/repo 对应 https://github.com/user/homebrew-repo 
    # brew untap $user/$repo

    # 示范
    brew install vim  # installs from homebrew/core
    brew install username/repo/vim  # installs from your custom repo
    ```
    - 常用的tap
        1. homebrew/php:和php关联的formulae
        2. denji/nginx: nginx modules 的tap
        3. InstantClientTap/instantclient: Oracle客户端实例的tap
        4. petere/postgresql: 允许同时安装多个PostgreSQL版本的tap
        5. dunn/emacs: Emacs package的tap
        6. sidaf/pentest: 渗透测试工具的tap
        7. osrf/simulation: 机器仿真的tap

#### brew下载软件

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

### 第三方
1. 多屏屏幕，鼠标快速移动
    - https://github.com/round/CatchMouse

## 服务
### launchctl
1. 位置
  - 如果需要 root，并且是需要用户登陆后才能运行，把 plist 放在 /Library/LaunchAgents/下
  - 如果需要 root，并且不需要用户登陆后都能运行，把 plist 放在 /Library/LaunchDaemons/下

1. 查看所有的服务
  - launchctl list

2. 设置服务开机启动
  - sudo vim /Library/LaunchDaemons/gary.test.plist
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
  - sudo launchctl unload -w /Library/LaunchDaemons/gary.test.plist

4. 停止一个服务
  - sudo launchctl stop gary.test.plist

5. plutil命令验证plist的格式是否正确
  - plutil -lint gary.test.plist


## 环境变量
- 参考 https://www.jianshu.com/p/acb1f062a925

```txt
Mac系统的环境变量，加载顺序为：
/etc/profile /etc/paths ~/.bash_profile ~/.bash_login ~/.profile ~/.bashrc


上述文件的科普
/etc/paths （全局建议修改这个文件 ）
编辑 paths，将环境变量添加到 paths文件中 ，一行一个路径
Hint：输入环境变量时，不用一个一个地输入，只要拖动文件夹到 Terminal 里就可以了。

/etc/profile （建议不修改这个文件 ）
全局（公有）配置，不管是哪个用户，登录时都会读取该文件。

/etc/bashrc （一般在这个文件中添加系统级环境变量）
全局（公有）配置，bash shell执行时，不管是何种方式，都会读取此文件

.profile 文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行.并从/etc/profile.d目录的配置文件中搜集shell的设置
使用注意：如果你有对/etc/profile有修改的话必须得重启你的修改才会生效，此修改对每个用户都生效。

./bashrc 每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取.
使用注意 对所有的使用bash的用户修改某个配置并在以后打开的bash都生效的话可以修改这个文件，修改这个文件不用重启，重新打开一个bash即可生效。

./bash_profile 该文件包含专用于你的bash shell的bash信息,当登录时以及每次打开新的shell时,该文件被读取.（每个用户都有一个.bashrc文件，在用户目录下）
使用注意 需要需要重启才会生效，/etc/profile对所有用户生效，~/.bash_profile只对当前用户生效。

source ./.bash_profile 或者 ./.profile 环境信息生效

操作篇
全局设置
创建一个文件：
sudo touch /etc/paths.d/mysql
用 vim 打开这个文件（如果是以 open -t 的方式打开，则不允许编辑）：
sudo vim /etc/paths.d/mysql
编辑该文件，键入路径并保存（关闭该 Terminal 窗口并重新打开一个，就能使用 mysql 命令了）
/usr/local/mysql/bin
$ source 相应的文件 生效配置环境
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
 