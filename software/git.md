### Git免密登陆
#### https方式
参考 https://www.cnblogs.com/cheyunhua/p/7945109.html
1. 
git config -l|grep credential.helper

设置credential.helper = store配置
git config --global credential.helper store

执行完这句命令后，~/.git/config文件里面会多了一项配置。

[credential]
        helper = store

第一次推送的时候输入账号密码，第二次往后都不需要再输入密码了。
--global的配置是对该用户全局生效的，如果只想当前项目生效，在配置的时候只需要去掉--global即可。
如果你不想执行指令，直接Copy上面配置的内容到.git/config文件里面即可。

2. 
git clone http://username:password@git.github.com/username/project.git

3. 
git remote rm origin
git remote add origin http://username:password@git.github.com/username/project.git
#### ssh方式
ssh-keygen

### 文件忽略
.gitignore

### 子模块
#### SubModule 与 SubTree
- git submodule类似于引用，而git subtree类似于拷贝，比如你在一篇博客中想用到你另一篇博客的内容，git submodule是使用那篇博客的链接，而git subtree则是将内容完全copy过来。

https://blog.csdn.net/liusf1993/article/details/72765131
https://tech.youzan.com/git-subtree/
https://blog.devtang.com/2013/05/08/git-submodule-issues/
#### SubModule
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
    修改默认更新merge的分支     git config -f .gitmodules submodule.子项目文件夹名.branch 分支名

  - 
    git submodule sync --recursive

4. 修改子项目代码
  - 进入子项目修改代码，然后add commit push
  - 进入主项目，然后add commit push


### Git基本
1. config
git config --list查看已经配置的git参数。
有三个级别的保存配置位置
--system、--global、--local，分别表示所有用户（本系统）、当前用户（全局）、本地配置（当前目录），默认使用--local。

2. 在使用Git提交前，必须配置用户名和邮箱，这些信息会永久保存到历史记录中。
例如：
git config --global user.name "garys"
git config --global user.email zyvj@163.com

3. Git中每个文件都有三种状态：modified --> ---> staged ---> committed

4. 显示所有远程的分支和相关信息操作：git remote show origin 

5. git diff xxx origin/xxx  工作目录和缓冲区比较
--cache 缓存区和本地仓库比较
--HEAD 工作目录和本地仓库比较
git diff --stat 仓库名 origin   比较工作区和最新本地仓库的差异
git diff  FETCH_HEAD 接比较fetch下来的内容和本地工作区的区别

6. git log 输出相关日志信息。
-p，用来显示每次提交的内容差异.加上 -2 来仅显示最近两次提交：例如： git log -p -2。
--pretty=oneline ，short用来精简日志。
其它：
git log -p + 文件名 （可查看该文件以前每一次push的修改内容）
git log - p -1 + 文件名 （只查看该文件当前这一次的push内容）

7. 拉取分支操作：git clone  -b 仓库地址

8. 将另一个分支的commit合并到此分支上。
git  cherry-pick  某次commit的id号

9. 删除远程的分支
git push origin :分支名 （没有删除跟踪）
git push origin --delete 分支名 （删除了跟踪）
git fetch -p 删除不存在的远程跟踪分支


10. 查看此文件内容详细信息操作：git blame fileName 

11. git push origin 本地分支名:远程分支名 创建新的远程分支并push上去

12. 入栈出栈操作
git stash
git stash pop

13. 打tag
git tag v1.0.0
  推所有的tag git push --tags
  推单个tag git push origin v1.0.0
- 删除tag
  git tag -d v1.0.0
  git push origin :refs/tags/v1.0.0

14. 本地文件全部覆盖
  git fetch --all
git reset --hard origin/master
git pull origin master
