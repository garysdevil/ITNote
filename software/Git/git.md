## Git基本知识
1. Git中每个文件都有三种状态
untracked(未执行add/工作区) ---> 
modified(未执行add/工作区) ---> staged(未执行commit/缓冲区) ---> committed(本地仓库)

### 初始化
1. 拉取分支操作  
git clone  -b ${branch} http://git.github.com/project.git 
git clone git@github.com/project.git
2. 配置
git config --list查看已经配置的git参数。  
有三个级别的保存配置位置，默认使用 --local
  --system  表示所有用户（本系统）Git安装目录\etc\gitconfig
  --global  表示当前用户（全局）用户目录/.gitconfig
  --local  表示本地配置（当前目录） .git/config

3. 在使用Git提交前，必须配置用户名和邮箱，这些信息会永久保存到历史记录中。    
git config --global user.name "gary"
git config --global user.email username@163.com

4. 显示所有的源
git remote -v

5. 显示某个源的具体信息  
git remote show origin 

6. 源
origin 为默认源
添加源：git remote add origin http://git.github.com/username/project.git 
删除源： git remote rm 源名
给源添加一个push地址：git remote set-url --add origin http://git.github.com/username/project.git 

7. push并且设置此分支默认的远程源和分支
git push --set-upstream origin main

8. 拉取远程分支
git fetch --all
git pull origin master

9. Git代理
    - 设置全局代理
      git config http.proxy http://XXX.XXX.XXX.XXX:2334

      git config --global http.proxy 'socks5://XXX.XXX.XXX.XXX:1080'  
      git config --global https.proxy 'socks5://XXX.XXX.XXX.XXX:1080'  
    - 取消代理
      git config --global --unset http.proxy
      git config --global --unset https.proxy

    - 对某个域名进行代理
      git config --global http.https://github.com.proxy socks5://XXX.XXX.XXX.XXX:1080   
      git config --global https.https://github.com.proxy socks5://XXX.XXX.XXX.XXX:1080  

    - 写入配置文件里 ~/.gitconfig
      ```conf
      [http]
        proxy = socks5://XXX.XXX.XXX.XXX:1080
      [https]
        proxy = socks5://XXX.XXX.XXX.XXX:1080
      ```
      ```conf
      [http "https://github.com/"]
        proxy = socks5://XXX.XXX.XXX.XXX:1080
      [https "https://github.com/"]
        proxy = socks5://XXX.XXX.XXX.XXX:1080
      ```
10. git pull 策略
```bash
git config  --global pull.rebase false  # merge (the default strategy)
git config  --global pull.rebase true   # rebase
git config  --global pull.ff only       # fast-forward only
```

### 日常操作

1. diff  
  - git diff origin/xxx 
  - git diff hash1 hash2 比较两次commit的后的区别,使用git log获取commit的hash
  - git diff 文件路径 origin/xxx   
    1. 默认 untracked工作区 和 modified工作区和缓冲区 比较
    2. --cached 缓存区 和 本地仓库 比较
    3. --HEAD 工作目录 和 本地仓库 比较
    4. --stat 只显示有差异的文件名和行数

2. log
  - git log 输出日志信息
    ```bash
    # -p  用来显示每次提交的内容差异。  
    # -${NUM} 来仅显示最近两次提交。例如： git log -2  
    # --pretty=oneline / short 用来精简显示日志。  
    # --author="gary" 通过提交者来过滤
    # --reverse 倒序

    # 具体例子：  
    git log -p + 文件名 #（可查看该文件以前每一次push的修改内容）  
    git log -p -1 + 文件名 #（只查看该文件当前这一次的push内容）  
    ```
  - 查看节点树 git log --oneline --graph --decorate --all
  - 指定时间
    - --since="2019-11-21"
    - --before="2020-11-21"
    - --since=2.years
    - --since=2.days
3. 合并
  1. 将另一个分支的commit合并到此分支上  
    git  cherry-pick  某次commit的id号
  2. 默认 fast-forward ，HEAD 指针直接指向被合并的分支
    git merge 分支名
  3. 禁止快进式合并
    git merge --no-ff 分支名
  4. 将所有的commit整合为一个新的commit提交到主分支上
    git merge --squash 分支名

4. 删除本地分支
git branch -D 分支名

4. 删除远程的分支  
git push origin:分支名 （没有删除跟踪）   
git push origin --delete 分支名 （删除了跟踪）  
git fetch -p 删除本地不存在的远程跟踪分支  

