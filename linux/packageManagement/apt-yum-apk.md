## 包管理工具
### Ubuntu18
#### Ubuntu16
##### 概览
1. Debian系列 *.deb
2. 软件的安装可被拆分为两个对立的过程“解包”和“配置”。
3. dpkg：安装、删除、构建和管理Debian的软件包。
4. apt工具：解决软件包之间的依赖问题。
5. 软件源配置文件与文件夹 /etc/apt/sources.list  /etc/apt/sources.list.d
6. apt的底层包是dpkg, 而dpkg 安装Package时, 会将 *.deb 放在 /var/cache/apt/archives/ 中。
##### 基本操作
1. apt update  
    从软件源（也就是服务器）下载最新的软件包列表文件，更新本地软件源的软件包的索引记录（包含软件名，版本，校验值，依赖关系等）。
    同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引。
    
2. apt upgrade 根据update更新的索引记录来下载并更新软件包.

3. apt dist-upgrade 除了拥有upgrade的全部功能外，dist-upgrade会比upgrade更智能地处理需要更新的软件包的依赖关系。

3. apt-get purge :删除已安装包和依赖包（不保留配置文件)。 
4. apt-get autoremove 删除为了满足依赖而安装的，但现在不再需要的软件包（包括已安装包），保留配置文件。
5. apt-get autoclean
    将 /var/cache/apt/archives/ 的 所有 已经过期的deb 删掉。
6. apt-get clean  清理缓存
    将 /var/cache/apt/archives/ 的 所有 deb 删掉，可以理解为 rm /var/cache/apt/archives/*.deb。


##### 其它
- PPA
    https://www.cnblogs.com/cute/archive/2012/05/21/2511571.html
    1. PPA 全称为 Personal Package Archives（个人软件包档案） 
    2. FireFox PPA 源：https://launchpad.net/~ubuntu-mozilla-daily/+archive/ppa
    3. add-apt-repository ：在source.list里增删改查 ppa 源。
    4. 安装add-apt-repository 
        apt-get install software-properties-common
    5. 格式
        add-apt-repository ppa:USER/PPA-ANME
        添加源 add-apt-repository -y ppa:fkrull/deadsnakes
        移除源 add-apt-repository -r ppa:jonathonf/python-3.6

##### 配置apt源
1. 源位置
/etc/apt/sources.list

2. 源信息
https://blog.csdn.net/xiangxianghehe/article/details/80112149

3. 配置apt源
获取系统代号：lsb_release -c 
 vi /etc/apt/sources.list
```
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
```
### Centos
1. Red Hat系列 *.rpm
2. rpm: 安装、删除、构建和管理Red Hat的软件包。
    - rpm操作没有安装的软件包，软件包使用的是包全名
    - rpm操作的已经安装的软件，软件包使用的是包名
3. RPM安装软件的默认路径
    /etc  配置文件放置目录
    /usr/bin  一些可执行文件
    /usr/lib  一些程序使用的动态链接库
    /usr/share/doc  一些基本的软件使用手册与说明文件
    /usr/share/man  一些man page档案
4. rmp -qa  查找所有的所有已经安装的软件包
5. rpm -ivh package-name   -U 更新或者安装 -e 删除软件包
6. rpm -e package-name 卸载软件包
6. yum清理已有缓存的软件包信息，创建新的软件包信息缓存
    yum clean all
    yum makecache
7. 查询软件源信息 yum repolist all
8. 彻底删除软件：
    yum history list all
    yum history undo  ID号
9. 下载软件包-在离线服务器上安装
    yum -y install xxx --downloadonly --downloaddir /opt/temp
    yum -y install https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.4.6.0-1.el7.ans.noarch.rpm --downloadonly --downloaddir /opt/temp
    
    - 如无此命令 yum install yum-plugin-downloadonly
    - 默认--downloaddir /var/cache/yum/$basearch/$releasever
    - 在离线的服务上执行安装操作 rpm -ivh *.rpm --nodeps --force 或 yum localinstall -y ./*.rpm
10. 查看依赖性
    yum deplist package
#### 配置yum源
1. 官方源镜像
```conf
[centos-7-base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os
baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
enabled=1
gpgcheck=0
```

2. 其它源 CentOS7
    - 163源 http://mirrors.163.com/.help/CentOS7-Base-163.repo
    - aliyun源 http://mirrors.aliyun.com/repo/Centos-7.repo
    - epel源:是社区强烈打造的免费开源发行软件包版本库，系统包含大概有1万多个软件包 http://mirrors.aliyun.com/repo/epel-7.repo
```bash
curl -o /etc/yum.repos.d/Aliyun-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo

curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo 或
yum install epel-release
```

3. yum仓库管理工具
yum-config-manager
yum-config-manager --add-repo repository_url
### apk
- 参考 http://www.mamicode.com/info-detail-2685312.html
1. 列出所有包：
apk search -v
2. 用通配符搜索包
apk search -v 'php7*'
3. 用包名安装包：
apk add pkgName1 pkgName2
4. 安装本地.apk 文件包
apk add --allow-untrusted /path/to/foo.apk
5. 通过名字删除包
apk del pkgName1 pkgName2   
6. 升级选中包
apk update
apk add -u htop