5. 查看此文件内容修改的详细操作信息  
git blame fileName 

6. git push origin 本地分支名:远程分支名   
创建新的远程分支并push上去

7. 入栈出栈操作  
git stash  
git stash pop  
git stash list  

8. 打tag  
    - git tag v1.0.0  
    - 推所有的tag上远程仓库 git push --tags  
    - 推单个tag上远程仓库 git push origin v1.0.0  

9. 删除tag
    - 删除本地 git tag -d v1.0.0
    - 删除远程 git push --delete origin:refs/tags/v1.0.0

10. 重置reset 
    - 未被跟踪的文件不会受到影响  
    - 重置回工作区状态  git reset --mix origin/master  
    1. --hard 重置到上一次commit状态
    1. --mix 重置到上一次工作区状态  ``git reset head~ --mix``
    2. --soft 重置到上一次缓冲区状态  
    3. head~ 指定上一次commit状态  
    - 重置回上一次commit状态 git checkout .

## Git免密登陆
### https方式-明文
参考 https://www.cnblogs.com/cheyunhua/p/7945109.html
- 方式一 将账户密码保存进文本里
  1. 查看凭证 git config -l| grep credential.helper

  2. 设置凭证 credential.helper = 凭证名字
  git config --global credential.helper 凭证名字

  3. 执行完以上命令后，~/.git/config文件里面会多一项配置
  config
  ```conf
  [credential]
          helper = 凭证名字
  ```
  4. 第一次推送的时候输入账号密码，第二次往后都不需要再输入密码了。
  --global 表示对该用户全局生效。
  --local 默认为--local，只对本项目生效。

  5. 或者直接Copy上面配置的内容到 .git/config文件里面即可。
    .git/config  
    .git-credentials  

- 方式二 clone时将账户密码放入源里，单次生效
git clone http://username:password@git.github.com/username/project.git

- 方式三 将账户密码永久放在本地的源里面
git remote rm origin
git remote add origin http://username:password@git.github.com/username/project.git
### ssh方式
1. 生成公钥私钥   
  ssh-keygen -t rsa -C 'Git邮箱' 
2. 将生成的公钥放入Git公共仓库上

3. 指定git使用的私钥
https://blog.csdn.net/SCHOLAR_II/article/details/72191042

GIT_SSH_COMMAND="ssh -i ${privateKeyPath}" git pull
### 解决错误
1. 问题  
git: 'credential-凭证名字' is not a git command. See 'get --help'.
2. 方案  
部分windows系统缺少微软的 Git Credential Manager
安裝 Git Credential Manager for Windows即可解决该问题
下载地址  https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/latest
```bash
# 查看凭证
git config --global credential.helper
```

## Git仓库内的特殊文件
1. 文件忽略
.gitignore

## 子模块
### SubModule 与 SubTree
- git submodule类似于引用，而git subtree类似于拷贝，比如你在一篇博客中想用到你另一篇博客的内容，git submodule是使用那篇博客的链接，而git subtree则是将内容完全copy过来。
- 参考文档：
https://blog.csdn.net/liusf1993/article/details/72765131
https://tech.youzan.com/git-subtree/
https://blog.devtang.com/2013/05/08/git-submodule-issues/
### SubModule
- https://git-scm.com/book/en/v2/Git-Tools-Submodules

1. 添加子模块
git submodule add 仓库地址  保存的文件夹名字（默认为仓库名）

2. 删除子模块
  - 删除.gitmodule文件中对应的submodule
  - 删除.git/config文件中对应的submodule
  - 删除submodule对应的文件夹

2. 设置子模块的临时仓库地址
git config submodule.子项目名.url

3. 从github克隆含有子模块的项目
  - 方式一
     git submodule init
     git submodule update
  - 方式二  
     git submodule update --init
  - 方式三  
     git clone 主仓库地址  --init --recurse-submodules 

3. 从github更新子项目代码
  - 方式一  
    进入子项目，进行更新  

  - 方式二  
    git pull  
    git submodule update --remote 子项目文件夹名（默认所有的子项目）  
    默认会merge master分支  
    修改默认更新merge的分支 git config -f .gitmodules submodule.子项目文件夹名.branch 分支名

  - 方式三  
    git submodule sync --recursive

4. 修改子项目代码
    - 进入子项目修改代码，然后add commit push
    - 进入主项目，然后add commit push

## Git service
- https://github.com/gogs/gogs
- https://github.com/Nightonke/Gitee
- Gitlab
- Github